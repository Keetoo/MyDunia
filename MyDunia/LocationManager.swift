//
//  UserLocation.swift
//  MyDunia
//
//  Created by Rajeev kumar singh on 7/12/17.
//  Copyright © 2017 TalentTrobe(India.com. All rights reserved.
//

import UIKit
import CoreLocation





typealias MyDuniaLocationCompletionHandler = ((_ latitude:Double, _ longitude:Double, _ status:String, _ verboseMessage:String, _ error:String?)->())?

class LocationManager: NSObject, CLLocationManagerDelegate {

    /* Private variables */
    fileprivate var completionHandler:MyDuniaLocationCompletionHandler
    
    
    
    fileprivate var locationStatus : NSString = "Calibrating"// to pass in handler
    fileprivate var locationManager: CLLocationManager!
    fileprivate var verboseMessage = "Calibrating"
    
    fileprivate let verboseMessageDictionary = [CLAuthorizationStatus.notDetermined:"You have not yet made a choice with regards to this application.",
                                                CLAuthorizationStatus.restricted:"This application is not authorized to use location services. Due to active restrictions on location services, the user cannot change this status, and may not have personally denied authorization.",
                                                CLAuthorizationStatus.denied:"You have explicitly denied authorization for this application, or location services are disabled in Settings.",
                                                CLAuthorizationStatus.authorizedAlways:"App is Authorized to use location services.",
                                                CLAuthorizationStatus.authorizedWhenInUse:"You have granted authorization to use your location only when the app is visible to you."]
    
    
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    
    var latitudeAsString:String = ""
    var longitudeAsString:String = ""
    
    
    var lastKnownLatitude:Double = 0.0
    var lastKnownLongitude:Double = 0.0
    
    var lastKnownLatitudeAsString:String = ""
    var lastKnownLongitudeAsString:String = ""
    
    
    var keepLastKnownLocation:Bool = true
    var hasLastKnownLocation:Bool = true
    
    var autoUpdate:Bool = false
    
    var showVerboseMessage = false
    
    var isRunning = false

    
    
    
    class var sharedInstance : LocationManager {
        
        struct Static {
            static let instance : LocationManager = LocationManager()
        }
        return Static.instance
    }
    
    
    fileprivate override init(){
        
        super.init()
        
        if(!autoUpdate){
            autoUpdate = !CLLocationManager.significantLocationChangeMonitoringAvailable()
        }
        
    }
    
    fileprivate func resetLatLon(){
        
        latitude = 0.0
        longitude = 0.0
        
        latitudeAsString = ""
        longitudeAsString = ""
        
    }
    
    fileprivate func resetLastKnownLatLon(){
        
        hasLastKnownLocation = false
        
        lastKnownLatitude = 0.0
        lastKnownLongitude = 0.0
        
        lastKnownLatitudeAsString = ""
        lastKnownLongitudeAsString = ""
        
    }
    
    func startUpdatingLocationWithCompletionHandler(_ completionHandler:((_ latitude:Double, _ longitude:Double, _ status:String, _ verboseMessage:String, _ error:String?)->())? = nil){
        
        self.completionHandler = completionHandler
        
        initLocationManager()
    }
    
    
    func startUpdatingLocation(){
        
        initLocationManager()
    }
    
    func stopUpdatingLocation(){
        
        if(autoUpdate){
            locationManager.stopUpdatingLocation()
        }else{
            
            locationManager.stopMonitoringSignificantLocationChanges()
        }
        
        
        resetLatLon()
        if(!keepLastKnownLocation){
            resetLastKnownLatLon()
        }
    }
    
    fileprivate func initLocationManager() {
        
        // App might be unreliable if someone changes autoupdate status in between and stops it
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        // locationManager.locationServicesEnabled
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let Device = UIDevice.current
        
        let iosVersion = NSString(string: Device.systemVersion).doubleValue
        
        let iOS8 = iosVersion >= 8
        
        if iOS8{
            
            //locationManager.requestAlwaysAuthorization() // add in plist NSLocationAlwaysUsageDescription
            locationManager.requestWhenInUseAuthorization() // add in plist NSLocationWhenInUseUsageDescription
        }
        
        startLocationManger()
        
        
    }
    
