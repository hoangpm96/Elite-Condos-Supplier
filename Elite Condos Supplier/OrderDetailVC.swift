//
//  OrderDetailVC.swift
//  Elite Condos Supplier
//
//  Created by Khoa on 4/14/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit
import ProgressHUD
import MapKit
class OrderDetailVC: UIViewController {
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var denyButton: UIButton!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var orderId = ""
    var imageUrls = [String]()
    var lat: Double?
    var long: Double?
    var customerName: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHUD.show("Tải thông tin đơn hàng")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        imageUrls = []
        
        Api.Order.observeOrders(orderId: orderId) { (order) in
            self.descriptionLbl.text = order.description
            if order.status != ORDER_STATUS.NOTACCEPTED.hashValue {
                self.denyButton.isHidden = true
                self.acceptButton.isHidden = true
            }
            
            if let imgUrls = order.imgUrls{
                self.imageUrls = imgUrls
                self.collectionView.reloadData()
            }
            
            let customerId = order.customerId
            
            Api.User.getUserLocation(userId: customerId, onSuccess: { (lat, long) in
                self.lat = lat
                self.long = long
            })
            
            Api.Order.getCustomerName(id: order.customerId) { (name) in
                self.customerName = name
            }
            
            ProgressHUD.dismiss()
        }
    }
    @IBAction func denyOrder(_ sender: Any) {
        
        Api.Order.denyOrder(at: orderId, onSuccess: {
          
            self.showDismissAlert()
        })
    }
    @IBAction func acceptOrder(_ sender: Any) {
        Api.Order.acceptOrder(at: orderId) { 
         self.showDismissAlert()
        }
    }
    
    
    
    @IBAction func openMap(_ sender: Any) {
        guard let latitude = lat, let longitude = long else {
            showAlert(title: APP_NAME, message: "Không cập nhật được vị trí khách hàng!")
            return
        }
        openMapForPlace(latitude: latitude, longitude: longitude)
    }
    
    func openMapForPlace(latitude: Double, longitude: Double) {
    
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = customerName
        mapItem.openInMaps(launchOptions: options)
    }
    func showAlert(title: String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func showDismissAlert(){
        
        let alert = UIAlertController(title: APP_NAME, message: "Trạng thái đơn hàng đã thay đổi", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Trở về", style: .default, handler: { action in
            
            self.navigationController?.popToRootViewController(animated: true)
            
        })
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }

    
}

extension OrderDetailVC : UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderDetailCell", for: indexPath) as! OrderDetailCell
        cell.imageLink = imageUrls[indexPath.row]
        return cell
    }
}
extension OrderDetailVC : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //
    //        let size = collectionView.frame.width / 3 - 1
    //        print(collectionView.frame.width)
    //        print(size)
    //        return CGSize(width: size, height: size)
    //    }
    
}

