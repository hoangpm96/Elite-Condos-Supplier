//
//  OrderApi.swift
//  Elite Condos Supplier
//
//  Created by Hien on 4/14/17.
//  Copyright © 2017 Hien. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import ProgressHUD
class OrderApi{
    var images: [UIImage] = [UIImage]()
    
    var mainService = ""
    var subService = ""
    
    var serviceId = ""
    
    // finish orders
    
    func finishOrder(orderId: String, total: Double, onSuccess: @escaping () -> Void){
        FirRef.ORDERS.child(orderId).updateChildValues(["total": total, "status": ORDER_STATUS.FINISHED.hashValue])
        onSuccess()
    }
    
    // add price tag
    func addPriceTag(orderId: String, priceTagData : Dictionary<String,Any>){
        let randomId = randomString(length: 12)
        
        FirRef.ORDERS.child(orderId).child("pricetag").child(randomId).updateChildValues(priceTagData)
    }
    
    
    // delete price tag
    func deletePriceTag(orderId: String, priceTagId: String){
        
        FirRef.ORDERS.child(orderId).child("pricetag").child(priceTagId)
            .removeValue()
    }
    
    
    // accept order
    func cancelOrder(at id: String, onSuccess: @escaping () -> Void ){
        FirRef.ORDERS.child(id).updateChildValues(["status": ORDER_STATUS.CANCEL.hashValue])
        onSuccess()
    }
    
    // accept order
    func acceptOrder(at id: String, onSuccess: @escaping () -> Void ){
        let currentId = Api.User.currentUid()
        FirRef.ORDERS.child(id).updateChildValues(["status": ORDER_STATUS.ONGOING.hashValue, "supplierId": currentId])
        onSuccess()
    }
    
    // deny order
    func denyOrder(at id: String, onSuccess: @escaping () -> Void ){
//        let currentId = Api.User.currentUid()
//        FirRef.ORDERS.child(id).removeValue()
//        FirRef.SUPPLIER_ORDERS.child(currentId).child(id).removeValue()
        FirRef.ORDERS.child(id).updateChildValues(["status": ORDER_STATUS.REJECTED.hashValue])
        onSuccess()
    }
    
    // get user's image
    func getUserPhoto(id: String, onError: @escaping (String) -> Void, onSuccess: @escaping (UIImage) -> Void ){
        FirRef.CUSTOMERS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let snapData = snapshot.value as? Dictionary<String,Any>{
                if let imgUrl = snapData["avatarUrl"] as? String{
                    
                    Api.User
                        .downloadImage(imgUrl: imgUrl, onError: onError, onSuccess: onSuccess)
                }
            }
        })
        
        
        
    }
    
    func getCustomerName(id: String, onSuccess: @escaping (String) -> Void){
        FirRef.CUSTOMERS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let snapData = snapshot.value as? Dictionary<String,Any>{
                if let name = snapData["name"] as? String{
                    onSuccess(name)
                }
            }
        })
    }
    
    
    
    // upload order photos -> img links
    func initOrder(orderData: [String:Any], onSuccess: @escaping (String) -> Void){
        uploadPhotos { (imgUrls) in
            var newData = orderData
            var imgStrings = ""
            for (index,value) in imgUrls.enumerated(){
                if (index == imgUrls.count - 1){
                    imgStrings += value
                }else {
                    imgStrings += "\(value),"
                }
            }
            newData["imgUrls"] = imgStrings
            let newChildId = randomString(length: 8)
            
            
            
            FirRef.ORDERS.child(newChildId).updateChildValues(newData)
            onSuccess(newChildId)
        }
    }
    
    // upload multiple photos
    func uploadPhotos(onSuccess: @escaping ([String]) -> Void){
        var imgUrls: [String] = []
        guard images.count > 0 else {
            return
        }
        
        let task = DispatchWorkItem {
            for img in self.images{
                
                self.uploadPhoto(photo: img, onSuccess: { (imgUrl) in
                    imgUrls.append(imgUrl)
                }, onError: { (error) in
                    print(error)
                })
                
            }}
        
        
        let start = DispatchTime.now()
        task.perform()
        
        
        let end  = DispatchTime.now()
        
        
        
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        
        let timeInterval = Double(nanoTime) / 1_000_000_000
        
        print("time= \(timeInterval))")
        
        
        
        
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 5 ) {
            print("upload ok")
            onSuccess(imgUrls)
        }
        
    }
    
    // upload 1 photo
    func uploadPhoto(photo: UIImage, onSuccess: @escaping (String) -> Void, onError: @escaping (String) -> Void){
        if let imgData = UIImageJPEGRepresentation(photo, 0.2){
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            
            
            FirRef.ORDER_IMAGES.child(imgUid).put(imgData, metadata: metadata, completion: { (metaData, error) in
                if error != nil{
                    onError("error \(error.debugDescription)")
                }else{
                    let downloadURL = metaData!.downloadURL()!.absoluteString
                    print("download URl \(downloadURL)")
                    onSuccess(downloadURL)
                }
            })
        }
    }
    
    // update order with new supplierid
    func updateOrder(orderId: String, supplierId : String, customerId : String, orderData : Dictionary<String,Any>, onSuccess: @escaping () -> Void){
        
        
        
        FirRef.ORDERS.child(orderId).updateChildValues(orderData)
        
        //
        
        FirRef.SUPPLIER_ORDERS.child(supplierId).child(orderId).setValue(true)
        FirRef.CUSTOMER_ORDERS.child(customerId).child(orderId).setValue(true)
        
        onSuccess()
    }
    
    
    // observe orders
    func observeCancelOrders(completed: @escaping (Order) -> Void){
        
        let uid = Api.User.currentUid()
        FirRef.SUPPLIER_ORDERS.child(uid).observe(.value, with: { (snapshot)
            in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for child in snapshots {
                    
                    FirRef.ORDERS.queryOrderedByKey().queryEqual(toValue: child.key).observe(.value, with: { (orderSnapshot) in
                        if let dict = orderSnapshot.value as? [String:Any]{
                            print(dict)
                            if let status = dict["status"] as? Int{
                                if status == 1 {
                                    print("status \(status)")
                                    let order = Order(id: orderSnapshot.key, data: dict)
                                    completed(order)
                                }
                            }
                        }
                    })}}})}
    
    // observe Orders
    
    func observeOrders(orderId: String,completed: @escaping (Order) -> Void){
        
        FirRef.ORDERS.child(orderId).observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String:Any]{
                
                let order = Order(id: orderId, data: dict)
                completed(order)
                
            }
            
            
            
        })
        
        
    }
    
    
   
    
    
    // observe price tags - each orders have at least 1 price tag
    // price tags are displayed on PaymentConfirmation screen.
    
    func observePriceTag(orderId: String, completed: @escaping (PriceTag) -> Void){
        FirRef.ORDERS.child(orderId).child("pricetags").observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String:Any]{
                let priceTag = PriceTag(id: snapshot.key, data: dict)
                completed(priceTag)
            }
        })
    }
    
    // confirm payment when order is finised, use in PaymentConfirmationVC
    func confirmPayment(orderId: String, totalPrice: Double, completion: @escaping () -> Void){
        let today = Date().description
        FirRef.ORDERS.child(orderId).updateChildValues(["totalPrice": totalPrice, "ended_at" : today, "status": ORDER_STATUS.FINISHED.hashValue ])
        completion()
    }
    
}






