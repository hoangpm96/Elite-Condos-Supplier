//
//  PasswordUpdateVC.swift
//  Elite Condos Supplier
//
//  Created by Khoa on 5/14/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit

import UIKit
import ProgressHUD
class PasswordUpdateVC: UIViewController {
    @IBOutlet weak var passwordTF: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBAction func updatePassword_TouchInside(_ sender: Any) {
        guard let password = passwordTF.text, password != "" else {
            showAlert(title: APP_NAME, message: "Vui lòng nhập mật khẩu mới")
            return
        }
        
        
        
        updatePassword(password: password, onError: { (error) in
            self.showAlert(title: APP_NAME, message: error)
        }) {
            Api.User.signOut(onSuccess: {
                
                let storyboard = UIStoryboard.init(name: "Start", bundle: nil)
                let homeVC = storyboard.instantiateViewController(withIdentifier: "StartVC")
                self.present(homeVC, animated: true, completion: nil)
            }) { (error) in
                print(error)
            }
            
        }
    }
    
    func updatePassword(password: String, onError: @escaping (String) -> Void,
                        onSuccess: @escaping () -> Void){
        Api.User.updatePassword(password: password) { (error) in
            onError(error)
            return
        }
        
        onSuccess()
        
    }
    
    func showAlert(title: String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
