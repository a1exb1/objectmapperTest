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

@objc protocol JsonMappingDelegate {
    optional func registerClassesForJsonMapping()
}

class JSONObject: NSObject, WebApiDelegate, JsonMappingDelegate {
    
    private var classMappings = Dictionary<String, Mapping>()
    var webApiDelegate: WebApiDelegate?
    var jsonMappingDelegate: JsonMappingDelegate?
    
    required override init() {
        super.init()
        
        self.webApiDelegate = self
        self.jsonMappingDelegate = self
    }
    
    class func jsonURL(id:Int) -> String {
        return ""
    }
    
    class func createObjectFromJson< T : JSONObject >(json:JSON) -> T {
        
        return T.createObjectFromDict(json.dictionaryObject!)
    }
    
    func setExtraPropertiesFromJSON(json:JSON) {
        
    }

    func convertToJSONString(keysToInclude: Array<String>?, includeNestedProperties: Bool) -> String {
        
        return "\(convertToJSON(keysToInclude, includeNestedProperties: includeNestedProperties))"
    }

    
    func convertToJSON(keysToInclude: Array<String>?, includeNestedProperties: Bool) -> JSON {
        
        return JSON(convertToDictionary(keysToInclude, includeNestedProperties: includeNestedProperties))
    }
    
    func convertToDictionary(keysToInclude: Array<String>?, includeNestedProperties: Bool) -> Dictionary<String, AnyObject> {

        var dict = Dictionary<String, AnyObject>()

        for key in self.keys() {

            var propertyKey: String = classMappings[key] != nil ? classMappings[key]!.jsonKey : key
            
            if let keys = keysToInclude {

                if contains(keys, key) {

                    dict[propertyKey] = self.valueForKey(key)
                }
            }
            else{
                //if is nested object
                if let jsonObj: JSONObject = self.valueForKey(key) as? JSONObject {
                    
                    if includeNestedProperties {
                        
                        dict[propertyKey] = jsonObj.convertToDictionary(nil, includeNestedProperties: false)
                    }
                }
                //if is nested array of objects
                else if let jsonObjArray: [JSONObject] = self.valueForKey(key) as? [JSONObject] {
                    
                    if includeNestedProperties {
                        
                        var arr = Array<Dictionary<String, AnyObject>>()
                        
                        for obj in jsonObjArray {
                            
                            arr.append(obj.convertToDictionary(nil, includeNestedProperties: false))
                        }
                        
                        dict[propertyKey] = arr
                    }
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
                        
                        dict[propertyKey] = dateString
                    }
                    else{
                        
                        dict[propertyKey] = self.valueForKey(key)
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
    
    
    func setPropertiesFromDictionary(dict: Dictionary<String, AnyObject?>){
        
        classMappings = Dictionary<String, Mapping>() // this is needed for some reason
        jsonMappingDelegate?.registerClassesForJsonMapping?()
        
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
                        object.setPropertiesFromDictionary(objectDictionary[i] as! Dictionary<String, AnyObject>)
                        array.append(object)
                    }
                    
                    self.setValue(array, forKey: mapper.propertyKey)
                }

                //if is object
                else if dict[mapper.jsonKey] is Dictionary<String, AnyObject> {
                    
                    var object: JSONObject = mapper.mClass.alloc() as! JSONObject
                    object.setPropertiesFromDictionary(dict[mapper.jsonKey] as! Dictionary<String, AnyObject>)
                    self.setValue(object, forKey: mapper.propertyKey)
                }
                
            }
            else if contains(dict.keys, propertyKey) {
                
                if let dictionaryValue: AnyObject? = dict[propertyKey]{
                    
                    //TODO: - check for more types
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
        obj.setPropertiesFromDictionary(dict)
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
            
            return JsonRequest.create(url, parameters: self.convertToDictionary(nil, includeNestedProperties: false), method: .POST)
        }
        else{
            println("web api url not set")
            return nil
        }
    }
    
    func webApiUpdate() -> JsonRequest?{
        
        if let url = webApiDelegate?.webApiUrl?() {
            
            return JsonRequest.create(url, parameters: self.convertToDictionary(nil, includeNestedProperties: false), method: .PUT)
        }
        else{
            println("web api url not set")
            return nil
        }
    }
    
    func webApiDelete() -> JsonRequest?{
        
        if let url = webApiDelegate?.webApiUrl?() {
            
            return JsonRequest.create(url, parameters: self.convertToDictionary(nil, includeNestedProperties: false), method: .DELETE)
        }
        else{
            println("web api url not set")
            return nil
        }
    }
    
}
