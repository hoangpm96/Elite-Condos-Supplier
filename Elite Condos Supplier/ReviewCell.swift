//
//  ReviewCell.swift
//  Elite Condos Supplier
//
//  Created by Khoa on 4/16/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var reviewContentTextView: UITextView!

    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var reviewStar: CosmosView!
    @IBOutlet weak var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
