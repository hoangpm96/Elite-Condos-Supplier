//
//  ServiceData.swift
//  Elite Condos
//
//  Created by Khoa on 3/15/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation



struct ServiceData{
    var id: String!
    var name: String!
    var imgUrl: String!
    var subCategory: [ServiceData]?
    
    init(id: String, name: String, imgUrl: String, subCategories: [ServiceData]?) {
        self.id = id
        self.name = name
        self.imgUrl = imgUrl
        self.subCategory = subCategories
    }
}


func getServiceData() -> [ServiceData]{
    let electricalService = ServiceData(id: "service01", name: "Electrical", imgUrl: "electrical.jpg", subCategories: nil)
    
    let plumbing = ServiceData(id: "service02", name: "Pluming", imgUrl: "plumbing.png", subCategories: nil)
    
    let appliances = ServiceData(id: "service03", name: "Appliances", imgUrl: "appliances.png", subCategories: nil)
    let services = [appliances,electricalService,plumbing]
    return services
    
}
