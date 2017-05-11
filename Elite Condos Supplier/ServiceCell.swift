//
//  ServiceCell.swift
//  Elite Condos
//
//  Created by Khoa on 3/15/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit

class ServiceCell: UITableViewCell {
    
    @IBOutlet weak var subscribeLbl: UILabel!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var serviceImage: UIImageView!
    
    var service: ServiceData?{
        didSet{
            configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(){
        if let name = service?.name{
            serviceName.text = name
            
        }
        if let img = service?.imgUrl{
            serviceImage.image = UIImage(named: img)
        }
        
    }
    func changeSubscribeLabel(value: Bool){
        
        if value == true{
            subscribeLbl.backgroundColor = UIColor.green
            subscribeLbl.text = "Subscribed"
        } else {
            subscribeLbl.backgroundColor = UIColor.red
            subscribeLbl.text = "UnSubscribed"
            
        }
    }
    
}

extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.characters.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
