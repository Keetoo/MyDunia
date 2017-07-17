//
//  EmergenvyContactVC.swift
//  MyDunia
//
//  Created by Maahi on 12/07/17.
//  Copyright © 2017 TalentTrobe(India.com. All rights reserved.
//

import UIKit
import ReachabilitySwift


private let reuseIdentifier = "EmergencyContactCell"
class EmergenvyContactVC: UIViewController {

    var econtactList : [Dictionary<String, Any>] = []
    @IBOutlet weak var contactCollView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    var array:[String] = []
    
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    var locationManager = LocationManager.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        locationManager.autoUpdate = false
        locationManager.startUpdatingLocationWithCompletionHandler { (lat, lang, Status, verboseMsg, error)  in
            self.latitude = lat
            self.longitude = lang
            
            print(lat,lat,Status,verboseMsg)
        }
        GetEmergencyContact()
    }

    
    deinit {
        
        print("EmergenvyContactVC deinit Called")
        
    }
    
    
    
    func GetEmergencyContact() {
        
        
        //Call api
        let reachability = Reachability()!
        if !reachability.isReachable {
            let alert = UIAlertController(title: "Alert!", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        activityIndicator.startAnimating()
        let urlString = BaseUrl + MyDunia_GetEmergencyContacts
        let paramString = ["lat":"28.5710132","lng":"77.2363538"] as [String : Any]
        MyDuniaConnectionHelper.GetDataFromJson(url: urlString, paramString: paramString) { (responce, status) in
            
            print(responce)
            
            self.activityIndicator.stopAnimating()
            
            let responceDict = (responce.object(forKey: "response") as! NSDictionary)
            
            if let statusVal = responceDict.object(forKey: "status") {
                if (statusVal as! NSNumber).intValue == 1 {
                    
                    if  let resultDict = responceDict.object(forKey: "result") {
                        
                        
                       self.econtactList = resultDict  as! [Dictionary<String, Any>]
                        
                        let dict = self.econtactList[0]
                        let str = dict["Other"] as! String
                            
                            self.array = str.components(separatedBy: ",")
                       
                        if self.array.count > 0 {
                            DispatchQueue.main.async(execute: { [weak self] () -> Void  in
                                guard let strongSelf = self else { return }
                                
                                strongSelf.contactCollView.reloadData()
                                })
                            
                        }
                        
                        
                    }
                    
                    
                }
            }
            
            
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    
    
}


extension EmergenvyContactVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:EmergencyContactCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EmergencyContactCell
        cell.backgroundColor = .white
        
        //var dic = self.array [indexPath.item]
        
       // if let str = self.array [indexPath.item] {
          
            cell.lblTitle.text = self.array [indexPath.item]
        
        //}
        
       
       
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 20
        let collectionCellSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionCellSize, height: 75)
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    

}
