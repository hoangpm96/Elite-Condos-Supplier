//
//  ServiceListCell.swift
//  Elite Condos
//
//  Created by Khoa on 11/18/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit

class ServiceListCell: UITableViewCell {

  
    @IBOutlet weak var nameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configureCell(service : Service){
        nameLbl.text  = service.name
    }

}
