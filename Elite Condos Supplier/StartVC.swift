//
//  StartVC.swift
//  Elite Condos
//
//  Created by Khoa on 11/14/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit

class StartVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if ( Api.User.CURRENT_USER != nil   ){
            self.performSegue(withIdentifier: "StartToHome", sender: nil)
            
        }
    }
    @IBAction func signUpButton(_ sender: Any) {
        performSegue(withIdentifier: "SupplierSignUp", sender: nil)
    }
    @IBAction func signInButton(_ sender: Any) {
        performSegue(withIdentifier: "SupplierSignIn", sender: nil)
    }
   

}
