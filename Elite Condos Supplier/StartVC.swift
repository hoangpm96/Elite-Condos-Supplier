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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let homeVC = storyboard.instantiateViewController(withIdentifier: "SideMenuID")
//        present(homeVC, animated: true, completion: nil)
       
    }

    
    @IBAction func signUpButton(_ sender: Any) {
       
        performSegue(withIdentifier: "SupplierSignUp", sender: nil)
        
    }
   
  
    @IBAction func signInButton(_ sender: Any) {
        performSegue(withIdentifier: "SupplierSignIn", sender: nil)
    
    }
   

}
