//
//  ViewController.swift
//  NoodoeAssignment
//
//  Created by 黃聖傑 on 2018/10/23.
//  Copyright © 2018 seaFoodBon. All rights reserved.
//

import UIKit
//import SwiftyJSON
class NALoginViewController: NABaseViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Login"
        self.isShowBackButton = false
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @IBAction func onClickedLoginButton(_ sender: UIButton) {
        self.sendLoginReguest()
    }
    
    private func sendLoginReguest(){
        startLoading()
        let parameters = [
            "username":NANetworkMannager.USER_NAME,
            "password":NANetworkMannager.PASSWORD
        ]
        NANetworkMannager.request(method: .post, catogory: .login, command: nil, parameters: parameters, reponseHandler: loginResPonseHandler)
    }
    
    private func loginResPonseHandler(isSuccess:Bool,result:Any){
        stopLoading()
        switch isSuccess {
        case true:
//            guard let json = result as? JSON else{
//                assert(false)
//                return
//            }
            guard let json = result as? [String:Any] else{
                assert(false)
                return
            }
            guard let userName = json["username"] as? String ,let email = json["email"] as? String ,let timezone = json["timezone"] as? Int else{
                let title = "失敗"
                showMessage(title: title, message: "登入失敗，請稍後再試", handler: nil)
                return
            }
            let userProfile = NAUserProfile(userName: userName, email: email,timezone:timezone)
            print(userProfile)
            self.goToUserSettingViewController(profile: userProfile)
        case false:
            guard let error = result as? Error else{
                assert(false)
                return
            }
            print(error.localizedDescription)
            let title = "失敗"
            showMessage(title: title, message: "登入失敗，請稍後再試", handler: nil)
        }
    }
    
    
    private func goToUserSettingViewController(profile:NAUserProfile){
        guard let vc = UIStoryboard(name: "NAUserSettingPageViewController", bundle: nil).instantiateInitialViewController() as? NAUserSettingPageViewController else{ return }
        vc.userProfile = profile
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

