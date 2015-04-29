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
        
//        var dict = [
//            "id" : 5,
//            "Username" : "Alex",
//            "Date" : "20/09/1991 10:00:00",
//            "Products" : [
//                [
//                    "ProductID" : 6,
//                    "Name" : "Box",
//                    "asdf": 34
//                ]
//            ],
//            "Address": [
//                "Ad1" : "32 haughgate close"
//            ]
//        ]
//        
//        var u: User = User.createObjectFromDict(dict)
//    
//        var json:String = u.convertToJSONString(nil, includeNestedProperties: false)
        //println(json)
        
        
        JsonRequest.create(User.webApiUrls().getUrl(1)!, parameters: nil, method: .GET).onDownloadSuccess { (json, request) -> () in

            var user: User = User.createObjectFromJson(json)
            println(user.Username)
            
            user.Username = "Alex3"
            
            println(user.convertToJSON(nil, includeNestedProperties: false))

        }.onDownloadFailure { (error, alert) -> () in
            
            alert.show()
        }
        
        var user = User()
        user.id = 1
        user.webApiDelete()
        
        //User.requestObjectWithID(1)
        
//        User.requestObjectWithID(1)?.onDownloadSuccess{ (json, request) -> () in
//            
//            var user: User = User.createObjectFromJson(json)
//            
//        }
        
        //User.getObjectFromJsonAsync(1)?.ondo
        
//        user.webApiUpdate()?.onDownloadSuccess({ (json, request) -> () in
//            
//            println(json)
//            
//        }).onDownloadFailure({ (error, alert) -> () in
//            
//            alert.show()
//            
//        }).onDownloadFinished({ () -> () in
//            
//            println("done")
//        })
    
    }

}

