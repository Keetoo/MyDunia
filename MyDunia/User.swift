//
//  User.swift
//  MyDunia
//
//  Created by Rajeev kumar singh on 7/12/17.
//  Copyright © 2017 TalentTrobe(India.com. All rights reserved.
//

import Foundation
import UIKit


//https://stackoverflow.com/questions/37980432/swift-3-saving-and-retrieving-custom-object-from-userdefaults


 class User : NSObject, NSCoding{

    public var auth_id : String?
    public var first_name: String?
    public var last_name:String?
    public var email : String?
    public var username: String?
    public var gender:String?
    public var marital_status : String?
    public var occupation: String?
    public var phoneno:String?
    public var dob : String?
    public var country_id: String?
    public var city:String?
    public var profile_pic:String?
    public var refferal_code : String?
    public var refferal_by: String?
    //public let areaofintrest:[Int]?
    
    
    internal struct Keys {
        static let auth_id = "auth_id"
        static let first_name = "first_name"
        static let last_name = "last_name"
        static let email = "email"
        static let username = "username"
        static let gender = "gender"
        static let marital_status = "marital_status"
        static let occupation = "occupation"
        static let phoneno = "phoneno"
        static let dob = "dob"
        static let country_id = "country_id"
        static let city = "city"
        static let profile_pic = "profile_pic"
        static let refferal_code = "refferal_code"
        static let refferal_by = "refferal_by"
       // static let areaofintrest = "areaofintrest"
        
    }
    
    
    
    
    init(auth_id: String, first_name: String, last_name:String, email: String, username: String, gender:String ,marital_status: String, occupation: String, phoneno:String,dob: String, country_id: String, city:String, profile_pic:String,refferal_code: String, refferal_by: String, areaofintrest:[Int]) {
      
        self.auth_id = auth_id
        self.first_name = first_name
        self.last_name = last_name
        self.email = email
        self.username = username
        self.gender = gender
        self.marital_status = marital_status
        self.occupation = occupation
        self.phoneno = phoneno
        self.dob = dob
        self.country_id = country_id
        self.city = city
        self.profile_pic = profile_pic
        self.refferal_code = refferal_code
        self.refferal_by = refferal_by
       // self.areaofintrest = areaofintrest
        
        
    }
    
    
    
    
    // MARK: - Object Lifecycle
    public init?(json: NSDictionary) {
      
        guard let auth_id = json[Keys.auth_id] as? String else {return nil}
        guard let first_name = json[Keys.first_name] as? String else {return nil}
        guard let last_name = json[Keys.last_name] as? String else {return nil}
        guard let email = json[Keys.email] as? String else {return nil}
        guard let username = json[Keys.username] as? String else {return nil}
        guard let gender = json[Keys.gender] as? String else {return nil}
        guard let marital_status = json[Keys.marital_status] as? String else {return nil}
        guard let occupation = json[Keys.occupation] as? String else {return nil}
        guard let phoneno = json[Keys.phoneno] as? String else {return nil}
        guard let dob = json[Keys.dob] as? String else {return nil}
        guard let country_id = json[Keys.country_id] as? String else {return nil}
        guard let city = json[Keys.city] as? String else {return nil}
        
        
        var profile_pic = ""
        if let profileImageString = json[Keys.profile_pic] as? String {
            profile_pic = profileImageString
        }/* else {
            // "profile_picture_url" was null
        }
        
        
        
       var str = json[Keys.profile_pic] as? String
        
        if !(str is NSNull) {
            //Whatever you want to do with myField when not null
        } else {
            //Whatever you want to do when myField is null
            str = ""
        }*/
       // guard let profile_pic = str  else {return nil}
        guard let refferal_code = json[Keys.refferal_code] as? String else {return nil}
        guard let refferal_by = json[Keys.refferal_by] as? String else {return nil}
       // guard let areaofintrest = json[Keys.areaofintrest] as? NSArray else {return nil}
        
        
        
        self.auth_id = auth_id
        self.first_name = first_name
        self.last_name = last_name
        self.email = email
        self.username = username
        self.gender = gender
        self.marital_status = marital_status
        self.occupation = occupation
        self.phoneno = phoneno
        self.dob = dob
        self.country_id = country_id
        self.city = city
        self.profile_pic = profile_pic
        self.refferal_code = refferal_code
        self.refferal_by = refferal_by
        //self.areaofintrest = areaofintrest as! [Int]
        
        
    }
    
    // MARK: - Class Constructors
    public class func DictionaryVal(jsonObject:NSDictionary) -> User {
       
        guard let user = User(json: jsonObject) else
        {
            return User(auth_id: "", first_name: "", last_name: "", email: "", username: "", gender: "", marital_status: "", occupation: "", phoneno: "", dob: "", country_id: "", city: "", profile_pic: "", refferal_code: "", refferal_by: "", areaofintrest: [])
        }
        return user
    }

    
    
    
    required  init(coder aDecoder: NSCoder) {
       
        self.auth_id = aDecoder.decodeObject(forKey: Keys.auth_id) as? String
        self.first_name = aDecoder.decodeObject(forKey: Keys.first_name) as? String
        self.last_name = aDecoder.decodeObject(forKey: Keys.last_name) as? String
        self.email = aDecoder.decodeObject(forKey: Keys.email) as? String
        self.username = aDecoder.decodeObject(forKey: Keys.username) as? String
        self.gender = aDecoder.decodeObject(forKey: Keys.gender) as? String
        self.marital_status = aDecoder.decodeObject(forKey: Keys.marital_status) as? String
        self.occupation = aDecoder.decodeObject(forKey: Keys.occupation) as? String
        self.phoneno = aDecoder.decodeObject(forKey: Keys.phoneno) as? String
        self.dob = aDecoder.decodeObject(forKey: Keys.dob) as? String
        self.country_id = aDecoder.decodeObject(forKey: Keys.country_id) as? String
        self.city = aDecoder.decodeObject(forKey: Keys.city) as? String
        self.profile_pic = aDecoder.decodeObject(forKey: Keys.profile_pic) as? String
        self.refferal_code = aDecoder.decodeObject(forKey: Keys.refferal_code) as? String
        self.refferal_by = aDecoder.decodeObject(forKey: Keys.refferal_by) as? String
        
        
        
      /*  self.init(
            
            
            auth_id : auth_id,
            first_name : first_name,
            last_name : last_name,
            email : email,
            username : username,
            gender : gender,
            marital_status : marital_status,
            occupation : occupation,
            phoneno : phoneno,
            dob : dob,
            country_id : country_id,
            city : city,
            profile_pic : profile_pic,
            refferal_code : refferal_code,
            refferal_by : refferal_by
            
        )*/
        
        
    }
    
    
    
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(auth_id, forKey: Keys.auth_id)
        aCoder.encode(first_name, forKey: Keys.first_name)
        aCoder.encode(last_name, forKey: Keys.last_name)
        aCoder.encode(email, forKey: Keys.email)
        aCoder.encode(username, forKey: Keys.username)
        aCoder.encode(gender, forKey: Keys.gender)
        aCoder.encode(marital_status, forKey: Keys.marital_status)
        aCoder.encode(occupation, forKey: Keys.occupation)
        aCoder.encode(phoneno, forKey: Keys.phoneno)
        aCoder.encode(dob, forKey: Keys.dob)
        aCoder.encode(country_id, forKey: Keys.country_id)
        aCoder.encode(city, forKey: Keys.city)
        aCoder.encode(profile_pic, forKey: Keys.profile_pic)
        aCoder.encode(refferal_code, forKey: Keys.refferal_code)
        aCoder.encode(refferal_by, forKey: Keys.refferal_by)
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
