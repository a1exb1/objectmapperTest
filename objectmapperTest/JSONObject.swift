//
//  JSONObject.swift
//  Accounts
//
//  Created by Alex Bechmann on 08/04/2015.
//  Copyright (c) 2015 Ustwo. All rights reserved.
//

import UIKit

enum JSONType {
    case Object
    case Array
}

class Mapping {
    var mClass: AnyClass = AnyClass.self
    var jsonType: JSONType = JSONType.Object
    var propertyKey = ""
    var jsonKey = ""
    var dateFormat = ""
}

class KeyWithType {
    var key: String = ""
    var type: MirrorType?
}

@objc protocol WebApiDelegate {
    optional func webApiUrl() -> String
}

class JSONObject: NSObject, WebApiDelegate {
    
    private var classMappings = Dictionary<String, Mapping>()
    var webApiDelegate: WebApiDelegate?
    
    required override init() {
        super.init()
        
        self.webApiDelegate = self
    }
    
    class func jsonURL(id:Int) -> String {
        return ""
    }
    
    class func createObjectFromJson< T : JSONObject >(json:JSON) -> T {
        
        return T.createObjectFromDict(json.dictionaryObject!)
    }
    
    func setExtraPropertiesFromJSON(json:JSON) {
        
    }

//    func convertToJSONString() -> String {
//        
//        return self.JSONString()
//    }
//
//    func convertToDictionary(keysToInclude: Array<String>?) -> Dictionary<String, AnyObject> {
//        
//        var dict = Dictionary<String, AnyObject>()
//        
//        for key in self.objectDictionary().keys {
//            
//            if let keys = keysToInclude {
//                
//                if contains(keys, key as! String) {
//                    
//                    dict[key as! String] = self.objectDictionary()[key]
//                }
//            }
//            else{
//                
//                dict[key as! String] = self.objectDictionary()[key]
//            }
//        }
//        
//        return dict
//    }
    
    
    func convertToDictionary(keysToInclude: Array<String>?) -> Dictionary<String, AnyObject> {

        var dict = Dictionary<String, AnyObject>()

        for key in self.keys() {

            if let keys = keysToInclude {

                if contains(keys, key) {

                    dict[key] = self.valueForKey(key)
                }
            }
            else{
                //if is nested object
                if let jsonObj: JSONObject = self.valueForKey(key) as? JSONObject {
                    
                    dict[key] = jsonObj.convertToDictionary(nil)
                }
                //if is nested array of objects
                else if let jsonObjArray: [JSONObject] = self.valueForKey(key) as? [JSONObject] {
                    
                    var arr = Array<Dictionary<String, AnyObject>>()
                    
                    for obj in jsonObjArray {
                        
                        arr.append(obj.convertToDictionary(nil))
                    }
                    
                    dict[key] = arr
                }
                //if property
                else{
                    
                    //format as string if date
                    if let date: NSDate = self.valueForKey(key) as? NSDate {
                        
                        var dateString = ""
                        
                        if let format = JSONMappingDefaults.sharedInstance().webApiSendDateFormat {
                            dateString = date.toString(format)
                        }
                        else{
                            dateString = date.toISOString()
                        }
                        
                        dict[key] = dateString
                    }
                    else{
                        
                        dict[key] = self.valueForKey(key)
                    }
                }
            }
        }
        
        return dict
    }
    
    func keysWithTypes() -> [KeyWithType] {
        
        let m = reflect(self)
        var s = [KeyWithType]()
        
        for i in 0..<m.count {
            
            let (name, _) = m[i]
            if name == "super"{continue}
            
            var k = KeyWithType()
            k.key = name
            k.type = m[i].1
            s.append(k)
        }
        
        return s
    }
    
