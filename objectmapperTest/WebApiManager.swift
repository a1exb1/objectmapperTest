//
//  WebApiUrlManager.swift
//  objectmapperTest
//
//  Created by Alex Bechmann on 29/04/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit



class WebApiManager: NSObject {
   
    var domain: String?
    var restKey: String?
    //var webApiManagerDelegate: WebApiManagerDelegate?
    
    func setupUrlsForREST(restKey: String, overrideDomain: String?) -> WebApiManager {
        
        self.domain = overrideDomain
        self.restKey = restKey
        
        return self
    }
    
    func setupUrlsForREST(key: String) -> WebApiManager {
        
        return setupUrlsForREST(key, overrideDomain: nil)
    }
    
    private func getDomain() -> String{
        
        var domain = ""
        
        if let d = WebApiDefaults.sharedInstance().domain {
            
            domain = d
        }
        
        if let d = self.domain {
            
            domain = d
        }
        
        return domain
    }
    
    private func mutableUrl(id: Int) -> String? {
        
        return validRestUrlSet() ? "\(getDomain())/\(restKey!)/\(id)" : nil
    }
    
    private func staticUrl() -> String? {
        
        return validRestUrlSet() ? "\(getDomain())/\(restKey!)" : nil
    }
    
    func updateUrl(id: Int?) -> String? {
        
        if let id = id {
            
            return mutableUrl(id)
        }
        
        return nil
    }
    
    func insertUrl() -> String? {
        
        return staticUrl()
    }
    
    func getUrl(id: Int) -> String? {
        
        return mutableUrl(id)
    }
    
    func deleteUrl(id: Int?) -> String? {
        
        if let id = id {
            
            return mutableUrl(id)
        }
        
        return nil
    }
    
    func validRestUrlSet() -> Bool {
     
        return restKey != nil
    }
}
