//
//  NABaseViewController.swift
//  NoodoeAssignment
//
//  Created by 黃聖傑 on 2018/10/23.
//  Copyright © 2018 seaFoodBon. All rights reserved.
//

import UIKit
import JGProgressHUD
class NABaseViewController:UIViewController{
    var isShowBackButton:Bool = true
    var isLoading = false
    let hud = JGProgressHUD(style: .dark)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isShowBackButton{ self.setBackButton() }
    }
    
    func setBackButton() {
        let image = UIImage(named: "gc_nav_btn_prev")
        let style = UIBarButtonItem.Style.plain
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: style, target: self, action: #selector(self.onBackButtonClicked))
    }
    @objc func onBackButtonClicked(){
        let _ = navigationController?.popViewController(animated: true)
    }
    func startLoading() {
        if isLoading { return }
        
        navigationItem.leftBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.isEnabled = false
        isLoading = true
        hud?.show(in: self.view)
    }
    
    func stopLoading() {
        if !isLoading { return }
        
        navigationItem.leftBarButtonItem?.isEnabled = true
        navigationItem.rightBarButtonItem?.isEnabled = true
        hud?.dismiss()
        isLoading = false
    }
    
    func showMessage(title: String?, message: String, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let title = "確定"
        let action = UIAlertAction(title: title, style: UIAlertAction.Style.default, handler: handler)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showMessage(title: String, message: String, yesTitle: String, noTitle: String, yesHandler:((UIAlertAction) -> Void)?, noHandler: ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: yesTitle, style: .default, handler: yesHandler)
        alert.addAction(yesAction)
        let noAction = UIAlertAction(title: noTitle, style: .cancel, handler: noHandler)
        alert.addAction(noAction)
        alert.preferredAction = yesAction
        self.present(alert, animated: true, completion: nil)
    }
    
    func createDoneToolBar(textField: UITextField) {
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: textField, action: #selector(textField.resignFirstResponder))
        textField.inputAccessoryView = self.createDoneToolBar(items: [space, done])
    }
    
    fileprivate func createDoneToolBar(items: [UIBarButtonItem]) -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.items = items
        toolBar.tintColor = UIColor.blue
        toolBar.barTintColor = UIColor.white
        toolBar.isTranslucent = false
        toolBar.sizeToFit()
        return toolBar
    }
    
}


