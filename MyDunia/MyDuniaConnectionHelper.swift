//
//  MyDuniaConnectionHelper.swift
//  MyDunia
//
//  Created by Rajeev kumar singh on 7/11/17.
//  Copyright © 2017 TalentTrobe(India.com. All rights reserved.
//

import UIKit

class MyDuniaConnectionHelper: NSObject {

    class func GetParam(_ params: NSDictionary) -> NSString{
        var passparam : NSString!
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            let theJSONText = NSString(data: jsonData,
                                       encoding: String.Encoding.ascii.rawValue)
            passparam = theJSONText!
        } catch let error as NSError {
            print("getParam() \(error)")
            passparam = ""
        }
        return passparam
    }
    
    
    //https://stackoverflow.com/questions/41745328/completion-handlers-in-swift-3-0
    class  func GetDataFromJson(url: String, paramString: [String : Any], completion: @escaping (_ success: NSDictionary ,  _ Status :Bool) -> Void) {
        
        //@escaping...If a closure is passed as an argument to a function and it is invoked after the function returns, the closure is @escaping.
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        if(paramString != nil){
            request.httpBody =  self.GetParam(paramString as NSDictionary).data(using: String.Encoding.utf8.rawValue)
        }
        
        
        let task = URLSession.shared.dataTask(with: request) { Data, response, error in
            
            guard let _: Data = Data, let _: URLResponse = response, error == nil else {
                
                return
            }
            
            let responseStrInISOLatin = String(data: Data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                print("could not convert data to UTF-8 format")
                
                let dict :[String : AnyObject] = ["alert":"Failed" as AnyObject]
                completion(dict as NSDictionary ,false)
                return
            }
            do {
                let responseJSONDict = try JSONSerialization.jsonObject(with: modifiedDataInUTF8Format)
                completion(responseJSONDict as! NSDictionary ,true)
                print(responseJSONDict)
                
                
            } catch {
                print(error)
            }
            
            
            
        }
        task.resume()
    }
    
    
    class  func GetDataFromJson(url: String,  completion: @escaping (_ success: NSDictionary ,  _ Status :Bool) -> Void) {
        
        
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { Data, response, error in
            
            guard let _: Data = Data, let _: URLResponse = response, error == nil else {
                
                return
            }
            
            let responseStrInISOLatin = String(data: Data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                print("could not convert data to UTF-8 format")
                
                let dict :[String : AnyObject] = ["alert":"Failed" as AnyObject]
                completion(dict as NSDictionary ,false)
                return
            }
            do {
                let responseJSONDict = try JSONSerialization.jsonObject(with: modifiedDataInUTF8Format)
                completion(responseJSONDict as! NSDictionary ,true)
                print(responseJSONDict)
                
                
            } catch {
                print(error)
            }
            
            
            
        }
        task.resume()
    }
    
}
