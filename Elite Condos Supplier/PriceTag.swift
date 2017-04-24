//
//  PriceTag.swift
//  Elite Condos Supplier
//
//  Created by Khoa on 4/14/17.
//  Copyright © 2017 Khoa. All rights reserved.
//
import Foundation


class PriceTag {
    
    private var _id: String!
    private var _name: String!
    private var _price: Double!
    
    
    var id: String{
        return _id
    }
    var name: String{
        return _name
    }
    var price: Double{
        return _price
    }
    
    init(id: String , data: Dictionary<String,Any> ) {
        
        self._id = id
        if let name = data["name"] as? String{
            self._name = name
        }
        
        if let price = data ["price"] as? Double?{
            self._price = price
        }
        
    }
    init(id: String, name: String, price: Double) {
        self._id = id
        self._name = name
        self._price = price
    }
    
    
}

