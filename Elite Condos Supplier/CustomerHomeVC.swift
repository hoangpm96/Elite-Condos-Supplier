//
//  ServiceVC.swift
//  Elite Condos
//
//  Created by Khoa on 11/6/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
class CustomerHomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    var suppliers = [Supplier]()
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
            tableView.delegate = self
            tableView.dataSource = self
        
        DataService.ds.REF_SUPPLIERS.observeSingleEvent(of: .value, with:
            {
                snapshot in
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                    
                    for snap in snapshots{
                       // print(snap.value)
                        if let snapData = snap.value as? Dictionary<String,Any>{
                            
                            let supplier = Supplier(id: snap.key, data: snapData)
                            self.suppliers.append(supplier)
                        }
                    }
                    self.tableView.reloadData()
                }})

        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suppliers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SupplierCell", for: indexPath) as? SupplierCell{
            cell.configureCell(supplier: suppliers[indexPath.row])
            return cell
        }else{
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = suppliers[indexPath.row].id
        performSegue(withIdentifier: "ServiceListVC", sender: id )
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ServiceListVC" {
            if let destinationVC = segue.destination as? ServiceListVC{
                if let supplierId = sender as? String{
                    destinationVC.supplier_Id = supplierId
                }
            }
        }
    }
   
}