    func keys() -> [String] {
        
        let m = reflect(self)
        var s = [String]()
        
        for i in 0..<m.count {
            
            let (name, _) = m[i]
            if name == "super"{continue}
            s.append(name)
        }
        
        return s
    }
    
    
    func setPropertiesFromDict(dict: Dictionary<String, AnyObject?>){
        
        classMappings = Dictionary<String, Mapping>() // this is needed for some reason
        self.registerClassesForJsonMapping()
        
        for k in keysWithTypes() {
            
            let propertyKey = k.key
            
            if let mapper = classMappings[propertyKey] {
                
                ///?
                if mapper.mClass === NSDate.self && dict[mapper.jsonKey] is String{
                    
                    var date = NSDate.dateFromString(dict[mapper.jsonKey]! as! String, format: mapper.dateFormat)
                    self.setValue(date, forKey: mapper.propertyKey)
                }
                
                //if is array of objects
                else if dict[mapper.jsonKey] is [AnyObject] {
                    
                    var array = Array<AnyObject>()
                    var objectDictionary = dict[mapper.jsonKey] as! [AnyObject]
                    
                    for i:Int in 0...objectDictionary.count-1 {
                        
                        var object: JSONObject = mapper.mClass.alloc() as! JSONObject
                        object.setPropertiesFromDict(objectDictionary[i] as! Dictionary<String, AnyObject>)
                        array.append(object)
                    }
                    
                    self.setValue(array, forKey: mapper.propertyKey)
                }

                //if is object
                else if dict[mapper.jsonKey] is Dictionary<String, AnyObject> {
                    
                    var object: JSONObject = mapper.mClass.alloc() as! JSONObject
                    object.setPropertiesFromDict(dict[mapper.jsonKey] as! Dictionary<String, AnyObject>)
                    self.setValue(object, forKey: mapper.propertyKey)
                }
                
            }
            else if contains(dict.keys, propertyKey) {
                
                if let dictionaryValue: AnyObject? = dict[propertyKey]{
                    
                    //check if types match
                    var typeString = "\(k.type)"
                    
                    if typeString.contains("NSDate") {
                        
                        //if received date in dictinoary
                        if let dictionaryValueAsDate = dictionaryValue as? NSDate {
                            self.setValue(dictionaryValueAsDate, forKey: propertyKey)
                        }
                        else{ // translate string to date as default
                            
                            var date = NSDate.dateFromString(dict[propertyKey]! as! String, format: JSONMappingDefaults.sharedInstance().dateFormat)
                            self.setValue(date, forKey: propertyKey)
                        }
                    }
                    else{
                        
                        self.setValue(dictionaryValue, forKey: propertyKey)
                    }
                }
            }            
        }
    }
    
    class func createObjectFromDict< T : JSONObject >(dict: Dictionary<String, AnyObject?>) -> T {
        
        var obj = T()
        obj.setPropertiesFromDict(dict)
        return obj
    }
    
    private func registerClass(anyClass: AnyClass, propertyKey: String, jsonKey: String, format: String?) {
        
        var mapping = Mapping()
        mapping.mClass = anyClass
        mapping.propertyKey = propertyKey
        mapping.jsonKey = jsonKey
        
        if let f = format {
            mapping.dateFormat = f
        }

        classMappings[propertyKey] = mapping
    }
    
    func registerClass(anyClass: AnyClass, propertyKey: String, jsonKey: String) {
        
        registerClass(anyClass, propertyKey: propertyKey, jsonKey: jsonKey, format: nil)
    }
    
    func registerClass(anyClass: AnyClass, forKey: String) {
        
        registerClass(anyClass, propertyKey: forKey, jsonKey: forKey)
    }
    
    func registerDate(propertyKey: String, jsonKey: String, format: String) {
        
        registerClass(NSDate.self, propertyKey: propertyKey, jsonKey: jsonKey, format: format)
    }
    
    func registerDate(forKey: String, format: String) {
        
        registerDate(forKey, jsonKey: forKey, format: format)
    }

//    func registerDate(forKey: String) {
//        
//        registerDate(forKey, jsonKey: forKey, format: JSONMappingDefaults.sharedInstance().dateFormat)
//    }
    
    func registerClassesForJsonMapping() {
        
    }
    
    // MARK: - Web Api Methods
    
    func webApiInsert() -> JsonRequest?{
        
        if let url = webApiDelegate?.webApiUrl?() {
            
            return JsonRequest.create(url, parameters: self.convertToDictionary(nil), method: .POST)
        }
        else{
            println("web api url not set")
            return nil
        }
    }
    
    func webApiUpdate() -> JsonRequest?{
        
        if let url = webApiDelegate?.webApiUrl?() {
            
            return JsonRequest.create(url, parameters: self.convertToDictionary(nil), method: .PUT)
        }
        else{
            println("web api url not set")
            return nil
        }
    }
    
    func webApiDelete() -> JsonRequest?{
        
        if let url = webApiDelegate?.webApiUrl?() {
            
            return JsonRequest.create(url, parameters: self.convertToDictionary(nil), method: .DELETE)
        }
        else{
            println("web api url not set")
            return nil
        }
    }
    
}
