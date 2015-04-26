//
//  User.swift
//  objectmapperTest
//
//  Created by Alex Bechmann on 26/04/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class User: JSONObject {
   
    var UserID = 0
    var Name = ""
    var Date:NSDate = NSDate()
    var Products = Array<Product>()
    var address = Address()
    
    override func registerClassesForJsonMapping() {
        
        self.registerClass(Product.self, forKey: "Products")
        self.registerClass(Address.self, propertyKey: "address", jsonKey: "Address")
    }
    
    func webApiUrl() -> String {
        return "http://topik.ustwo.com/Users"
    }
}
