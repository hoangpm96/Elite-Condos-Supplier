
//
//  Supplier_OrderCell.swift
//  Elite Condos
//
//  Created by Khoa on 11/25/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
class OrderCell: UITableViewCell {

    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var customerAvatarImg: CircleImage!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var customerAddressLbl: UILabel!
    
    var order: Order?{
        didSet{
            updateView()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateView(){
        
        customerAddressLbl.text = order?.serviceName
        orderIdLbl.text = "# \((order?.id)!)"
        
        Api.Order.getCustomerName(id: (order?.customerId)!) { (name) in
            self.customerNameLbl.text  = name
        }
        Api.Order.getUserPhoto(id: (order?.customerId)!, onError: { (error) in
            print(error)
        }) { (img) in
            self.customerAvatarImg.image = img
        }
    }
        

    

}
