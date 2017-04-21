//
//  CustomerMenuTVC.swift
//  Elite Condos
//
//  Created by Khoa on 11/6/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
class CustomerMenuTVC: UITableViewController {
    @IBOutlet weak var usernameLbl: UILabel!

    @IBOutlet weak var avatarImage: CircleImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 48/255, green: 49/255, blue: 77/255, alpha: 1.0)
        
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let cutomer_id = UserDefaults.standard.string(forKey: USER_ID)
        DataService.ds.REF_CUSTOMERS.child(cutomer_id!).observeSingleEvent(of: .value, with: {
            snapshot in
            if let snapshot = snapshot.value as? Dictionary<String,Any>{
                if let name = snapshot["name"] as? String{
                    self.usernameLbl.text = name
                }
            }
        })
    }

   
    @IBAction func logoutBtn(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
            UserDefaults.standard.removeObject(forKey: CUSTOMER_ID)
            print("signout")
            print("\(UserDefaults.standard.string(forKey: CUSTOMER_ID))")
            performSegue(withIdentifier: "StartVC", sender: nil)
        }
        catch{
            print("can't sign out")
        }
        
    }

}
