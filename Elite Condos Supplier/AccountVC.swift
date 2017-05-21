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
    
    var imagePicker : UIImagePickerController!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(changeAvatar))
        avatarImg.addGestureRecognizer(tapped)
        avatarImg.isUserInteractionEnabled = true
        
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        
        FirRef.SUPPLIERS.child(Api.User.currentUid()).observe(.value, with: { (snapshot) in
            ProgressHUD.show("Updating....")
            if let dict  = snapshot.value as? [String:Any] {
                if let newAvatar = dict["logoUrl"] as? String{
                    ProgressHUD.showSuccess("✓")
                    let url = URL(string: newAvatar)
                    self.avatarImg.sd_setImage(with: url)
                }
                
            }
        })
        
        
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
    
    func changeAvatar(){
        present(imagePicker, animated: true, completion: nil)
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
    
    func showAlert(title: String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }

    
}

extension AccountVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage{
            
            Api.User.updateAvatar(image: img, onSuccess: { (successMessage) in
                self.avatarImg.image = img
            }, onError: { (error) in
                self.showAlert(title: "Lỗi", message: error)
            })
            
            
        }else{
            self.showAlert(title: "Lỗi", message: "Không thể chọn hình")
            self.imagePicker.dismiss(animated: true, completion: nil)
        }
        self.imagePicker.dismiss(animated: true, completion: nil)
        
        
        
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
        
        ProgressHUD.show("Updating...")
        
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
                    ProgressHUD.dismiss()
                    self.showAlert(title: "Lỗi", message: error)
                    return
                }, onSuccess: {
                    ProgressHUD.showSuccess("✓")
                    Api.User.signOut(onSuccess: {
                        let storyboard = UIStoryboard.init(name: "Start", bundle: nil)
                        let homeVC = storyboard.instantiateViewController(withIdentifier: "StartVC")
                        self.present(homeVC, animated: true, completion: nil)
                    }, onError: { (error) in
                        ProgressHUD.dismiss()
                        self.showAlert(title: "Lỗi", message: error)
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
