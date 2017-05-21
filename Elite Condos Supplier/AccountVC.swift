//
//  AccountVC.swift
//  Elite Condos Supplier
//
//  Created by Khoa on 5/14/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit

import UIKit
import ProgressHUD
class AccountVC: UIViewController {
    @IBOutlet weak var avatarImg: CircleImage!
    @IBOutlet weak var nameTF: FancyField!
    
    @IBOutlet weak var phoneTF: FancyField!
    @IBOutlet weak var emailTF: FancyField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ProgressHUD.show("")
        
        Api.User.downloadUserImage(onError: { (error) in
            print(error)
        }) { (img) in
            self.avatarImg.image = img
        }
        
        Api.User.loadUserData { (name, email, phone ) in
            self.updateUI(name: name, email: email, phone: phone)
            ProgressHUD.dismiss()
        }
        
        nameTF.delegate = self
        phoneTF.delegate = self
        emailTF.delegate = self
        
    }
    
    func updateUI(name: String, email: String, phone: String){
        nameTF.text = name
        emailTF.text = email
        phoneTF.text = phone
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signOut_TouchInside(_ sender: Any) {
        Api.User.signOut(onSuccess: {
            let storyboard = UIStoryboard.init(name: "Start", bundle: nil)
            let homeVC = storyboard.instantiateViewController(withIdentifier: "StartVC")
            self.present(homeVC, animated: true, completion: nil)
        }) { (error) in
            print(error)
        }
        
    }
}
extension AccountVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        nameTF.resignFirstResponder()
        phoneTF.resignFirstResponder()
        emailTF.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        ProgressHUD.show("")
        
        if textField == nameTF{
            // API here
            if let name = textField.text {
                Api.User.updateName(name: name, onSuccess: {
                    ProgressHUD.showSuccess("Đã cập nhật tên mới")
                })
                
            }
        }
        if textField == emailTF{
            
            if let email = textField.text {
                print(email)
                
                Api.User.updateEmail(email: email, onError: { (error) in
                    print(error)
                }, onSuccess: {
                    Api.User.signOut(onSuccess: {
                        let storyboard = UIStoryboard.init(name: "Start", bundle: nil)
                        let homeVC = storyboard.instantiateViewController(withIdentifier: "StartVC")
                        self.present(homeVC, animated: true, completion: nil)
                    }, onError: { (error) in
                        print(error)
                    })
                })
                
            }
            
        }
        if textField == phoneTF{
            if let phone = textField.text {
                Api.User.updatePhone(phone: phone, onSuccess: {
                    ProgressHUD.showSuccess("Đã cập nhật số điện thoại mới")
                })
            }
            
        }
    }
}
