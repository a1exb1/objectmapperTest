//
//  ViewController.swift
//  objectmapperTest
//
//  Created by Alex Bechmann on 26/04/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var dict = [
            "UserID" : 5,
            "Name" : "Alex",
            "Date" : "20/09/1991 10:00:00",
            "Products" : [
                [
                    "ProductID" : 6,
                    "Name" : "Box",
                    "asdf": 34
                ]
            ],
            "Address": [
                "Ad1" : "32 haughgate close"
            ]
        ]
        
        //var u = User()
        //println(u.valueForKey("Name")! is String)
    
        //u.setPropertiesFromDict(dict)
        
        var u: User = User.createObjectFromDict(dict)
        
        println(u.Name)
        println(u.UserID)
        println(u.Products[0].Name)
        println(u.address.Ad1)
        println(u.Date)
        
        println(u.convertToDictionary(nil))
        
    }
    
//    func v () {
//        
//        var count
//        var properties: objc_property_t = class_copyPropertyList(User.self, <#outCount: UnsafeMutablePointer<UInt32>#>)
//        
//        unsigned count;
//        objc_property_t *properties = class_copyPropertyList([self class], &count);
//        for (NSInteger i = 0; i < count; i++) {
//            NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
//            [dict setObject:key forKey:key];
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

