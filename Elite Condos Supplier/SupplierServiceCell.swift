//
//  SupplierServiceCell.swift
//  Elite Condos
//
//  Created by Khoa on 11/17/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit

class SupplierServiceCell: UITableViewCell {
    @IBOutlet weak var serviceNameLbl: UILabel!

  
    func configureCell( service : Service ){
        serviceNameLbl.text = service.name
    }

}
