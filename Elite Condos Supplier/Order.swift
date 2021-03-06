//
//  Order.swift
//  Elite Condos
//
//  Created by Khoa on 11/26/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import Foundation

class Order  {
    
    private var _id : String!
    private var _customerId : String!
    private var _serviceName : String!
    private var _supplierId : String!
    private var _employeeId : String!
    private var _status : Int!
    private var _time: String!
    private var _description: String!
    var imgUrls: [String]?
    
    
   
    var description: String{
        return _description
    }
    
    var time: String{
        return _time
    }
    
    var id : String{
        return _id
    }
    var customerId :String{
        return _customerId
    }
    var serviceName : String{
        return _serviceName
    }
    var employeeId : String{
        return _employeeId
    }
    var supplierId : String{
        return _supplierId
    }
    
    var status : Int{
        return _status
    }
    
    init(id : String, data : Dictionary<String,Any>) {
        self._id = id
        self.imgUrls = [String]()
        if let customerId = data["customerId"] as? String{
            self._customerId = customerId
        }
        if let name = data["name"] as? String{
            self._serviceName = name
        }
        if let supplierId = data["supplierId"] as? String{
            self._supplierId = supplierId
        }
        if let status = data["status"] as? Int{
            self._status = status
        }
        if let employeeId = data["employeeId"] as? String{
            self._employeeId = employeeId
        }
        if let serviceName = data["serviceName"] as? String{
            self._serviceName = serviceName
        }
        if let time = data["created_at"] as? String{
            self._time = time
        }
        if let description = data["description"] as? String{
            self._description = description
        }
        
        if let imageUrls = data["imgUrls"] as? String{
            
            self.imgUrls = imageUrls.components(separatedBy: ",")
        }
        
    }
    
}
