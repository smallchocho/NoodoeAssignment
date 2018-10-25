//
//  NANetworkMannager.swift
//  NoodoeAssignment
//
//  Created by 黃聖傑 on 2018/10/23.
//  Copyright © 2018 seaFoodBon. All rights reserved.
//

import Foundation
//import Alamofire
//import SwiftyJSON
class NANetworkMannager{
    static let SERVER_URL = "https://watch-master-staging.herokuapp.com/api/"
    enum Catogory:String {
        case login = "login"
        case users = "users"
    }
    static var USER_OBJECT_ID:String{
        get{ return NAUserDefaultManager.getString(forKey: .userObjectId)}
        set{ NAUserDefaultManager.setString(forKey:.userObjectId , str: newValue)}
    }
    static var SESSION_TOKEN:String{
        get{ return NAUserDefaultManager.getString(forKey: .sessionToken)}
        set{ NAUserDefaultManager.setString(forKey:.sessionToken , str: newValue)}
    }
    static let USER_NAME = "test2@qq.com"
    static let PASSWORD = "test1234qq"
    static let APPLICATION_ID = "vqYuKPOkLQLYHhk4QTGsGKFwATT4mBIGREI2m8eD"
    static let REST_API_KEY = ""
    static let TIMEOUT_FOR_REQUEST = 30.0
    static let TIMEOUT_FOR_RESOURCE = 60.0
//    static private let alamofireMannager:Alamofire.SessionManager = {
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = TIMEOUT_FOR_REQUEST
//        configuration.timeoutIntervalForResource = TIMEOUT_FOR_RESOURCE
//        configuration.httpMaximumConnectionsPerHost = 20
//        return Alamofire.SessionManager(configuration: configuration)
//        } ()
    static func request(method:HTTPMethod,catogory:Catogory,command:String?,parameters:[String:Any]?,reponseHandler:@escaping (Bool,Any)->()){
        let urlString = SERVER_URL + catogory.rawValue + "/" + (command ?? "")
        var headers:[String:String] = [
            "Content-Type" : "application/json",
            "X-Parse-Application-Id": APPLICATION_ID,
            "X-Parse-REST-API-Key":REST_API_KEY
        ]
        if !SESSION_TOKEN.isEmpty {
            headers["X-Parse-Session-Token"] = SESSION_TOKEN
        }
        guard let url = URL(string: urlString) else{
            let error = NSError()
            DispatchQueue.main.async { reponseHandler(false,error) }
            return
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = TIMEOUT_FOR_REQUEST
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        if let parameters = parameters {
            guard let data = try? JSONSerialization.data(withJSONObject: parameters, options: []) else{
                let error = NSError()
                DispatchQueue.main.async { reponseHandler(false,error) }
                return
            }
            request.httpBody = data
        }
        let session = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            guard error == nil else{
                DispatchQueue.main.async { reponseHandler(false,error!) }
                return
            }
            guard let data = data else{
                let error = NSError()
                DispatchQueue.main.async { reponseHandler(false,error) }
                return
            }
            guard let res = response as? HTTPURLResponse else{
                let error = NSError()
                DispatchQueue.main.async { reponseHandler(false,error) }
                return
            }
            guard res.statusCode < 300 && res.statusCode >= 200 else{
                print(res.statusCode)
                print(res.allHeaderFields)
                let error = NSError()
                DispatchQueue.main.async { reponseHandler(false,error) }
                return
            }
            guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) else{
                let error = NSError()
                DispatchQueue.main.async { reponseHandler(false,error) }
                return
            }
            print(jsonData)
            guard let json = jsonData as? [String:Any] else{
                 let error = NSError()
                 DispatchQueue.main.async { reponseHandler(false,error) }
                 return
            }
            if let token = json["sessionToken"] as? String{
                SESSION_TOKEN = token
            }
            if let id = json["objectId"] as? String{
                USER_OBJECT_ID = id
            }
            DispatchQueue.main.async { reponseHandler(true,jsonData) }
        }
        session.resume()
    }
    
    
    
//    static func requestForAlamorfire(method:HTTPMethod,catogory:Catogory,command:String?,parameters:[String:Any]?,reponseHandler:@escaping (Bool,Any)->()){
//        let url = SERVER_URL + catogory.rawValue + "/" + (command ?? "")
//        var headers:[String:String] = [
//            "Content-Type" : "application/json",
//            "X-Parse-Application-Id": APPLICATION_ID,
//            "X-Parse-REST-API-Key":REST_API_KEY
//        ]
//        if !SESSION_TOKEN.isEmpty {
//            headers["X-Parse-Session-Token"] = SESSION_TOKEN
//        }
//        alamofireMannager.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
//            switch response.result{
//            case .success(let value):
//                let json = JSON(value)
//                if let token = json["sessionToken"].string{
//                    SESSION_TOKEN = token
//                }
//                if let id = json["objectId"].string{
//                    USER_OBJECT_ID = id
//                }
//                reponseHandler(true,json)
//            case .failure(let error):
//                print(error.localizedDescription)
//                reponseHandler(false,error)
//            }
//        }
//    }
}
public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}
