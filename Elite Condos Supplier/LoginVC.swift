//
//  LoginVC.swift
//  Elite Condos
//
//  Created by Khoa on 11/14/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
class LoginVC: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var passwordTF: FancyField!
    @IBOutlet weak var emailTF: FancyField!
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func loginButton(_ sender: Any) {
        
        
        guard let email = emailTF.text, email != "" else {
            showAlert(title: SIGN_IN_ERROR, message: SIGN_IN_ERROR_EMAIL)
            return
        }
        guard let password = passwordTF.text, password != "" else {
            showAlert(title: SIGN_IN_ERROR, message: SIGN_IN_ERROR_PASSWORD)
            return
        }
        
        ProgressHUD.show("Logging...")
        AuthService.login(email: email, password: password, onSuccess: {
            ProgressHUD.showSuccess("✓")
            self.performSegue(withIdentifier: "LoginToSupplierHome", sender: nil)
            
        }) { (errorDetail) in
            ProgressHUD.dismiss()
            self.showAlert(title: APP_NAME, message: errorDetail)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        passwordTF.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func showAlert(title: String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)


        present(alert, animated: true, completion: nil)
        
    }

 
    @IBAction func goToSignInBtn(_ sender: Any) {
        
        performSegue(withIdentifier: "GoToSignIn", sender: nil)
        
    }
    
}
