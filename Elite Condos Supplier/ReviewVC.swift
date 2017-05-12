//
//  ReviewVC.swift
//  Elite Condos Supplier
//
//  Created by Khoa on 4/16/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit

class ReviewVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    
    
}
