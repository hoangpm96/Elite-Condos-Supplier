//
//  OrderDetailCell.swift
//  Elite Condos Supplier
//
//  Created by Khoa on 5/14/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit

class OrderDetailCell: UICollectionViewCell {
    
    
    @IBOutlet weak var orderImage: UIImageView!
    
    var imageLink: String?{
        didSet{
            updateImage()
        }
    }
    override func awakeFromNib() {
        
    }
    
    func updateImage(){
        
        let url = URL(string: imageLink!)
        
        self.orderImage.sd_setImage(with: url)
    }
    
    
    
}
