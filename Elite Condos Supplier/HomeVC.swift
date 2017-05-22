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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let token = UserDefaults.standard.value(forKey: "token") as? String{
            Api.User.updateTokenToDatabase(token: token, onSuccess: {
                print("Update token in HomeVC with: \(token)")
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        fetchNewOrders()

    }
    
    // MARK: Functions
    
    func fetchOrders(orderStatus: Int){
         let currenId = Api.User.currentUid()
        ProgressHUD.show("Đang tải dữ liệu...")
        
        
        FirRef.ORDERS.queryOrdered(byChild: "supplierId").queryEqual(toValue: currenId).observe(.value, with: { (snapshots) in
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
    
    
    func fetchNewOrders(){
        
        ProgressHUD.show("Đang tải dữ liệu...")
       
        
        
        let ref = FirRef.ORDERS.queryOrdered(byChild: "status").queryEqual(toValue: ORDER_STATUS.NOTACCEPTED.hashValue)
        
        ref.observe(.value, with: { (snapshots) in
            
                        print(snapshots)
            if let snapshots = snapshots.children.allObjects as? [FIRDataSnapshot]{
                self.orders.removeAll()
                for orderSnapshot in snapshots{
                    if let dict = orderSnapshot.value as? [String:Any]{
                        print(dict)
                        let order = Order(id: orderSnapshot.key, data: dict)
                        self.orders.append(order)
                    }
                    
                }
                ProgressHUD.dismiss()
                self.tableView.reloadData()
                
            }
        })

    }
    
    
    @IBAction func newBtn_TouchInside(_ sender: Any) {
        fetchNewOrders()
    }
    @IBAction func ongoingBtn(_ sender: Any) {
        fetchOrders(orderStatus: ORDER_STATUS.ONGOING.hashValue)
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        fetchOrders(orderStatus: ORDER_STATUS.CANCEL.hashValue)
    }
    
    @IBAction func finishBtn(_ sender: Any) {
        fetchOrders(orderStatus: ORDER_STATUS.FINISHED.hashValue)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToPriceTag"{
            if let priceTagVC = segue.destination as? PriceTagVC{
                if let id = sender as? String{
                    priceTagVC.orderId = id
                }
            }
        }
        
        if segue.identifier == "HomeToOrderDetail"{
            if let orderDetail = segue.destination as? OrderDetailVC{
                if let id = sender as? String{
                    orderDetail.orderId = id
                }
            }
        }
    }
    
}
extension HomeVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let status = orders[indexPath.row].status
        
        // NOT ACCEPTED:
        if status == 0 {
            
            let alert = UIAlertController(title: APP_NAME, message: "Action", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "Từ chối đơn hàng", style: .default, handler: { action in
                // cancel api here - reload tableview
                Api.Order.denyOrder(at: self.orders[indexPath.row].id, onSuccess: {
                    print("OK")
                })
            })
            
            let accept = UIAlertAction(title: "Đồng ý đơn hàng", style: .default, handler: { action in
                
                Api.Order.acceptOrder(at: self.orders[indexPath.row].id, onSuccess: {
                    
                })
                
            })
            let dismiss = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(cancel)
            alert.addAction(accept)
            alert.addAction(dismiss)
            present(alert, animated: true, completion: nil)
            
        }else if status == 1 {
            let alert = UIAlertController(title: APP_NAME, message: "Action", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "Hủy đơn hàng", style: .default, handler: { action in
                // cancel api here - reload tableview
                Api.Order.cancelOrder(at: self.orders[indexPath.row].id, onSuccess: { 
                    
                })
            })
            
            let accept = UIAlertAction(title: "Hoàn thành công việc", style: .default, handler: { action in
                // ok api here - reload tableview - move to detail orders
                self.performSegue(withIdentifier: "HomeToPriceTag", sender: self.orders[indexPath.row].id)
            })
            let dismiss = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.addAction(accept)
            alert.addAction(dismiss)
            present(alert, animated: true, completion: nil)
        }
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

