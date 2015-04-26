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
        
        var u: User = User.createObjectFromDict(dict)
    
        var json:String = u.convertToJSONString(nil, includeNestedProperties: false)
            json = json.replaceString("\"", withString: "#")
        println(json)
        //println(JSON(json))
        
        
    }

}

