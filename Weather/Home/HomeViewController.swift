//
//  WMHomeViewController.swift
//  Weather
//
//  Created by Kevin Huijzendveld on 09/01/2018.
//  Copyright (c) 2018 Kevin Huijzendveld. All rights reserved.
//
//

import UIKit
import PromiseKit
import ViewAnimator
import CoreLocation
import NotificationBannerSwift
import KeychainSwift

protocol HomeViewWireframe {
    
}

class HomeViewController: UIViewController, CLLocationManagerDelegate, HomeViewDelegate {
    private let wireframe: HomeViewWireframe
    private let apiClient: ApiClient
    private let weather: Weather?
    private var detailInfo: [DetailInfo] = []
    let locationManager = CLLocationManager()
    var firstLocation = true
    var liveLocation: Bool
    var city = ""
    
    init(wireframe: HomeViewWireframe, apiClient: ApiClient, weather: Weather?, liveLocation: Bool) {
        self.wireframe = wireframe
        self.weather = weather
        self.apiClient = apiClient
        self.liveLocation = liveLocation
        
        KeychainSwift().set(liveLocation, forKey: "liveLocation")
        
        if let plaats = weather?.plaats {
            self.city = plaats
        }
        
        super.init(nibName: "HomeView", bundle: .main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        setInfo(weather: weather)
    }
    
    func setInfo(weather: Weather?) {
        detailInfo.removeAll()
        if let alarmtext = weather?.alarmtxt {
            let banner = FloatingNotificationBanner(title: "Wees op uw hoeden!", subtitle: alarmtext, style: .danger)
            banner.duration = 5
            banner.onSwipeUp = {
                banner.dismiss()
            }
            banner.show(on: self)
        }
        
        if let sup = weather?.sup, let sunder = weather?.sunder, let neerslag = weather?.d0neerslag, let lv = weather?.lv, let windk = weather?.windkmh, let windr = weather?.windr, let gtemp = weather?.gtemp, let max = weather?.d0tmax, let min = weather?.d0tmin {
            detailInfo.append(DetailInfo(title: "Zonsopgang", value: "\(sup)"))
            detailInfo.append(DetailInfo(title: "Zonsondergang", value: "\(sunder)"))
            detailInfo.append(DetailInfo(title: "Kans op neerslag", value: "\(neerslag)%"))
            detailInfo.append(DetailInfo(title: "Luchtvochtigheid", value: "\(lv)%"))
            detailInfo.append(DetailInfo(title: "Wind", value: "\(windr) \(Int(windk.rounded())) km/h"))
            detailInfo.append(DetailInfo(title: "Gevoelstemperatuur", value: "\(Int(gtemp.rounded()))°"))
            detailInfo.append(DetailInfo(title: "Max temperatuur", value: "\(max)°"))
            detailInfo.append(DetailInfo(title: "Min temperatuur", value: "\(min)°"))
        }
        
        if let view = view as? HomeView {
            view.delegate = self
            view.setBasicInfo(weather: weather)
            view.setDetailInfo(detailInfo, animated: true)
            view.setLocationButtonState(isLiveLocation: self.liveLocation)
        }
    }
    
    @IBAction func refreshButtonWasPressed(_ sender: UIButton) {
        let animation = AnimationType.rotate(angle: 1)
        sender.animate(animations: [animation])
        
        detailInfo.removeAll()
        
        if liveLocation {
            let status = CLLocationManager.authorizationStatus()
            if status == .denied || status == .restricted {
                showLocationAlert()
            } else {
                getLiveLocation()
            }
        } else {
            refreshInfo(city: self.city)
        }
    }
    
    func getLiveLocation() {
        firstLocation = true
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let latLong = "\(location.latitude),\(location.longitude)"
        DLog(latLong)
        if firstLocation {
            refreshInfo(latLong: latLong)
            firstLocation = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DLog("error:: \(error.localizedDescription)")
    }
    
    func refreshInfo(latLong: String) {
        firstly {
            self.apiClient.weather(latLong: latLong)
        }.then { response -> Void in
            self.liveLocation = true
            KeychainSwift().set(self.liveLocation, forKey: "liveLocation")
            self.setInfo(weather: response.liveweer?.first)
        }.catch { error in
            DLog(error)
        }
    }
    
    func refreshInfo(city: String) {
        firstly {
            self.apiClient.weather(city: city)
        }.then { response -> Void in
            if let plaats = response.liveweer?.first?.plaats, plaats == "De Bilt" && plaats.lowercased() != city.lowercased() {
                self.showAlert(title: "Ongeldige locatie", message: "De ingevulde locatie kan niet worden gevonden, probeer opnieuw.")
            } else {
                self.liveLocation = false
                KeychainSwift().set(self.liveLocation, forKey: "liveLocation")
                self.setInfo(weather: response.liveweer?.first)
            }
        }.catch { error in
            DLog(error)
        }
    }
    
    func homeHeader(_ home: HomeView) {
        let tomorrow = TomorrowViewController(data: weather)
        self.present(tomorrow, animated: true, completion: nil)
    }
    
    func homeFooter(_ home: HomeView) {
        let overmorrow = OvermorrowViewController(data: weather)
        self.present(overmorrow, animated: true, completion: nil)
    }
    
    func homeLive(_ home: HomeView) {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
        case .denied, .restricted:
            showLocationAlert()
            return
        case .authorizedAlways, .authorizedWhenInUse:
            if !liveLocation {
                getLiveLocation()
            }
            break
        }
    }
    
    func home(_ home: HomeView, didSearch city: String) {
        KeychainSwift().set(city, forKey: "city")
        self.city = city
        refreshInfo(city: city)
    }
}
