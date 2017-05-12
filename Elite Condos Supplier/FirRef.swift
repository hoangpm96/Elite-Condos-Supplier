//
//  FirRef.swift
//  Elite Condos Supplier
//
//  Created by Khoa on 3/9/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

struct FirRef {
    // DB references
    static let POSTS = DB_BASE.child("posts")
    static let USERS = DB_BASE.child("users")
    static let CUSTOMERS = DB_BASE.child("customers")
    static let SUPPLIERS = DB_BASE.child("suppliers")
    static let EMPLOYEES = DB_BASE.child("employees")
    static let ORDERS = DB_BASE.child("orders")
    
    static let SERVICES = DB_BASE.child("services")
    static let SUPPLIER_ORDERS = DB_BASE.child("supplier-orders")
    static let SUPPLIER_SERVICES = DB_BASE.child("supplier-services")
    static let CUSTOMER_ORDERS = DB_BASE.child("customer-orders")
    
    
    static let REVIEWS = DB_BASE.child("reviews")
    static let SUPPLIER_REVIEWS = DB_BASE.child("supplier-reviews")
    
    // Storage references
    static  let POST_IMAGES = STORAGE_BASE.child("post-pics")
    static  let ORDER_IMAGES = STORAGE_BASE.child("order-pics")
    
    static  let CUSTOMER_AVATAR = STORAGE_BASE.child("customer_avatar")
    static   let SUPPLIER_LOGO = STORAGE_BASE.child("supplier_images")
    static let EMPLOYEE_AVATAR = STORAGE_BASE.child("employee_avatar")

}
