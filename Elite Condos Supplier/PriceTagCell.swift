//
//  PriceTagCell.swift
//  Elite Condos Supplier
//
//  Created by Khoa on 4/16/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation
import UIKit

class PriceTagCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLbl : UILabel!
    @IBOutlet weak var priceLbl : UILabel!
    
    var priceTag: PriceTag?{
        didSet{
            updateView()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func updateView(){
        nameLbl.text = priceTag?.name
        priceLbl.text = String(format: "%.f", (priceTag?.price)!)
    }
    
    
}
