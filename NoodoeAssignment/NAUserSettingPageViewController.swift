//
//  NAUserSettingPageViewController.swift
//  NoodoeAssignment
//
//  Created by 黃聖傑 on 2018/10/23.
//  Copyright © 2018 seaFoodBon. All rights reserved.
//

import UIKit
//import SwiftyJSON
class NAUserSettingPageViewController: NABaseViewController {
    var userProfile:NAUserProfile!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var timezoneTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "User setting"
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.createDoneToolBar(textField: timezoneTextField)
        self.refreshViewData()
    }
    private func refreshViewData(){
        userNameLabel.text = userProfile.userName
        emailLabel.text = userProfile.email
        timezoneTextField.text = String(userProfile.timezone)
    }
    override func setBackButton() {
        let style = UIBarButtonItem.Style.plain
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "登出", style: style, target: self, action:#selector(self.onBackButtonClicked) )
    }
    
    override func onBackButtonClicked() {
        NANetworkMannager.SESSION_TOKEN = ""
        NANetworkMannager.USER_OBJECT_ID = ""
        super.onBackButtonClicked()
    }
    
    @IBAction func onClickedConfirmButton(_ sender: UIButton) {
        startLoading()
        guard let timezoneString = self.timezoneTextField.text else{ return }
        guard let timezone = Int(timezoneString) else{ return }
        guard !NANetworkMannager.USER_OBJECT_ID.isEmpty else{ return }
        let parameters = [ "timezone": timezone ]
        NANetworkMannager.request(method: .put, catogory: .users, command: NANetworkMannager.USER_OBJECT_ID , parameters: parameters, reponseHandler: setUserProfileHandler)
    }
    private func setUserProfileHandler(isSuccess:Bool,result:Any){
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
            print(json)
            let title = "成功"
            showMessage(title: title, message: "資料已修改成功", handler: nil)
        case false:
            guard let error = result as? Error else{
                assert(false)
                return
            }
//            print(error.localizedDescription)
            let title = "失敗"
            showMessage(title: title, message: "資料修改失敗，請稍後再試", handler: nil)
        }
    }
}
