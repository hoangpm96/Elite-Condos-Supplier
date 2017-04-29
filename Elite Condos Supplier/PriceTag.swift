//
//  PriceTag.swift
//  Elite Condos Supplier
//
//  Created by Khoa on 4/14/17.
//  Copyright © 2017 Khoa. All rights reserved.
//
import Foundation


class PriceTag {
    
     var id: String?
     var name: String?
     var price: Double?

    init(id: String , data: Dictionary<String,Any> ) {
        
        self.id = id
        if let name = data["name"] as? String{
            self.name = name
        }
        
        if let price = data ["price"] as? Double?{
            self.price = price
        }
        
    }
    init(id: String, name: String, price: Double) {
        self.id = id
        self.name = name
        self.price = price
    }
    
    
}

