//
//  String+Extension.swift
//  objectmapperTest
//
//  Created by Alex Bechmann on 26/04/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

extension String {
    
    func charCount() -> Int {
        
        return count(self.utf16)
    }
    
    func contains(find: String) -> Bool {
        
        if let temp = self.rangeOfString(find) {
            return true
        }
        return false
    }
}