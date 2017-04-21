//
//  Customer_OrderCell.swift
//  Elite Condos
//
//  Created by Khoa on 11/26/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
class Customer_OrderCell: UITableViewCell {

  
   
   

    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var supplierName: UILabel!
    @IBOutlet weak var technicianImg: CircleImage!

    @IBOutlet weak var serviceNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell( order : Order ){
         serviceNameLbl.text = order.serviceName
        orderId.text = "#\(order.id)"
        serviceNameLbl.text = order.serviceName
        
        
        DataService.ds.REF_SUPPLIERS.child(order.supplierId).observeSingleEvent(of: .value, with: {
            snapshot in
            
            if let snapData = snapshot.value as? Dictionary<String,Any>{
                if let name = snapData["name"] as? String{
                    self.supplierName.text = name
                }
            }
        })
        
        
        DataService.ds.REF_EMPLOYEES.child(order.employeeId).observeSingleEvent(of: .value, with: {
            snapshot in
            if let snapData = snapshot.value as? Dictionary<String,Any>{
                if let employeeImgUrl = snapData["avatarUrl"] as? String{
                    let ref = FIRStorage.storage().reference(forURL: employeeImgUrl)
                    
                    ref.data(withMaxSize: 2 * 1024 * 1024, completion:
                        { data, error in
                            if error != nil{
                                print("can't download image from Firebase")
                            }else{
                                
                                if let data = data {
                                    print(" from Firebase")
                                    if let imageData = UIImage(data: data){
                                        self.technicianImg.image = imageData
                                    }
                                }
                            }
                            
                    })
                    
                }
            }
        })

    }

}
