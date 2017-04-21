//
//  DataService.swift
//  Elite Condos
//
//  Created by Khoa on 11/14/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()


class DataService {
    
    static let ds = DataService()
    
    // DB references
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_CUSTOMERS = DB_BASE.child("customers")
    private var _REF_SUPPLIERS = DB_BASE.child("suppliers")
    private var _REF_SERVICES = DB_BASE.child("services")
    private var _REF_EMPLOYEES = DB_BASE.child("employees")
    private var _REF_ORDERS = DB_BASE.child("orders")
    
    // Storage references
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    private var _REF_CUSTOMER_AVATAR = STORAGE_BASE.child("customer_avatar")
    private var _REF_SUPPLIER_LOGO = STORAGE_BASE.child("supplier_images")
    private var _REF_EMPLOYEE_AVATAR = STORAGE_BASE.child("employee_avatar")
    
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    var REF_CUSTOMERS : FIRDatabaseReference{
        return _REF_CUSTOMERS
    }
    var REF_SUPPLIERS : FIRDatabaseReference{
        return _REF_SUPPLIERS
    }
    var REF_SERVICES : FIRDatabaseReference{
        return _REF_SERVICES
    }
    var REF_EMPLOYEES : FIRDatabaseReference{
        return _REF_EMPLOYEES
    }
    var REF_ORDERS : FIRDatabaseReference{
        return _REF_ORDERS
    }
    
    // storage
    var REF_CUSTOMER_AVATAR : FIRStorageReference{
        return _REF_CUSTOMER_AVATAR
    }
    var REF_SUPPPLIER_LOGO : FIRStorageReference{
        return _REF_SUPPLIER_LOGO
    }
    var REF_EMPLOYEE_AVATAR : FIRStorageReference{
        return _REF_EMPLOYEE_AVATAR
    
    }
    
    
//    var REF_USER_CURRENT: FIRDatabaseReference {
//        
//    }
//    
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    func createFirbaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    func createFirebaseDBCutomer(uid : String, userData : Dictionary<String, String>  ){
        REF_CUSTOMERS.child(uid).updateChildValues(userData)
        
        let currentTime = getCurrentTime()
        REF_USERS.child(uid).updateChildValues(["customer" : true,
                                                "created_at" : currentTime])
    }
    
    func createFirebaseDBSupplier(id : String, supplierData : Dictionary<String,Any>) {
        REF_SUPPLIERS.child(id).updateChildValues(supplierData)
        
        let currentTime = getCurrentTime()
        REF_USERS.child(id).updateChildValues(["supplier" : true,
                                               "created_at" : currentTime])
    }
    
    func addService( supplierId : String, serviceData : Dictionary<String,Any>) -> String{
        
        
        let randomId = randomString(length: 12)
        REF_SERVICES.child(randomId).updateChildValues(serviceData)
        REF_SUPPLIERS.child(supplierId).child("services").child(randomId).updateChildValues(
        serviceData)
        
        return randomId
    
    }
    
    
    func addPriceTag(supplierId : String, serviceId: String, priceTagData : Dictionary<String,String>){
        let randomId = randomString(length: 12)
        REF_SERVICES.child(serviceId).child("pricetag").child(randomId).updateChildValues(priceTagData)
       REF_SUPPLIERS.child(supplierId).child("services").child(serviceId).child("pricetag").child(randomId).updateChildValues(priceTagData)
    
    }
    
    func addEmployee(supplierId : String, employeeData : Dictionary<String, Any>){
        
        let randomId = randomString(length: 12)
        REF_EMPLOYEES.child(randomId).updateChildValues(employeeData)
        REF_SUPPLIERS.child(supplierId).child("employees").updateChildValues([
            randomId : true])
    }
    
    func createOrder(supplierId : String, customerId : String, orderData : Dictionary<String,Any>){
        
   
        // save to 3 paths - remember delete at 3 paths
        // use the same key for orderId = serviceId
        let randomId = randomString(length: 12)
            REF_ORDERS.child(randomId).updateChildValues(orderData)
        REF_SUPPLIERS.child(supplierId).child("orders").child(randomId).updateChildValues(orderData)
        REF_CUSTOMERS.child(customerId).child("orders").child(randomId).updateChildValues(orderData)
        // because we use serviceID for orderId
    }
    func deleteOrderByCustomer( orderId : String, supplierId : String, customerId : String ){
        
        REF_ORDERS.child(orderId).removeValue()
        REF_SUPPLIERS.child(supplierId).child("orders").child(orderId).removeValue()
        REF_CUSTOMERS.child(customerId).child("orders").child(orderId).removeValue()
        
    }
    
    func updateOrders(orderId : String, supplierId : String, customerId : String, status : ORDER_STATUS ){
            REF_ORDERS.child(orderId).updateChildValues(["status": status.hashValue])
            REF_SUPPLIERS.child(supplierId).child("orders").child(orderId).updateChildValues(["status": status.hashValue])
            REF_CUSTOMERS.child(customerId).child("orders").child(orderId).updateChildValues(["status": status.hashValue])
    }
    
    func addEmployee(orderId : String, supplierId : String, customerId : String, employeeId : String ){
        REF_ORDERS.child(orderId).updateChildValues([
            "employeeId" : employeeId
            ])
        REF_SUPPLIERS.child(supplierId).child("orders").child(orderId).updateChildValues(["employeeId" : employeeId])
        REF_CUSTOMERS.child(customerId).child("orders").child(orderId).updateChildValues(["employeeId" : employeeId])
    }
    
    func addReview( supplierId : String , orderId :String, reviewData : Dictionary<String,Any>){
        
        let randomId = randomString(length: 8)
        REF_SUPPLIERS.child(supplierId).child("reviews").child(randomId).updateChildValues(reviewData)
        
        
    }
    
    func updateSupplierLogo( supplierId : String, logoUrl : String ){
        REF_SUPPLIERS.child(supplierId).updateChildValues([
            "logoUrl" : logoUrl
            ])
    }
    
    
    
    // MARK:- Get properties
    
//    func getCustomerNameBy(id : String) -> String{
//        var customerName = ""
//        REF_CUSTOMERS.child(id).observeSingleEvent(of: .value, with: {
//            snapshot in
//          
//                if let snapData = snapshot.value as? Dictionary<String,Any>{
//                    if let name = snapData["name"] as? String{
//                        customerName = name
//                        return name
//                    }
//                    else {
//                        return ""
//                    }
//                }
//            
//            
//        })
//    }
    
    
    
    
}
