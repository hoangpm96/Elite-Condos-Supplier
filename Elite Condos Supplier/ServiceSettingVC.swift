//
//  ServiceSettingVC.swift
//  Elite Condos Supplier
//
//  Created by Hien on 3/18/17.
//  Copyright © 2017 Hien. All rights reserved.
//

import UIKit
import ProgressHUD
class ServiceSettingVC: UIViewController {

    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    var services = getServiceData()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ServiceSettingVC: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as! ServiceCell
        cell.service = services[indexPath.row]
        
        
        Api.Service.checkExist(service: services[indexPath.row], onFound: { 
            cell.changeSubscribeLabel(value: true)
            ProgressHUD.showSuccess("Xong")
        }, notFound: { 
            cell.changeSubscribeLabel(value: false)
        }) { (error) in
            print(error)
            ProgressHUD.dismiss()
        }
        return cell
    
    }
}
extension ServiceSettingVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ServiceCell
        Api.Service.checkExist(service: services[indexPath.row], onFound: {
            Api.Service.deleteService(service: self.services[indexPath.row], onDeleted: { 
                cell.changeSubscribeLabel(value: false)
                self.tableView.reloadData()
            })
        }, notFound: {
            Api.Service.subscribe(service: self.services[indexPath.row], onSuccess: { 
                cell.changeSubscribeLabel(value: true)
                 self.tableView.reloadData()
            }, onError: { (error) in
                print(error)
            })
            
        }) { (error) in
            print(error)
        }
    }
    
}
