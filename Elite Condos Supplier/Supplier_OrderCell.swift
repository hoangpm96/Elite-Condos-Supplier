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
        
        FirRef.CUSTOMERS.child(order.customerId).observeSingleEvent(of: .value, with: {
                        snapshot in
                            if let snapData = snapshot.value as? Dictionary<String,Any>{
                                if let name = snapData["name"] as? String{
                                    self.customerNameLbl.text = name
                                }
                            }
                    })
    }
        

    

}
