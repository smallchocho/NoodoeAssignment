//
//  NANetworkMannager.swift
//  NoodoeAssignment
//
//  Created by 黃聖傑 on 2018/10/23.
//  Copyright © 2018 seaFoodBon. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class NANetworkMannager{
    static let SERVER_URL = "https://watch-master-staging.herokuapp.com/api/"
    enum Catogory:String {
        case login = "login"
        case users = "users"
    }
    static var USER_OBJECT_ID:String?
    static var SESSION_TOKEN:String?
    static let USER_NAME = "test2@qq.com"
    static let PASSWORD = "test1234qq"
    static let APPLICATION_ID = "vqYuKPOkLQLYHhk4QTGsGKFwATT4mBIGREI2m8eD"
    static let REST_API_KEY = ""
    static let TIMEOUT_FOR_REQUEST = 30.0
    static let TIMEOUT_FOR_RESOURCE = 60.0
    static private let alamofireMannager:Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TIMEOUT_FOR_REQUEST
        configuration.timeoutIntervalForResource = TIMEOUT_FOR_RESOURCE
        configuration.httpMaximumConnectionsPerHost = 20
        return Alamofire.SessionManager(configuration: configuration)
        } ()
    static func request(method:HTTPMethod,catogory:Catogory,command:String?,parameters:[String:Any]?,reponseHandler:@escaping (Bool,Any)->()){
        let url = SERVER_URL + catogory.rawValue + "/" + (command ?? "")
        var headers:[String:String] = [
            "Content-Type" : "application/json",
            "X-Parse-Application-Id": APPLICATION_ID,
            "X-Parse-REST-API-Key":REST_API_KEY
        ]
        if let token = SESSION_TOKEN{
            headers["X-Parse-Session-Token"] = token
        }
        
        alamofireMannager.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                if let token = json["sessionToken"].string{
                    SESSION_TOKEN = token
                }
                if let id = json["objectId"].string{
                    USER_OBJECT_ID = id
                }
                reponseHandler(true,json)
            case .failure(let error):
                print(error.localizedDescription)
                reponseHandler(false,error)
            }
        }
    }
}