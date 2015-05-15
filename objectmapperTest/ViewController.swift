//
//  ViewController.swift
//  objectmapperTest
//
//  Created by Alex Bechmann on 26/04/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        User.requestObjectWithID(1)?.onDownloadSuccess({ (json, request) -> () in
            
            self.user = User.createObjectFromJson(json)
            self.updateUser()
        })
    }

    func updateUser() {
        
        user.Username = "Alex4"
        user.webApiUpdate()
    }
}

