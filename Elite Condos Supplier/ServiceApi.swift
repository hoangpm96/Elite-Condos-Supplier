
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
    
    func subscribe(service: ServiceData, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void ){
        
        guard let supplierID = Api.User.CURRENT_USER?.uid else {
            onError("Can't find supplier")
            return
        }
        
        FirRef.SERVICES.child(service.id).updateChildValues([
            "name": service.name
            ])
        FirRef.SERVICES.child(service.id).child("suppliers").updateChildValues([
            supplierID: true])
        
        FirRef.SUPPLIER_SERVICES.child(supplierID).child(service.id).setValue(true)
        
        onSuccess()
    }
    func checkExist(service: ServiceData, onFound:  @escaping  () -> Void, notFound:  @escaping  () -> Void, onError: @escaping (String) -> Void ){
        
        guard let supplierID = Api.User.CURRENT_USER?.uid else {
            onError("Can't find supplier")
            return
        }
        FirRef.SUPPLIER_SERVICES.child(supplierID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(service.id){
                onFound()
                print("on found")
            }
            else {
                notFound()
                print("not found")
            }
        })
    }
    func deleteService(service: ServiceData, onDeleted:  @escaping  () -> Void){
        guard let supplierID = Api.User.CURRENT_USER?.uid else {
//            onError("Can't find supplier")
            return
        }
        FirRef.SUPPLIER_SERVICES.child(supplierID).child(service.id).removeValue()
        FirRef.SERVICES.child(service.id).child("suppliers").child(supplierID).removeValue()
        onDeleted()

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
