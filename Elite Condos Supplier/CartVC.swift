//
//  CartVC.swift
//  Elite Condos
//
//  Created by Khoa on 11/12/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
class CartVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView : UITableView!

    var total = 0
    var orders = [Order]()
    override func viewDidLoad() {
        super.viewDidLoad()

      
        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        tableView.delegate = self
        tableView.dataSource = self
            
        DataService.ds.REF_CUSTOMERS.child(userId).child("orders").queryOrdered(byChild: "status").queryEqual(toValue: 0).observe(.value, with: {
            
            snapshot in
            self.orders = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshots {
                
                    if let snapData = snap.value as? Dictionary<String, Any>{
                print("CartVC: ")
                let order = Order(id: snap.key, data: snapData)
                self.orders.append(order)
                }
            }
                
             self.tableView.reloadData()
             self.calTotal()
            }})
       
        
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as? CartCell{
            cell.configureCell(order: orders[indexPath.row])
            return cell
        }
        else{
            return UITableViewCell()
        }
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if  editingStyle == .delete{
            
            let orderId = orders[indexPath.row].id
            
            
            // get suppierId
            DataService.ds.REF_ORDERS.child(orderId).observeSingleEvent(of: .value, with: {
                snapshot in
                if let snap = snapshot.value as? Dictionary<String,Any>{
                    if let supplierId = snap["supplierId"] as? String{
                    
                    
                    DataService.ds.deleteOrderByCustomer(orderId: orderId, supplierId: supplierId, customerId: userId)
                    }
                }}
            )
            
            orders.remove(at: indexPath.row)
            tableView.reloadData()
           
           
            calTotal()
            
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Xóa"
    }
    
    
    @IBAction func payBtn(_ sender: Any) {
        
        if orders.count == 0{
           let alert = UIAlertController(title: APP_NAME, message: "Bạn chưa có hóa đơn nào", preferredStyle: .actionSheet)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            
            present(alert, animated: true, completion: nil)
            
        }else {
        
        
        let alert = UIAlertController(title: "Thanh toán", message: "Chọn hình thức thanh toán", preferredStyle: .actionSheet)
        
        let CODAction = UIAlertAction(title: "Thanh toán tại nhà", style: .default, handler: {
            action in
            
            
//            DataOrder.ds.updateOrderAfterPaidByCustomer(OrderId: "HfyT0qwiZdpdsnxZH5ZDIFIn5uuF6b", supplierId: "skejB9Oa0gOOWNq54ABaF2H4rhC2", customerId: "SSr6SnRez9floMS5xVA5Qutyada2")
            
            for order in self.orders{
                
                // get suppierId
                DataService.ds.REF_ORDERS.child(order.id).observeSingleEvent(of: .value, with: {
                    snapshot in
                    if let snap = snapshot.value as? Dictionary<String,Any>{
                        if let supplierId = snap["supplierId"] as? String{
                            
                            
                            DataService.ds.updateOrders(orderId: order.id, supplierId: supplierId, customerId: userId, status : ORDER_STATUS.ONGOING)
                        }
                    }}
                )

               
            }
            
            self.performSegue(withIdentifier: "CartVCToOrder", sender: nil)
        })
        let onlineAction = UIAlertAction(title: "Thanh toán trực tuyến", style: .default, handler: nil)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(CODAction)
        alert.addAction(onlineAction)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    }
    
    func calTotal(){
        total = 0
        for i in 0..<orders.count{
            if ( orders[i].price == ""){
                total += 0
            }else {
                total += Int(orders[i].price)!
            }
        }
        totalLbl.text = "\(total) VNĐ"
        
    }
}
















    
