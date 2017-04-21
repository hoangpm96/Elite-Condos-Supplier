
//
//  ServiceApi.swift
//  Elite Condos Supplier
//
//  Created by Khoa on 3/9/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation
import Firebase
class ServiceApi {
    
    func observeService(onSuccess: @escaping (Service) -> Void, onError: @escaping (String) -> Void){
        guard let supplierID = Api.User.CURRENT_USER?.uid else {
            onError("Can't find supplier")
            return
        }
        FirRef.SUPPLIER_SERVICES.child(supplierID).observe(.childAdded, with: { (snapshot) in
            print("supplier service: \(snapshot.key)")
            
            self.getServiceData(serviceId: snapshot.key, onSuccess: { (service) in
                onSuccess(service)
                
            })
        })
        
        
    }
    
    func addService(name: String, onSuccess: @escaping (String) -> Void, onError: @escaping (String) -> Void ){
        
        guard let supplierID = Api.User.CURRENT_USER?.uid else {
            onError("Can't find supplier")
            return
        }
        print("current Name: \(name)")
        
        let ramdomId = randomString(length: 8)
        FirRef.SERVICES.child(ramdomId).updateChildValues([
            "name": name,
            "supplier": supplierID
            ])
        FirRef.SUPPLIER_SERVICES.child(supplierID).child(ramdomId).setValue(true)
    }
    
    func checkExistService(supplierID: String,key: String, name: String) {
        
        print("key: \(key)")
        
        FirRef.SERVICES.child(key).observe(.value, with: { (serviceSnap) in
            if let serviceData = serviceSnap.value as? [String:Any]{
                if let serviceName = serviceData["name"] as? String{
                    print("name: \(name) || serviceName: \(serviceName)")
                    if serviceName == name{
                        
                    }
                }
            }
        })
    }
    func getServiceData(serviceId: String, onSuccess: @escaping (Service) -> Void){
        FirRef.SERVICES.child(serviceId).observe(.value, with: { (serviceSnap) in
            print("serviceId: \(serviceId)")
            if let serviceData = serviceSnap.value as? [String:Any]{
                let service = Service(id: serviceId, data: serviceData)
                onSuccess(service)
            }
        })
    }
    
    
    
    
}
