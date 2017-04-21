//
//  CartCell.swift
//  Elite Condos
//
//  Created by Khoa on 11/19/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {

    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell( order : Order){
        nameLbl.text = order.serviceName
        priceLbl.text = order.price
    }
    @IBAction func deleteBtn(_ sender: Any) {
    }

}
