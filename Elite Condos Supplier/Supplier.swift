//
//  Supplier.swift
//  Elite Condos
//
//  Created by Khoa on 11/15/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import Foundation
import Firebase
class Supplier {
    
    private var _id : String!
    private var _name : String!
    private var _address : String!
    private var _description : String!
    private var _logo : String!
    private var _serviceRef : FIRDatabaseReference!
    
    var name : String{
        if _name == nil{
            return "NO NAME"
        }
        return _name
    }
    var address : String{
        return _address
    }
    var description : String{
        return _description
    }
    var logo : String{
        if _logo == nil{
            return ""
        }
        return _logo
    }
    
    var id : String{
        return _id
    }
    var serviceRef : FIRDatabaseReference{
        return _serviceRef
    }
    init(id : String, data : Dictionary<String, Any>) {
        self._id = id
        if let name = data["name"] as? String{
            self._name = name
        }
        if let address = data["address"] as? String{
            self._address = address
        }
        if let description = data["description"] as? String{
            self._description = description
        }

        if let logo = data["logoUrl"] as? String{
           self._logo = logo
        }
        
       
        
    }
    
    
}
