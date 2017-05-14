
//
//  Supplier_OrderCell.swift
//  Elite Condos
//
//  Created by Khoa on 11/25/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase

protocol OrderCellDelegate{
    func moveToDetail(orderId: String)
}
class OrderCell: UITableViewCell {
    
//    @IBOutlet weak var detailButton: FancyBtn!
    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var customerAvatarImg: CircleImage!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var customerAddressLbl: UILabel!
    
    
    var delegate: OrderCellDelegate?
    
    var order: Order?{
        didSet{
            print("truoc")
            updateView()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        print("sau")
        // Initialization code
        
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func updateView(){
        
        customerAddressLbl.text = order?.serviceName
        orderIdLbl.text = "# \((order?.id)!)"
        
        
        timeLbl.text = order?.time
        
        
        Api.Order.getCustomerName(id: (order?.customerId)!) { (name) in
            self.customerNameLbl.text  = name
        }
        Api.Order.getUserPhoto(id: (order?.customerId)!, onError: { (error) in
            print(error)
        }) { (img) in
            self.customerAvatarImg.image = img
        }
    }

    
//    @IBAction func detail_TouchInside(_ sender: Any) {
//        delegate?.moveToDetail(orderId: (order?.id)!)
//    }
    
    
}
