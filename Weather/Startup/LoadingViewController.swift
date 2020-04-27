//
//  LoadingViewController.swift
//  Weather
//
//  Created by Kevin Huijzendveld on 27/02/2019.
//  Copyright © 2019 Kevin Huijzendveld. All rights reserved.
//

import UIKit
import PromiseKit
import CoreLocation
import KeychainSwift

protocol LoadingViewWireframe {
    func loadingComplete(_ viewController: LoadingViewController, weather: Weather?, liveLocation: Bool)
}

class LoadingViewController: UIViewController, CLLocationManagerDelegate, LoadingViewDelegate {
    private let wireframe: LoadingViewWireframe
    private let apiClient: ApiClient
    let locationManager = CLLocationManager()
    var firstLocation = true
    
    init(wireframe: LoadingViewWireframe, apiClient: ApiClient) {
        self.wireframe = wireframe
        self.apiClient = apiClient
        
        super.init(nibName: "LoadingView", bundle: .main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
    }
    
    func getLiveLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestLocation()
    }
    
    private func load(latLong: String) {
        firstly {
            self.apiClient.weather(latLong: latLong)
        }.then { response -> Void in
            self.wireframe.loadingComplete(self, weather: response.liveweer?.first, liveLocation: true)
        }.catch { error in
            DLog(error)
        }
    }
    
    private func load(city: String) {
        firstly {
            self.apiClient.weather(city: city)
        }.then { response -> Void in
            if let plaats = response.liveweer?.first?.plaats, plaats == "De Bilt" && plaats.lowercased() != city.lowercased() {
                self.showAlert(title: "Ongeldige locatie", message: "De ingevulde locatie kan niet worden gevonden, probeer opnieuw.")
            } else {
                self.wireframe.loadingComplete(self, weather: response.liveweer?.first, liveLocation: false)
            }
        }.catch { error in
            DLog(error)
        }
    }
    
    @IBAction func locationButtonPressed(_ sender: DesignableButton) {
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                DLog("Settings opened: \(success)")
            })
        }
    }
    
    func loading(_ loading: LoadingView, didSearch city: String) {
        KeychainSwift().set(city, forKey: "city")
        load(city: city)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let latLong = "\(location.latitude),\(location.longitude)"
        DLog(latLong)
        if firstLocation {
            load(latLong: latLong)
            firstLocation = false
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DLog("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedAlways, .authorizedWhenInUse:
            if let liveLocation = KeychainSwift().getBool("liveLocation"), liveLocation {
                getLiveLocation()
            } else {
                if let city = KeychainSwift().get("city") {
                    load(city: city)
                } else {
                    if let view = view as? LoadingView {
                        view.delegate = self
                        view.setViews()
                    }
                }
            }
            break
        default:
            if let city = KeychainSwift().get("city") {
                load(city: city)
            } else {
                if let view = view as? LoadingView {
                    view.delegate = self
                    view.setViews()
                }
            }
            break
        }
    }
}
