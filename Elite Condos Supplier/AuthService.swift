//
//  AuthService.swift
//  Elite Condos Supplier
//
//  Created by Khoa on 3/8/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import UIKit
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
    
    
    static func signUp(name: String, email: String, password: String, phone: String, avatarImg: UIImage, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void){
        
        
        
        uploadAvatar(avatarImg: avatarImg, onSuccess: { (imgUrl) in
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                
                if error != nil{
                    
                    let errorDetail = (error! as NSError).localizedDescription
                    
                    onError(errorDetail)
                }
                if let user = user{
                    let userData = [
                        "name" : name,
                        "email" : email,
                        "phone" : phone,
                        "avatarUrl" : imgUrl
                    ]
                    
                    self.createFirebaseDBCutomer(uid: user.uid, userData: userData)
                    onSuccess()
                }
            })
            
        }) { (error) in
            onError(error)
        }
        
    }
    static func uploadAvatar(avatarImg: UIImage,onSuccess: @escaping (String) -> Void, onError: @escaping (String) -> Void ){
        
        if let imgData = UIImageJPEGRepresentation(avatarImg, 0.2){
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            FirRef.CUSTOMER_AVATAR.child(imgUid).put(imgData, metadata: metadata, completion: { (metaData, error) in
                if error != nil{
                    onError(error.debugDescription)
                }else{
                    let downloadURL = metaData!.downloadURL()!.absoluteString
                    onSuccess(downloadURL)
                }
            })
        }
    }

    
   static func createFirebaseDBCutomer(uid : String, userData : Dictionary<String, String>  ){
        
        FirRef.SUPPLIERS.child(uid).updateChildValues(userData)
        let currentTime = getCurrentTime()
        FirRef.SUPPLIERS.child(uid).updateChildValues(["customer" : true,
                                                   "created_at" : currentTime])
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
