//
//  SupplierHomeVC.swift
//  Elite Condos
//
//  Created by Khoa on 11/16/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
class HomeVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noOrderLbl: UILabel!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    
    var orders = [Order]()
    var isOnGoingClicked = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.ds.REF_SUPPLIERS.child(userId).child("orders").queryOrdered(byChild: "status").queryEqual(toValue: ORDER_STATUS.ONGOING.hashValue).observe(.childAdded, with: {
            
            snapshot in
            self.orders = []
            if let snap = snapshot.value as? [String:Any]{
                let order = Order(id: snapshot.key, data: snap)
                self.orders.append(order)
                self.tableView.reloadData()
            }
        })
        
    }
    
    
    
    
    
    // MARK: Functions
    
    
    @IBAction func ongoingBtn(_ sender: Any) {
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
        DataService.ds.REF_SUPPLIERS.child(userId).child("orders").queryOrdered(byChild: "status").queryEqual(toValue: status.hashValue).observe(.childChanged, with: {
            
            
            snapshot in
            self.orders = []
            if let snap = snapshot.value as? [String:Any]{
                let order = Order(id: snapshot.key, data: snap)
                self.orders.append(order)
                self.tableView.reloadData()
            }
            
            
        })
    }
}


extension HomeVC: UITableViewDataSource{
    // MARK: Tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Supplier_OrderCell", for: indexPath) as?
            Supplier_OrderCell{
            cell.configureCell(order: orders[indexPath.row])
            return cell
        }else {
            return UITableViewCell()
        }
        
    }
    
    
}

extension HomeVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let orderId = orders[indexPath.row].id
        let customerId = orders[indexPath.row].customerId
        
        print(" Hello:  \(orderId) - \(customerId) ")
        let alert = UIAlertController(title: "Elite Condos", message: "", preferredStyle: .actionSheet)
        
        let chooseEmployee = UIAlertAction(title: "Chọn nhân viên", style: .default, handler: {
            action in
            
            
            
            
            self.performSegue(withIdentifier: "PickEmployeeVC", sender: ["order" : orderId,"customer" : customerId])
            
            
        })
        
        let cancelOrder = UIAlertAction(title: "Hủy đơn hàng", style: .default, handler: {
            action in
            
            // update order status - cancel
            
            DataService.ds.updateOrders(orderId: orderId, supplierId: userId, customerId: customerId, status : ORDER_STATUS.CANCEL)
            
            
        })
        
        let cancel = UIAlertAction(title: "Hủy", style: .cancel, handler: nil)
        
        if ( isOnGoingClicked  ){
            alert.addAction(chooseEmployee)
            alert.addAction(cancelOrder)
            
        }
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

