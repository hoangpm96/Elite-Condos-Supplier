//
//  SupplierHomeVC.swift
//  Elite Condos
//
//  Created by Khoa on 11/16/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchOrders(status: 0)
    }
    // MARK: Functions
    
    func fetchOrders(status: Int){
        orders = []
        self.tableView.reloadData()
        ProgressHUD.show("Đang tải dữ liệu...")
        
        switch status {
        case 0:
            Api.Order.observeOnGoingOrders(completed: { (order) in
                self.orders.append(order)
                self.tableView.reloadData()
                ProgressHUD.dismiss()
            }, onNotFound: {
                ProgressHUD.dismiss()
            })
        case 1:
            Api.Order.observeCancelOrders(completed: { (order) in
                self.orders.append(order)
                self.tableView.reloadData()
                ProgressHUD.dismiss()
            }, onNotFound: {
                ProgressHUD.dismiss()
            })
        case 2:
            Api.Order.observeFinishOrders(completed: { (order) in
                self.orders.append(order)
                self.tableView.reloadData()
                ProgressHUD.dismiss()
            }, onNotFound: {
                ProgressHUD.dismiss()
            })
        default:
            return
        }
        
        
    }
    @IBAction func ongoingBtn(_ sender: Any) {
        fetchOrders(status: 0)
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        fetchOrders(status: 1)
    }
    
    @IBAction func finishBtn(_ sender: Any) {
        fetchOrders(status: 2)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as!
        OrderCell
        cell.order = orders[indexPath.row]
        return cell
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
            
            //            FirRef.SUPPLIERS.updateOrders(orderId: orderId, supplierId: userId, customerId: customerId, status : ORDER_STATUS.CANCEL)
            
            
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

