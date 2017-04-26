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
        ProgressHUD.show("Đang tải dữ liệu...")
        FirRef.ORDERS.queryOrdered(byChild: "supplierId").queryEqual(toValue: "LYFqRhNNYnNEJS8Ju9zVbc9J1Jk2").observe(.value, with: { (snapshots) in
            print(snapshots)
            
            if let snapshots = snapshots.children.allObjects as? [FIRDataSnapshot]{
                self.orders.removeAll()
                for orderSnapshot in snapshots{
                    if let dict = orderSnapshot.value as? [String:Any]{
                        print(dict)
                        if let status = dict["status"] as? Int{
                            if status == 0 {
                                print("alo \(status)")
                                let order = Order(id: orderSnapshot.key, data: dict)
                                self.orders.append(order)
                            }
                        }
                    }
                    
                }
                ProgressHUD.dismiss()
                self.tableView.reloadData()
            }
            
            
            
        })
        
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    // MARK: Functions
    
    func fetchOrders(orderStatus: Int){
        
        ProgressHUD.show("Đang tải dữ liệu...")
        FirRef.ORDERS.queryOrdered(byChild: "supplierId").queryEqual(toValue: "LYFqRhNNYnNEJS8Ju9zVbc9J1Jk2").observe(.value, with: { (snapshots) in
            print(snapshots)
            
            if let snapshots = snapshots.children.allObjects as? [FIRDataSnapshot]{
                self.orders.removeAll()
                for orderSnapshot in snapshots{
                    if let dict = orderSnapshot.value as? [String:Any]{
                        print(dict)
                        if let status = dict["status"] as? Int{
                            if status ==  orderStatus{
                                print("alo \(status)")
                                let order = Order(id: orderSnapshot.key, data: dict)
                                self.orders.append(order)
                            }
                        }
                    }
                    
                }
                ProgressHUD.dismiss()
                self.tableView.reloadData()
                
            }
            
            
            
        })
    }
    @IBAction func ongoingBtn(_ sender: Any) {
        fetchOrders(orderStatus: 0)
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        fetchOrders(orderStatus: 1)
    }
    
    @IBAction func finishBtn(_ sender: Any) {
        fetchOrders(orderStatus: 2)
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
        cell.delegate = self
        cell.order = orders[indexPath.row]
        return cell
    }
    
    
}

extension HomeVC: OrderCellDelegate{
    
    func moveToDetail(orderId: String) {
        performSegue(withIdentifier: "HomeToOrderDetail", sender: orderId)
    }
    func denyOrder(orderId: String) {
        Api.Order.denyOrder(at: orderId) { 
            self.fetchOrders(orderStatus: ORDER_STATUS.CANCEL.hashValue)
        }
        print(ORDER_STATUS.CANCEL.hashValue)
    }
    
}

