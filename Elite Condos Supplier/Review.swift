//
//  Review.swift
//  Elite Condos Supplier
//
//  Created by Khoa on 4/16/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation

class Review{
    
    var username: String?
    var imgUrl: String?
    var moneyAmount: Double?
    var reviewContent: String?
    var ratingStars: Double?
    var time: String?
    var id: String
    init(id: String, data: [String:Any] ) {
        
        self.id = id
        if let username = data["username"] as? String{
            self.username = username
        }
        if let imgUrl = data["imgUrl"] as? String{
            self.imgUrl = imgUrl
        }
        if let money = data["moneyAmount"] as? Double{
            self.moneyAmount = money
        }
        if let content = data["content"] as? String{
            self.reviewContent = content
        }
        if let stars = data["ratingStars"] as? Double{
            self.ratingStars = stars
        }
        if let time = data["time"] as? String{
            self.time = time
        }
    }
    
    
}
