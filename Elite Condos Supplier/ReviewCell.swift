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
    
    var review: Review?{
        didSet{
            updateView()
        }
    }
    override func awakeFromNib() {
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 15.0
    }
    func updateView(){
        timeLbl.text = review?.time
        reviewContentTextView.text = review?.reviewContent
       
        if let money = review?.moneyAmount {
                totalPrice.text  = "\(money) VNĐ"
        }
        usernameLbl.text = review?.username
        
        if let rating = review?.ratingStars{
            reviewStar.rating = rating
        
        }
        
        if let imgUrl = review?.imgUrl{
            let url = URL(string: imgUrl)
             profileImage.sd_setImage(with: url)
        }
        
    
        
        
        
    }


}
