//
//  Supplier_OrderCell.swift
//  Elite Condos
//
//  Created by Khoa on 11/25/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
class Supplier_OrderCell: UITableViewCell {

    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var employeeAvatarImg: CircleImage!
    @IBOutlet weak var customerAvatarImg: CircleImage!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var customerAddressLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell( order : Order ){
        customerAddressLbl.text = order.serviceName
        orderIdLbl.text = "#\(order.id)"
        
        DataService.ds.REF_CUSTOMERS.child(order.customerId).observeSingleEvent(of: .value, with: {
                        snapshot in
                            if let snapData = snapshot.value as? Dictionary<String,Any>{
                                if let name = snapData["name"] as? String{
                                    self.customerNameLbl.text = name
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
                                        self.employeeAvatarImg.image = imageData
                                    }
                                }
                            }
                            
                    })

                }
            }
        })
    }
    

    

}
