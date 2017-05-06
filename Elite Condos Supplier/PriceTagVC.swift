//
//  PriceTagVC.swift
//  Elite Condos Supplier
//
//  Created by Khoa on 4/16/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class PriceTagVC: UIViewController {
    @IBOutlet weak var priceTF: FancyField!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var tagNameTF: FancyField!
    @IBOutlet weak var tableView: UITableView!
    var orderId = ""
    var serviceId = ""
    var total = 0.0
    var priceTags = [PriceTag]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        FirRef.ORDERS.child(orderId).child("pricetag").observe(.value, with:  { (snapshot) in
        
            self.priceTags = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshots{
                    if let snapData = snap.value as? Dictionary<String,Any>{
                        
                        let priceTag = PriceTag(id: snap.key, data: snapData)
                        self.priceTags.append(priceTag)
                    }
                }
                self.tableView.reloadData()
                self.calulateTotal()
            }
        })
        
    }
    func calulateTotal(){
        total = 0.0
        for pricetag in priceTags{
            total += pricetag.price
        }
        totalLbl.text = "\(total) VNĐ"
        self.tableView.reloadData()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func confirm_TouchUpInside(_ sender: Any) {
        
        
        
      Api.Order.finishOrder(orderId: orderId, total: total) { 
            self.navigationController?.popViewController(animated: true)
        }
        
        
        
    }
    
    
    @IBAction func addPriceTagBtn(_ sender: Any) {
        guard let name = tagNameTF.text, name != ""  else {
            showAlert(title: APP_NAME, message: "Bạn chưa nhập chi tiết giá")
            return
        }
        
        guard let price = priceTF.text, price != ""  else {
            showAlert(title: APP_NAME, message: "Bạn chưa nhập mức giá")
            return
        }
        
        print("name= \(name) -- price \(price)")
        guard let dPrice = Double(price) else {
            return
        }
        
        let priceData: [String:Any] = ["name" : name, "price" : dPrice ]
        Api.Order.addPriceTag(orderId: orderId, priceTagData: priceData )
        
        let alert = UIAlertController(title: APP_NAME, message: "Thêm bảng giá thành công!", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            action in
            self.tableView.reloadData()
            self.calulateTotal()
            
        })
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    func showAlert(title: String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

extension PriceTagVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if  editingStyle == .delete{
            
            let priceTagId = priceTags[indexPath.row].id
            
            Api.Order.deletePriceTag(orderId: orderId, priceTagId: priceTagId)
            tableView.reloadData()
            calulateTotal()
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Xóa"
    }
    
}
extension PriceTagVC: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priceTags.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PriceTagCell", for: indexPath) as? PriceTagCell{
            cell.priceTag = priceTags[indexPath.row]
            return cell
        }else {
            return UITableViewCell()
        }
        
        
    }
    
}
