//
//  Service.swift
//  Elite Condos
//
//  Created by Khoa on 11/17/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import Foundation

class Service {
    
    private var _serviceId : String!
    private var _name : String!
    private var _supplierId : String!
    
    
    var serviceId : String{
        return _serviceId
    }
    var name : String{
        return _name
    }
    private var supplierId : String{
        return _supplierId
    }
    
    init(id : String, data : Dictionary<String,Any>) {
        _serviceId = id
        if let name = data["name"] as? String{
            self._name = name
        }
        if let supplierId = data["supplierId"] as? String{
            self._supplierId = supplierId
        }
       
    }
    
    
}
