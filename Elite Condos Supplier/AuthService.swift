//
//  AuthService.swift
//  Elite Condos Supplier
//
//  Created by Khoa on 3/8/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthService{
    
    static func login(email: String, password: String, onSuccess: @escaping () -> Void,  onError: @escaping (String) -> Void){
        
        
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil{
                let errorDetail = (error as! NSError).localizedDescription
                onError(errorDetail)
            }else{
                let id = user?.uid
                userId = id!
                FirRef.USERS.child(id!).observeSingleEvent(of: .value, with: {snapshot in
                    if let userData = snapshot.value as? Dictionary<String,Any>{
                        print(userData)
                        if userData["customer"] != nil{
                            onError("Tài khoản của bạn là khách hàng, vui lòng xử dụng ứng Elite Condos!")
                        }
                        if userData["supplier"] != nil{
                           onSuccess()
                            
                        }
                        
                    }
                }
                )
            }
        })
    }
    
    
    static func signUp(email: String){
        
        
    }
    
    
    
    static func logout( onSuccess: () -> Void, onError: (String) -> Void ){
        
        do {
            try FIRAuth.auth()?.signOut()
            onSuccess()
        }catch{
            onError("Can't sign out!")
        }
        
        
    }
}