    fileprivate func startLocationManger(){
        
        if(autoUpdate){
            
            locationManager.startUpdatingLocation()
        }else{
            
            locationManager.startMonitoringSignificantLocationChanges()
        }
        
        isRunning = true
        
    }
    
    
    fileprivate func stopLocationManger(){
        
        if(autoUpdate){
            
            locationManager.stopUpdatingLocation()
        }else{
            
            locationManager.stopMonitoringSignificantLocationChanges()
        }
        
        isRunning = false
    }
    
    
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        stopLocationManger()
    
        resetLatLon()
        
        if(!keepLastKnownLocation){
            
            resetLastKnownLatLon()
        }
        
        var verbose = ""
        if showVerboseMessage {verbose = verboseMessage}
        completionHandler?(0.0, 0.0, locationStatus as String, verbose,error.localizedDescription)
        
        /*if ((delegate != nil) && (delegate?.responds(to: #selector(LocationManagerDelegate.locationManagerReceivedError(_:))))!){
            delegate?.locationManagerReceivedError!(error.localizedDescription as NSString)
        }*/
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let arrayOfLocation = locations as NSArray
        let location = arrayOfLocation.lastObject as! CLLocation
        let coordLatLon = location.coordinate
        
        latitude  = coordLatLon.latitude
        longitude = coordLatLon.longitude
        
        latitudeAsString  = coordLatLon.latitude.description
        longitudeAsString = coordLatLon.longitude.description
        
        var verbose = ""
        
        if showVerboseMessage {verbose = verboseMessage}
        
        if(completionHandler != nil){
            
            completionHandler?(latitude, longitude, locationStatus as String,verbose, nil)
        }
        
        lastKnownLatitude = coordLatLon.latitude
        lastKnownLongitude = coordLatLon.longitude
        
        lastKnownLatitudeAsString = coordLatLon.latitude.description
        lastKnownLongitudeAsString = coordLatLon.longitude.description
        
        hasLastKnownLocation = true
        
        /*if (delegate != nil){
            if((delegate?.responds(to: #selector(LocationManagerDelegate.locationFoundGetAsString(_:longitude:))))!){
                delegate?.locationFoundGetAsString!(latitudeAsString as NSString,longitude:longitudeAsString as NSString)
            }
            if((delegate?.responds(to: #selector(LocationManagerDelegate.locationFound(_:longitude:))))!){
                delegate?.locationFound(latitude,longitude:longitude)
            }
        }*/
    }
    
    
    internal func locationManager(_ manager: CLLocationManager,
                                  didChangeAuthorization status: CLAuthorizationStatus) {
        var hasAuthorised = false
        let verboseKey = status
        switch status {
        case CLAuthorizationStatus.restricted:
            locationStatus = "Restricted Access"
        case CLAuthorizationStatus.denied:
            locationStatus = "Denied access"
        case CLAuthorizationStatus.notDetermined:
            locationStatus = "Not determined"
        default:
            locationStatus = "Allowed access"
            hasAuthorised = true
        }
        
        verboseMessage = verboseMessageDictionary[verboseKey]!
        
        if (hasAuthorised == true) {
            startLocationManger()
        }else{
            
            resetLatLon()
            if (!locationStatus.isEqual(to: "Denied access")){
                
                var verbose = ""
                if showVerboseMessage {
                    
                    verbose = verboseMessage
                    
                    /*if ((delegate != nil) && (delegate?.responds(to: #selector(LocationManagerDelegate.locationManagerVerboseMessage(_:))))!){
                        
                        delegate?.locationManagerVerboseMessage!(verbose as NSString)
                        
                    }*/
                }
                
                if(completionHandler != nil){
                    completionHandler?(latitude, longitude, locationStatus as String, verbose,nil)
                }
            }
            /*if ((delegate != nil) && (delegate?.responds(to: #selector(LocationManagerDelegate.locationManagerStatus(_:))))!){
                delegate?.locationManagerStatus!(locationStatus)
            }*/
        }
        
    }
    
    
    
    
    
    
    
    

}
