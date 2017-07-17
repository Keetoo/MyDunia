//
//  AreaOfIntrestVC.swift
//  MyDunia
//
//  Created by Rajeev kumar singh on 7/11/17.
//  Copyright © 2017 TalentTrobe(India.com. All rights reserved.
//

import UIKit


private let reuseIdentifier = "AIOCell"

class AreaOfIntrestVC: UIViewController {

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var AIOCollView: UICollectionView!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var selectionIdsArray : [String] = []
    
    
    
    var AIOList : [Dictionary<String, String>] = []
    var iconBaseUrl = ""
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    var locationManager = LocationManager.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        
        
        locationManager.autoUpdate = false
        locationManager.startUpdatingLocationWithCompletionHandler { (lat, lang, Status, verboseMsg, error)  in
            self.latitude = lat
            self.longitude = lang
            
            print(lat,lat,Status,verboseMsg)
        }
        
        getAreaOfInterest()
    }

    
    
    func getAreaOfInterest (){
        
        activityIndicator.startAnimating()
        
            let urlString = BaseUrl + MyDunia_ServiceList
            let paramString = ["lat":"28.5465","lng":"76.435345"] as [String : Any]
            MyDuniaConnectionHelper.GetDataFromJson(url: urlString, paramString: paramString) { (responce, status)  in
                
               
                
                let responceDict = (responce.object(forKey: "response") as! NSDictionary)
                
                if let statusVal = responceDict.object(forKey: "status") {
                    if (statusVal as! NSNumber).intValue == 1 {
                       
                        
                        
                        self.AIOList = (responceDict.object(forKey: "result")  as! [Dictionary<String, String>])
                        self.iconBaseUrl = responceDict.object(forKey: "iconbaseurl") as! String
                        
                        DispatchQueue.main.async(execute: { [weak self] () -> Void  in
                            guard let strongSelf = self else { return }
                             strongSelf.activityIndicator.stopAnimating()
                             strongSelf.AIOCollView.reloadData()
                            })
                       
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
    
    
    
    
    
    @IBAction func SkipSteps(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toMembership", sender: self)
    }
    
    
    @IBAction func SubmitData(_ sender: Any) {
        btnSkip.isEnabled = false
        activityIndicator.startAnimating()
        
        if selectionIdsArray.count == 0 {
            
            let alert = UIAlertController(title: "Alert!", message: "Please select at lease one are of Interest or skip this step", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
            
        
        var authToken = ""
        if let data = UserDefaults.standard.data(forKey: MyDuniaUserDetails),
            let myUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
            authToken = myUser.auth_id!
            
        } else {
            print("There is an issue")
        }
        
        let selectionStr = selectionIdsArray.joined(separator: ",")
        let urlString = BaseUrl + MyDunia_PostAreaOfIntrest
        let paramString = ["lat":"28.5465", "lng":"76.435345", "auth_id":authToken, "sid":selectionStr] as [String : Any]
       
        MyDuniaConnectionHelper.GetDataFromJson(url: urlString, paramString: paramString) { (responce, status)  in
            
            self.activityIndicator.stopAnimating()
            let responceDict = (responce.object(forKey: "response") as! NSDictionary)
            
            if let statusVal = responceDict.object(forKey: "status") {
                if (statusVal as! NSNumber).intValue == 1 {
                    
                //    Save are of interest & Jump to next screen
                    
                    self.performSegue(withIdentifier: "toMembership", sender: self)
                    
                }else{
                    
                    let alert = UIAlertController(title: "Alert!", message: "There is some proble try again", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
 
                    
                }
            }
        }
        
        
        
    }

}


extension AreaOfIntrestVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return AIOList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:AIOCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AIOCell
        cell.backgroundColor = .white
        
       var dic = AIOList [indexPath.item]
        if let urlString = dic ["icon"] {
            let url = iconBaseUrl + urlString
            URLSession.shared.dataTask(with: NSURL(string: url)! as URL, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    print(error)
                    return
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    let image = UIImage(data: data!)
                    cell.imageView.image = image
                })
                
            }).resume()
            
        }
        
        cell.lblTitle.text = dic["name"]
        
        
        return cell
    }
    
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
    let padding: CGFloat = 20
    let collectionCellSize = collectionView.frame.size.width - padding
    return CGSize(width: collectionCellSize, height: 90)
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
            
        let cell :AIOCell = collectionView.cellForItem(at: indexPath)! as! AIOCell
        
        let dic = AIOList [indexPath.item]
        if let sid = dic["sid"] {
             let id = sid
           
            if selectionIdsArray.contains(id){
                if let index = selectionIdsArray.index(of:id) {
                    selectionIdsArray.remove(at: index)
                    cell.btnSelection.setImage(UIImage(named: "CheckBoxUnChecked")! as UIImage, for: .normal)
                }
                
            }else{
                selectionIdsArray.append(id)
                cell.btnSelection.setImage(UIImage(named: "CheckBoxChecked")! as UIImage, for: .normal)
            }
            
            
            
            
        }
        
    }
    
    
    
    
}
