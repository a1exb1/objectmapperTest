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

//protocol JSONObjectOptionsDelegate {
//    func registerClassesForJsonMapping()
//}

class Mapping {
    var mClass: AnyClass = AnyClass.self
    var jsonType: JSONType = JSONType.Object
}

class MappingKey {
    var propertyKey = ""
    var jsonKey = ""
}

class JSONObject: NSObject { // , JSONObjectOptionsDelegate {
    
    required override init() {}
    
    //var initializerJSON: JSON? = nil
    
    private var classMappings = Dictionary<String, Mapping>()
    
    //var delegate: JSONObjectOptionsDelegate?
    
    class func jsonURL(id:Int) -> String {
        return ""
    }
    
    //    class func getObjectFromJsonAsync(id:Int, completion: (object:JSONObject?) -> () ) {
    //
    //        JSONReader.JsonAsyncRequest((self as AnyClass).jsonURL(id), data: nil, httpMethod: .GET) { (json:JSON) -> () in
    //
    //            completion(object: self.createObjectFromJson(json))
    //        }
    //    }
    //
    //    class func getObjectFromJsonAsync(url:String, completion: (object:JSONObject?) -> () ) {
    //
    //        JSONReader.JsonAsyncRequest(url, data: nil, httpMethod: .GET) { (json:JSON) -> () in
    //
    //            completion(object: self.createObjectFromJson(json))
    //        }
    //    }
    
    //<T : Person>() -> T
//    
//    class func getObjectFromJsonAsync< T : JSONObject >(id:Int, completion: (object:T) -> () ) {
//        
//        JsonRequest.create((self as AnyClass).jsonURL(id), parameters: nil, method: .GET).onDownloadSuccess { (json, request) -> () in
//            
//            completion(object: self.createObjectFromJson(json))
//        }
//    }
//    
//    class func getObjectFromJsonAsync< T : JSONObject >(url:String, completion: (object:T) -> () ) {
//        
//        JsonRequest.create(url, parameters: nil, method: .GET).onDownloadSuccess { (json, request) -> () in
//            
//            completion(object: self.createObjectFromJson(json))
//        }
//    }
    
//    class func createObjectFromJson< T : JSONObject >(json:JSON) -> T {
//        
//        var mapper = DCKeyValueObjectMapping.mapperForClass(self.classForCoder())
//        var rc: JSONObject = mapper.parseDictionary(json.dictionaryObject) as! T
//        rc.initializerJSON = json
//        rc.setExtraPropertiesFromJSON(json)
//        return rc as! T
//    }
    
    
    
    // With type
    //    class func getObjectFromJsonAsync< T : JSONObject >(type: T.Type, id:Int, completion: (object:T) -> () ) {
    //
    //        JSONReader.JsonAsyncRequest((self as AnyClass).jsonURL(id), data: nil, httpMethod: HttpMethod.GET, onSuccess: { (json:JSON) -> () in
    //
    //            var obj:T = self.createObjectFromJson(json)
    //            completion(object: obj)
    //
    //        }, onFailure: nil, onFinished: nil)
    //    }
    //
    //    class func getObjectFromJsonAsync< T : JSONObject >(type: T.Type, url:String, completion: (object:T) -> () ) {
    //
    //        JSONReader.JsonAsyncRequest(url, data: nil, httpMethod: httpMethod, onSuccess: { (json) -> () in
    //
    //            var obj:T = self.createObjectFromJson(json)
    //            completion(object: obj)
    //
    //        }, onFailure: nil, onFinished: nil)
    //
    //    }
    //
    //    class func createObjectFromJson< T : JSONObject >(type: T.Type, json:JSON) -> T {
    //
    //        var mapper = DCKeyValueObjectMapping.mapperForClass(self.classForCoder())
    //        var rc: JSONObject = mapper.parseDictionary(json.dictionaryObject) as! T
    //        rc.setExtraPropertiesFromJSON(json)
    //        return rc as! T
    //    }
    
    
    
    
    
    //    class func createObjectFromJson< T : JSONObject >(json:JSON, type: T.Type ) -> T? {
    //
    //        var mapper = DCKeyValueObjectMapping.mapperForClass(self.classForCoder())
    //        var rc: JSONObject = mapper.parseDictionary(json.dictionaryObject) as! T
    //        rc.setExtraPropertiesFromJSON(json)
    //        return rc as? T
    //    }
    
    //    class func createObjectFromJson(json:JSON) -> JSONObject? {
    //
    //
    //        var mapper = DCKeyValueObjectMapping.mapperForClass(self.classForCoder())
    //        var rc: JSONObject = mapper.parseDictionary(json.dictionaryObject) as! T
    //        rc.setExtraPropertiesFromJSON(json)
    //        return rc as? T
    //    }
    
    
//    func setExtraPropertiesFromJSON(json:JSON) {
//        
//    }
//    
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
        
        
        for key in keys() {
            
            if let mapper = classMappings[key] {

                if dict[key] is [AnyObject] {
                    
                    var array = Array<AnyObject>()
                    var objectDictionary = dict[key] as! [AnyObject]
                    
                    for i:Int in 0...objectDictionary.count-1 {
                        
                        var object: JSONObject = mapper.mClass.alloc() as! JSONObject
                        object.setPropertiesFromDict(objectDictionary[i] as! Dictionary<String, AnyObject>)
                        array.append(object)
                    }
                    
                    self.setValue(array, forKey: key)
                }

                if dict[key] is Dictionary<String, AnyObject> {
                    
                    var object: JSONObject = mapper.mClass.alloc() as! JSONObject
                    object.setPropertiesFromDict(dict[key] as! Dictionary<String, AnyObject>)
                    self.setValue(object, forKey: key)
                }
                
            }
            else if contains(dict.keys, key) {
                
                if dict[key] != nil {
                    
                    //check if types match
                    self.setValue(dict[key]!, forKey: key)
                }
            }            
        }
    }
    
    class func createObjectFromDict< T : JSONObject >(dict: Dictionary<String, AnyObject?>) -> T {
        
        var obj = T()
        obj.setPropertiesFromDict(dict)
        return obj
    }
    
//    func registerClass(anyClass: AnyClass, forKey: String) {
//        registerClass(anyClass, forKey: forKey, type: JSONType.Object)
//    }
    
    func registerClass(anyClass: AnyClass, forKey: String) {
        
        var mapping = Mapping()
        mapping.mClass = anyClass
        //mapping.jsonType = type
        
        classMappings[forKey] = mapping
    }
    
    func registerClassesForJsonMapping() {
        
    }
}
