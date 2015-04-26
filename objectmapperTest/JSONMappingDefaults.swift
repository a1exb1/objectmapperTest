//
//  JSONMappingDefaults.swift
//  objectmapperTest
//
//  Created by Alex Bechmann on 26/04/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

let kSharedInstance = JSONMappingDefaults()

class JSONMappingDefaults: NSObject {
   
    var dateFormat = "dd/MM/yyyy HH:mm:ss"
    var webApiSendDateFormat: String?
    
    class func sharedInstance() -> JSONMappingDefaults {
        return kSharedInstance
    }
    
}
