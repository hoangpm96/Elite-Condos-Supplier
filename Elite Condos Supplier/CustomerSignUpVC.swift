//
//  CustomerSignUpVC.swift
//  Elite Condos
//
//  Created by Khoa on 11/14/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
class CustomerSignUpVC: UIViewController, UIImagePickerControllerDelegate,
    UINavigationControllerDelegate{

    @IBOutlet weak var passwordTF: FancyField!
    @IBOutlet weak var phoneTF: FancyField!
    @IBOutlet weak var addressTF: FancyField!
    @IBOutlet weak var emailTF: FancyField!
    @IBOutlet weak var nameTF: FancyField!
    @IBOutlet weak var profileImage: CircleImage!
  

    @IBOutlet weak var avatarImage: CircleImage!
    
    
    var imagePicker : UIImagePickerController!
    var pickedImage = false
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
       
        
       
        
       
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            avatarImage.image = image
            pickedImage = true
        }else {
            print("Can't show picker")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }

    
    @IBAction func signUpButton(_ sender: Any) {
        
        guard let name = nameTF.text, name != ""
            else {
                showAlert(title: SIGN_UP_ERROR, message: SIGN_UP_ERROR_NAME)
                return
        }
        guard let email = emailTF.text, let password = passwordTF.text, email != "",  password != ""
        else {
            showAlert(title: SIGN_UP_ERROR, message: SIGN_UP_ERROR_EMAIL_PASSWORD )
            return
        }
        guard let address = addressTF.text, address != ""
            else {
                showAlert(title: SIGN_UP_ERROR, message: SIGN_UP_ERROR_ADDRESS)
                return
        }
        guard let phone = phoneTF.text, address != ""
            else {
                showAlert(title: SIGN_UP_ERROR, message: SIGN_UP_ERROR_PHONE)
                return
        }
        var avatarUrl = DEFAULT_CUSTOMER_AVATAR
        if let imgData = UIImageJPEGRepresentation(avatarImage.image!, 0.2){
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.ds.REF_CUSTOMER_AVATAR.child(imgUid).put(imgData, metadata: metadata, completion: { (metadata, error) in
                if error != nil{
                    print("Error to upload to server")
                }else{
                    avatarUrl = (metadata?.downloadURL()?.absoluteString)!
                }
            })
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil{
                
                let errorDetail = (error as! NSError).localizedDescription
                
                self.showAlert(title: SIGN_UP_ERROR, message: errorDetail)
            }
            if let user = user{
                let uid = user.uid
                let userData = [
                    "name" : name,
                    "email" : email,
                    "address" : address,
                    "phone" : phone,
                    "avatarUrl" : avatarUrl
                ]
                DataService.ds.createFirebaseDBCutomer(uid: uid, userData: userData)                
            }
            
            
        })
        
    }
    
    func showAlert(title: String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    @IBAction func pickAvatar(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
}
