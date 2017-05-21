//
//  SupplierSignUp.swift
//  Elite Condos
//
//  Created by Khoa on 11/16/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var pickLogoLbl: UILabel!
    @IBOutlet weak var passwordLbl: FancyField!
    @IBOutlet weak var phoneLbl: FancyField!
    @IBOutlet weak var addressLbl: FancyField!
    @IBOutlet weak var emailLbl: FancyField!
    @IBOutlet weak var nameLbl: FancyField!
    @IBOutlet weak var logoImage: UIImageView!
    
    var imagePicker : UIImagePickerController!
    var _userCreated = false
    var isPickedImage = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage{
            logoImage.image = img
            isPickedImage = true
            pickLogoLbl.isHidden = true
            logoImage.isHidden = false
        }else{
            print("Can't show image picker")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickLogoBtn(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        
        guard let name = nameLbl.text, name != "" else {
            showAlert(title: SIGN_UP_ERROR, message: SIGN_UP_ERROR_NAME)
            return
        }
        guard let email = emailLbl.text, let password = passwordLbl.text, email != "" , password != "" else {
            showAlert(title: SIGN_UP_ERROR, message: SIGN_UP_ERROR_EMAIL_PASSWORD)
            return
        }
        guard let address = addressLbl.text, address != "" else {
            showAlert(title: SIGN_UP_ERROR, message: SIGN_UP_ERROR_ADDRESS)
            return
        }
        guard let phone = phoneLbl.text, phone != "" else {
            showAlert(title: SIGN_UP_ERROR, message: SIGN_UP_ERROR_PHONE)
            return
        }
        guard isPickedImage == true else {
            showAlert(title: "Lỗi", message: "Vui lòng chọn logo")
            return
        }
        
        ProgressHUD.show("Đang đăng ký")
        Api.User.signUp(name: name, email: email, password: password, phone: phone, address: address,  avatarImg: logoImage.image!, onSuccess: {
            ProgressHUD.dismiss()
            let alert = UIAlertController(title: APP_NAME, message: "Đăng ký thành công!", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Đăng Nhập", style: .default, handler: {
                action in
                self.performSegue(withIdentifier: "SignUpToHomeVC", sender: nil)
            })
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }) { (error) in
            ProgressHUD.dismiss()
            self.showAlert(title: "Lỗi đăng ký", message: error)
        }
        
    }
    
    // MARK: Functions
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func showAlert(title: String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
