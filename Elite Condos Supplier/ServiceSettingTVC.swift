//
//  SupplierSetting.swift
//  Elite Condos
//
//  Created by Khoa on 11/16/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
class ServiceSettingTVC: UITableViewController{
    @IBOutlet weak var servicePickerBtn: UIButton!
    
    @IBOutlet weak var addServiceView: FancyView!
    @IBOutlet weak var pickingServiceBtn: FancyBtn!
    
    @IBOutlet weak var servicePicker: UIPickerView!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    
    var services = [Service]()
    
    var availableServices = ["Sửa điện", "Sửa nước", "Trang trí nhà"]
    var currentService = ""
    var serviceList = [String]()
    var hasChoseService = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
    }

    
    @IBAction func pickServiceBtn(_ sender: Any) {
        if availableServices.count == 0 {
            servicePicker.isHidden = true
            showAlert(title: APP_NAME, message: "Ba da them het cac dich vu co san")
        }else {
            servicePicker.isHidden = false
            addServiceView.isHidden = true
            currentService = ""
            hasChoseService = false
        }
    }
    
    
    
    @IBAction func questionMarkBtn(_ sender: Any) {
        
    }
    @IBAction func addServiceBtn(_ sender: Any) {
        if availableServices.count == 0 {
            servicePicker.isHidden = true
            showAlert(title: APP_NAME, message: "Ba da them het cac dich vu co san")
            return 
        }
        if hasChoseService == true{
            
            Api.Service.addService(name: currentService, onSuccess: { (success) in
                self.showAlert(title: APP_NAME, message: success)
            }, onError: { (error) in
                self.showAlert(title: APP_NAME, message: error)
            })        }
        else {
            showAlert(title: APP_NAME, message: "Bạn chưa chọn dịch vụ")
        }
        
       
        
    }
    
    // MARK: Functions
    func showAlert(title: String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}




