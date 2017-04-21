//
//  UserApi.swift
//  Elite Condos Supplier
//
//  Created by Khoa on 3/8/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation
import FirebaseAuth
class UserApi{
    
    var CURRENT_USER: FIRUser?{
        if let currentUser = FIRAuth.auth()?.currentUser{
            return currentUser
        }
        return nil
    }
    
}
