//
//  CustomerOrderVC.swift
//  Elite Condos
//
//  Created by Khoa on 11/19/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
class CustomerOrderVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    var isOnGoingClicked = true
    var orders = [Order]()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        

        DataService.ds.REF_CUSTOMERS.child(userId).child("orders").queryOrdered(byChild: "status").queryEqual(toValue: ORDER_STATUS.ONGOING.hashValue).observe(.value, with: {
            snapshot in
            print("CustomerOrder")
            print(snapshot)
            self.orders = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshots {
                    if let snapData = snap.value as? Dictionary<String, Any>{
                        let order = Order(id: snap.key, data: snapData)
                        self.orders.append(order)
                    }
                }
                self.tableView.reloadData()
            }})
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Customer_OrderCell", for: indexPath) as? Customer_OrderCell{
            cell.configureCell(order: orders[indexPath.row])
            return cell
            }
        else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let serviceId = orders[indexPath.row].id
        let supplierId = orders[indexPath.row].supplierId
        
        print(" Hello:  \(serviceId) - \(userId) ")
        
        let alert = UIAlertController(title: "Elite Condos", message: "", preferredStyle: .actionSheet)
        
        let confirm = UIAlertAction(title: "Xác nhận đơn hàng thành công!", style: .default, handler: {
            action in
            
            var supplierName = ""
            DataService.ds.REF_CUSTOMERS.child(self.orders[indexPath.row].customerId).observeSingleEvent(of: .value, with: {
                snapshot in
                if let snapData = snapshot.value as? Dictionary<String,Any>{
                    if let name = snapData["name"] as? String{
                       supplierName = name
                    }
                }
            })
            
             self.performSegue(withIdentifier: "AddRatingVC", sender:
                ["supplierName" : supplierName,
                 "serviceName" : self.orders[indexPath.row].serviceName,
                 "price" : self.orders[indexPath.row].price,
                 "supplierId" : supplierId,
                 "orderId" : self.orders[indexPath.row].id])
            
            
        })
        
        let cancelOrder = UIAlertAction(title: "Hủy đơn hàng", style: .default, handler: {
            action in
            
            // update order status - cancel
            
            DataService.ds.updateOrders(orderId: serviceId, supplierId: supplierId, customerId: userId, status : ORDER_STATUS.CANCEL)
            
            
        })
        let cancel = UIAlertAction(title: "Hủy", style: .cancel, handler: nil)
        
        
        if ( isOnGoingClicked  ){
            alert.addAction(confirm)
            alert.addAction(cancelOrder)
            
        }
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddRatingVC"{
            if let addRatingVC = segue.destination as? AddRatingVC{
                if let passData = sender as? Dictionary<String,String>{
                    print(passData)
                    if let supplierId = passData["supplierName"]{
                        addRatingVC.supplierName = supplierId
                    }
                    if let serviceName = passData["serviceName"]{
                        addRatingVC.serviceName = serviceName
                    }
                    if let price = passData["price"]{
                        addRatingVC.price = price
                    }
                    if let supplierId = passData["supplierId"]{
                        addRatingVC.supplierId = supplierId
                    }
                    if let orderId = passData["orderId"]{
                        addRatingVC.orderId = orderId
                    }
                }
            }
        }
    }
  
    @IBAction func onGoingBtn(_ sender: Any) {
        isOnGoingClicked = true
        changeOrdersBy(status: ORDER_STATUS.ONGOING)
    }
    @IBAction func cancelBtn(_ sender: Any) {
        isOnGoingClicked = false
        changeOrdersBy(status: ORDER_STATUS.CANCEL)
    }
    @IBAction func finishBtn(_ sender: Any) {
        isOnGoingClicked = false
         changeOrdersBy(status: ORDER_STATUS.FINISHED)
    }
    func changeOrdersBy(status : ORDER_STATUS){
        DataService.ds.REF_CUSTOMERS.child(userId).child("orders").queryOrdered(byChild: "status").queryEqual(toValue: status.hashValue).observe(.value, with: {
            
            snapshot in
            print(snapshot)
            self.orders = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshots {
                    if let snapData = snap.value as? Dictionary<String, Any>{
                        let order = Order(id: snap.key, data: snapData)
                        self.orders.append(order)
                    }
                }
                self.tableView.reloadData()
            }})
    }


}
