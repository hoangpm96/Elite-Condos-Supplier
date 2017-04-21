//
//  FirRef.swift
//  Elite Condos Supplier
//
//  Created by Khoa on 3/9/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation
import Firebase
let BASE_REF = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

struct FirRef {
    static let SUPPLIER_EMPLOYEES = BASE_REF.child("supplier-employees")
    static let SUPPLIER_SERVICES = BASE_REF.child("supplier-services")
    static let SERVICES = BASE_REF.child("services")
    static let REF_EMPLOYEES = BASE_REF.child("employees")
    static let REF_SUPPLIERS = BASE_REF.child("suppliers")
    
    
    
    static let REF_EMPLOYEE_AVATAR = STORAGE_BASE.child("employee_avatar")
}
