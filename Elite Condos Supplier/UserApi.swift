//
//  UserApi.swift
//  Elite Condos Supplier
//
//  Created by Khoa on 3/8/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation
import Firebase
class UserApi{
    
    var CURRENT_USER: FIRUser?{
        if let currentUser = FIRAuth.auth()?.currentUser{
            return currentUser
        }
        return nil
    }
    func currentUid() -> String{
        
        let currentUser = FIRAuth.auth()?.currentUser
        
        return (currentUser?.uid)!
        
    }
    
    
    
    
    func getUserLocation(userId: String, onSuccess: @escaping (Double,Double) -> Void){
        FirRef.USERS.child(userId).child("locations").observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String:Double]{
                if let lat = dict["lat"], let long = dict["long"] {
                    onSuccess(lat,long)
                }
            
                
            }
        })
        
        
        
    }
    
    
    func downloadUserImage(onError: @escaping (String) -> Void, onSuccess: @escaping (UIImage) -> Void){
        
        
        FirRef.SUPPLIERS.child(currentUid()).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snap = snapshot.value as? [String:Any]{
                if let imgUrl = snap["logoUrl"] as? String{
                    self.downloadImage(imgUrl: imgUrl, onError: { (error) in
                        onError(error)
                    }, onSuccess: { (img) in
                        onSuccess(img)
                    })
                }
            }
        })
    }
    
    func downloadImage(imgUrl: String, onError: @escaping (String) -> Void, onSuccess: @escaping (UIImage) -> Void ){
        let storage = FIRStorage.storage()
        let ref = storage.reference(forURL: imgUrl)
        ref.data(withMaxSize: 3 * 1024 * 1024) { (data, error) in
            if let error = error {
                onError(error.localizedDescription)
            }else{
                let img = UIImage(data: data!)
                onSuccess(img!)
            }
        }
    }
    
    func forgetPassword(email: String, onError: @escaping (String) -> Void, onSuccess: @escaping () -> Void ){
        FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
            if error != nil {
                onError((error?.localizedDescription)!)
                return
            }
            onSuccess()
        })
    }
    
    func updatePhone(phone: String, onSuccess: @escaping () -> Void) {
        guard let user = FIRAuth.auth()?.currentUser else {
            return
        }
        FirRef.SUPPLIERS.child(user.uid).updateChildValues(["phone": phone])
        
        onSuccess()
    }
    
    func updateName(name: String, onSuccess: @escaping () -> Void) {
        guard let user = FIRAuth.auth()?.currentUser else {
            return
        }
        FirRef.SUPPLIERS.child(user.uid).updateChildValues(["name": name])
        
        onSuccess()
    }
    
    
    func updateEmail(email: String, onError: @escaping (String) -> Void, onSuccess: @escaping () -> Void){
        
        
        guard let user = FIRAuth.auth()?.currentUser else {
            return
        }
        FIRAuth.auth()?.currentUser?.updateEmail(email, completion: { (callback) in
            if callback != nil {
                onError((callback?.localizedDescription)!)
                return
            } else {
                FirRef.SUPPLIERS.child(user.uid).updateChildValues(["email": email])
             onSuccess()
            }
            
        })
        
    }
    
    func updateAvatar(image: UIImage,onSuccess: @escaping (String) -> Void, onError: @escaping (String) -> Void ){
        
        uploadAvatar(avatarImg: image, onSuccess: { (imageUrl) in
         FirRef.SUPPLIERS.child(Api.User.currentUid()).updateChildValues(["logoUrl": imageUrl])
            
        }, onError: onError)
        
        
    }
    
    func updatePassword(password: String, onError: @escaping (String) -> Void){
        
        FIRAuth.auth()?.currentUser?.updatePassword(password, completion: { (error) in
            if error != nil {
                onError((error?.localizedDescription)!)
            }
        })
    }
    
    func signOut(onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void){
        do {
            try  FIRAuth.auth()?.signOut()
            onSuccess()
        } catch{
            onError("can't sign out")
        }
    }
    
    func uploadAvatar(avatarImg: UIImage,onSuccess: @escaping (String) -> Void, onError: @escaping (String) -> Void ){
        
        if let imgData = UIImageJPEGRepresentation(avatarImg, 0.2){
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            FirRef.SUPPLIER_LOGO.child(imgUid).put(imgData, metadata: metadata, completion: { (metaData, error) in
                if error != nil{
                    onError(error.debugDescription)
                }else{
                    let downloadURL = metaData!.downloadURL()!.absoluteString
                    onSuccess(downloadURL)
                }
            })
        }
    }
    
    func signUp(name: String, email: String, password: String, phone: String, address: String, avatarImg: UIImage, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void){
        
        uploadAvatar(avatarImg: avatarImg, onSuccess: { (imgUrl) in
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                
                if error != nil{
                    
                  
                    
                    onError((error?.localizedDescription)!)
                }
                if let user = user{
                    let userData = [
                        "name" : name,
                        "email" : email,
                        "phone" : phone,
                        "avatarUrl" : imgUrl,
                        "address": address
                    ]
                    
                    self.createFirebaseDBCutomer(uid: user.uid, userData: userData)
                    onSuccess()
                }
            })
            
        }) { (error) in
            onError(error)
        }
        
    }
    
    
    func loadUserData(completed: @escaping (String,String,String) -> Void){
        guard let user = FIRAuth.auth()?.currentUser else {
            return
        }
        
        FirRef.SUPPLIERS.child(user.uid).observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String:Any]{
                guard let phone = dict["phone"] as? String else{
                    return
                }
                guard let name = dict["name"] as? String else{
                    return
                }
                
                
                let email = FIRAuth.auth()?.currentUser?.email
                
                if let email = email{
                    completed(name, email, phone)
                }
                
            }
        })
    }
    
    func login( email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void ) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil{
                
                
                onError((error?.localizedDescription)!)
                
            }else{
                print("Login successfully!")
                
                guard let userId = FIRAuth.auth()?.currentUser?.uid else {
                    return
                }
                
                FirRef.USERS.child(userId).observeSingleEvent(of: .value, with: {snapshot in
                    if let userData = snapshot.value as? Dictionary<String,Any>{
                        print(userData)
                        if let _ = userData["supplier"]{
                            
                            onSuccess()
                        }
                        if let customer = userData["customer"]{
                            print(customer)
                            
                            onError("Tài khoản của bạn là tài khoản khách hàng, vui lòng sử dụng ứng dụng \(APP_NAME)")
                            
                        }
                    }
                }
                )
                
                
                
                
            }
        })
        
    }
    
    
    func createFirebaseDBCutomer(uid : String, userData : Dictionary<String, String>  ){
        
        FirRef.SUPPLIERS.child(uid).updateChildValues(userData)
        
        
        
        let currentTime = getCurrentTime()
        FirRef.USERS.child(uid).updateChildValues(["supplier" : true,
                                                   "created_at" : currentTime])
    }
    

    
}
