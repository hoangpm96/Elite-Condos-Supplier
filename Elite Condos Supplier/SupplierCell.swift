//
//  SupplierCell.swift
//  Elite Condos
//
//  Created by Khoa on 11/15/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase

class SupplierCell: UITableViewCell {

    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configureCell(supplier : Supplier){
        nameLbl.text = supplier.name
        addressLbl.text = supplier.address
        
        let ref = FIRStorage.storage().reference(forURL: supplier.logo)
        
        ref.data(withMaxSize: 2 * 1024 * 1024, completion:
            { data, error in
                if error != nil{
                    print("can't download image from Firebase")
                }else{
                    
                    if let data = data {
                    
                        if let imageData = UIImage(data: data){
                            self.logoImage.image = imageData
                        }
                    }
                }
        
        })
        var totalStars = 0.0
        var count = 0
        DataService.ds.REF_SUPPLIERS.child(supplier.id).child("reviews").observeSingleEvent(of: .value, with: {
            snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                
                for snap in snapshots{
                    //print(snap.value)
                    if let snapData = snap.value as? Dictionary<String,Any>{
                        if let star = snapData["stars"] as? Double{
                            count += 1
                            totalStars += star
                            
                        }
                        
                    }
                }
                if count == 0{
                    totalStars = 0.0
                    self.rating.rating = totalStars
                }else {
                    self.rating.rating = totalStars / Double(count)
                }
                self.rating.text = "\(count) lượt nhận xét"
            }
        })
     
        
    }
  

}
