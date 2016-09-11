//
//  TruckerAPI.swift
//  Trucker
//
//  Created by Nico Hänggi on 10/09/16.
//  Copyright © 2016 Nico Hänggi. All rights reserved.
//

import Foundation
import Alamofire

class TruckerAPI: NSObject {
    
    var baseURL : String
    
    init(baseURL: String = "http://localhost:9000") {
        self.baseURL = baseURL
    }
    
    func register(username: String = "", token: String = "", completionHandler: (AnyObject) -> Void) {
        Alamofire.request(.POST, self.baseURL + "/register", parameters: [ "identifier" : username, "token" : token], encoding: .JSON)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success(let json):
                    completionHandler(json)
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    
    func login(response: String = "", completionHandler: (AnyObject) -> Void) {
        print("creating request")
        print(self.baseURL + response)
        Alamofire.request(.POST, self.baseURL + response, parameters: [ "action" : ["type": "AuthenticationResponseAction", "success" : true] ], encoding: .JSON)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success(let json):
                    completionHandler(json)
                case .Failure(let error):
                    print(error)
                }
        }
    }

}
