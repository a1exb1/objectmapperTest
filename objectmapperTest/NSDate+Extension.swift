//
//  NSDate+Extension.swift
//  objectmapperTest
//
//  Created by Alex Bechmann on 26/04/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

extension NSDate {
    
    class func dateFromString(dateString:String, format:String) -> NSDate{
        //var s = dateString.stringByReplacingOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil) as String
        //s = dateString.stringByReplacingOccurrencesOfString("T", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.dateFromString(dateString)!
    }
    
    func toString(format:String?) -> String{
        var f = format != nil ? format : "dd/MM/yyyy HH:mm:ss"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = f
        return dateFormatter.stringFromDate(self)
    }
    
     func toISOString() -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return dateFormatter.stringFromDate(self).stringByAppendingString("+00:00Z")
    }
    
     class func dateFromISOString(string: String) -> NSDate {
        var dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return dateFormatter.dateFromString(string)!
    }
}