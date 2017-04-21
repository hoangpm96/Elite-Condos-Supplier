//
//  PriceTag.swift
//  Elite Condos Supplier
//
//  Created by Khoa on 12/10/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import Foundation


class PriceTag {
    
    private var _id : String!
    private var _name : String!
    private var _price : String!
    
    
    var id : String{
        return _id
    }
    var name : String{
        return _name
    }
    var price : String{
        return _price
    }
    
    init( id : String , data : Dictionary<String,String> ) {
       
        self._id = id
        if let name = data["nameTag"]{
            self._name = name
        }
        
        if let price = data ["price"]{
            self._price = price
        }
        
    }
    
    
}
