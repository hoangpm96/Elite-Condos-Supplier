//
//  CircleImage.swift
//  Elite Condos
//
//  Created by Khoa on 11/12/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit

class CircleImage: UIImageView {

    override func awakeFromNib() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }

}
