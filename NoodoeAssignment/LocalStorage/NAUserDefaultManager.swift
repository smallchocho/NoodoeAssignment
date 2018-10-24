//
//  NAUserDefaultMannager.swift
//  NoodoeAssignment
//
//  Created by 黃聖傑 on 2018/10/24.
//  Copyright © 2018 seaFoodBon. All rights reserved.
//

import Foundation
enum NAUserDefaulKey:String {
    case userObjectId = "userObjectId"
    case sessionToken = "sessionToken"
}
class NAUserDefaultManager{
    static func setString(forKey:NAUserDefaulKey , str:String){
        UserDefaults.standard.set(str, forKey: forKey.rawValue)
        UserDefaults.standard.synchronize()
    }
    static func getString(forKey:NAUserDefaulKey) -> String{
        let value = UserDefaults.standard.string(forKey:forKey.rawValue) ?? ""
        return value
    }
    static func setBool(forKey:NAUserDefaulKey , bool:Bool){
        UserDefaults.standard.set(bool, forKey: forKey.rawValue)
        UserDefaults.standard.synchronize()
    }
    static func getBool(forKey:NAUserDefaulKey) -> Bool{
        let value = UserDefaults.standard.bool(forKey: forKey.rawValue)
        return value
    }
}
