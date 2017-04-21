//
//  ServiceListTVC.swift
//  Elite Condos
//
//  Created by Khoa on 11/6/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
class ServiceListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var supplier_Id = ""
    var services = [Service]()
    
    var selectedServices = [String]()
    @IBOutlet weak var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        DataService.ds.REF_SERVICES.observe(.value, with:
            {
                snapshot in
                self.services = []
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                    for snap in snapshots{
                        if let snapData = snap.value as? Dictionary<String,Any>{
                            if let supplierId = snapData["supplierId"] as? String{
                                // edit supplier id here
                                print(snapData)
                                if supplierId == self.supplier_Id{
                                    let service = Service(id: snap.key, data: snapData)
                                    self.services.append(service)
                                }
                            }
                            
                        }
                    }
                    self.tableView.reloadData()
                    
                }})

        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceListCell", for: indexPath) as? ServiceListCell{
            cell.configureCell(service: services[indexPath.row])
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let serviceId = services[indexPath.row].serviceId
     
        let query = DataService.ds.REF_CUSTOMERS.child(userId).child("orders").queryOrdered(byChild: "serviceId").queryEqual(toValue: serviceId)
        
        query.observeSingleEvent(of: .value, with: {
            snapshot in
            
            print(snapshot)
            print("Supplier ID: \(self.supplier_Id)")
                
                DataService.ds.createOrder(supplierId: self.supplier_Id, customerId: userId, orderData: [
                    "create_at" : getCurrentTime(),
                    "status" : ORDER_STATUS.NOTACCEPT.hashValue ,
                    "customerId" : userId,
                    "employeeId" : "1234",
                    "supplierId" : self.supplier_Id,
                    "name" : self.services[indexPath.row].name,
                    "price" : self.services[indexPath.row].price,
                    "serviceId" : serviceId
                    ])
                self.showAlert(title: "Elite Condos", message: "Bạn đã thêm dịch vụ thành công!")
                // create here
          
        })
    }
    
    func showAlert(title: String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


}

