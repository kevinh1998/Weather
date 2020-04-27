//
//  Wireframe.swift
//  Weather
//
//  Created by Kevin Huijzendveld on 27/02/2019.
//  Copyright © 2019 Kevin Huijzendveld. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

class Wireframe: LoadingViewWireframe, HomeViewWireframe {
    public let window : UIWindow
    private var apiClient: ApiClient!
    
    private var topController: UIViewController? {
        var topViewController = self.window.rootViewController
        while(topViewController?.presentedViewController != nil) { topViewController = topViewController?.presentedViewController }
        return topViewController
    }
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func applicationStartup(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let prefix = Bundle.main.infoDictionary?["APIBaseURL"] as! String
        
        self.apiClient = ApiClient(prefix: prefix)
        
        self.showLoadingScreen()
    }
    
    func showLoadingScreen() {
        self.window.rootViewController = LoadingViewController(wireframe: self, apiClient: apiClient)
    }
    
    func loadingComplete(_ viewController: LoadingViewController, weather: Weather?, liveLocation: Bool) {
        let home = HomeViewController(wireframe: self, apiClient: apiClient, weather: weather, liveLocation: liveLocation)
        self.window.rootViewController = home
    }
    
}
