//
//  ApiClient.swift
//  Weather
//
//  Created by Kevin Huijzendveld on 27/02/2019.
//  Copyright © 2019 Kevin Huijzendveld. All rights reserved.
//

import Foundation
import PromiseKit
import AlamofireImage
import Alamofire_Gloss
import Alamofire
import Gloss

class ApiClient {
    private let session: Alamofire.SessionManager
    private var baseURL: String!
    
    init(prefix: String) {
        self.baseURL = prefix
        DLog("Initialized Client")
        #if DEBUG
                class MyServerTrustPolicyManager: ServerTrustPolicyManager {
                    open override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
                        return ServerTrustPolicy.disableEvaluation
                    }
                }
                
                let imageDownloadSessionManager = SessionManager(
                    configuration: ImageDownloader.defaultURLSessionConfiguration(),
                    serverTrustPolicyManager: MyServerTrustPolicyManager(policies: [:])
                )
                
                UIImageView.af_sharedImageDownloader = ImageDownloader(sessionManager: imageDownloadSessionManager)
                
                self.session = Alamofire.SessionManager(configuration: .default,
                                                        serverTrustPolicyManager: MyServerTrustPolicyManager(policies: [:]))
        #else
                self.session = Alamofire.SessionManager.default
        #endif
    }
    
    private func performApiCall<T: BaseResponse>(_ type: T.Type, method: HTTPMethod, city: String, parameters : Parameters? = nil) -> Promise<T> {
        DLog("Perform api call")
        let url = "\(self.baseURL!)?key=fd83ba402e&locatie=\(city)"
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        return Promise<T> { fulfill, reject in
            self.session.request(urlString, method: method, parameters: parameters, encoding: JSONEncoding.default).responseObject(type, queue: nil) { response in
                switch response.result {
                    case .success(let value):
                        fulfill(value)
                    case .failure(let error):
                        reject(error)
                }
            }
        }
    }
    
    func weather(latLong: String) -> Promise<BaseResponse> {
        return performApiCall(BaseResponse.self, method: .get, city: latLong)
    }
    
    func weather(city: String) -> Promise<BaseResponse> {
        return performApiCall(BaseResponse.self, method: .get, city: city)
    }
}
