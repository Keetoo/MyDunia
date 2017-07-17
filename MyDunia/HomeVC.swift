//
//  HomeVC.swift
//  MyDunia
//
//  Created by Rajeev kumar singh on 7/11/17.
//  Copyright © 2017 TalentTrobe(India.com. All rights reserved.
//

import UIKit
import ReachabilitySwift

private let reuseIdentifierAvail = "AvailCountryCollCell"

class HomeVC: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var todayimageView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categoryCollView: UICollectionView!
    @IBOutlet weak var availabeINCollView: UICollectionView!
    
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    var locationManager = LocationManager.sharedInstance
    
    
    var categoryList : [Dictionary<String, Any>] = []
    var availableInList : [Dictionary<String, Any>] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        //getCountryAvailable()
       // getCategories()
        
        
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
    
    deinit {
        
        print("HomeVC deinit Called")
        
    }

    
    
    
    func getCategories()  {
        
        //Call api
        let reachability = Reachability()!
        if !reachability.isReachable {
            let alert = UIAlertController(title: "Alert!", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        
        activityIndicator.startAnimating()
        
        let urlString = BaseUrl + MyDunia_GetCategory
        
        let paramString = ["lat":"28.6567","lng":"76.64675"] as [String : Any]
        MyDuniaConnectionHelper.GetDataFromJson(url: urlString, paramString: paramString) { (responce, status) in
            
            self.activityIndicator.stopAnimating()
            
            let responceDict = (responce.object(forKey: "response") as! NSDictionary)
            
            if let statusVal = responceDict.object(forKey: "status") {
                if (statusVal as! NSNumber).intValue == 1 {
                    
                    /*if  let resultDict = responceDict.object(forKey: "result") {
                        
                        let result = resultDict as! NSDictionary
                        if  let forecastDict = result.object(forKey: "forecast") {
                            let forecast = forecastDict as! NSDictionary
                            
                            if  let forecastdayArr = forecast.object(forKey: "forecastday")  {
                                
                                //print(forecastdayArr  as! [Dictionary<String, Any>])
                                self.categoryList = forecastdayArr  as! [Dictionary<String, Any>]
                                
                                DispatchQueue.main.async(execute: { [weak self] () -> Void  in
                                    guard let strongSelf = self else { return }
                                    strongSelf.activityIndicator.stopAnimating()
                                    strongSelf.categoryCollView.reloadData()
                                    })
                                
                            }
                            
                            
                            
                        }
                    }*/
                }
            }
        }
        
        
        
        
    }
    

    func getCountryAvailable() {
        
        //Call api
        let reachability = Reachability()!
        if !reachability.isReachable {
            let alert = UIAlertController(title: "Alert!", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        activityIndicator.startAnimating()
        let urlString = BaseUrl + MyDunia_WeAreAvailable
        //let paramString = ["lat":"28.6567","lng":"76.64675","days":10] as [String : Any]
        MyDuniaConnectionHelper.GetDataFromJson(url: urlString) { (responce, status) in
            
            self.activityIndicator.stopAnimating()
            print(responce)
            self.availabeINCollView.reloadData()
        }
        
    }
    
    
   /* @IBAction func toggleMenu(_ sender: Any) {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "toggleMenu"), object: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "closeMenuViaNotification"), object: nil)
        view.endEditing(true)
    }*/
    
   

}

extension HomeVC:UISearchBarDelegate{
    
    
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       // shouldShowSearchResults = true
       // tblSearchResults.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       // shouldShowSearchResults = false
       // tblSearchResults.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
        {
        /*if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tblSearchResults.reloadData()
        }*/
        
        searchBar.resignFirstResponder()
    }
    
}

extension HomeVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return availableInList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:AvailCountryCollCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierAvail, for: indexPath) as! AvailCountryCollCell
        cell.backgroundColor = .yellow
        
        var dic = availableInList [indexPath.item]
        
       
        /*
        if let day = dic["day"] {
            
            let dayDict = day as! NSDictionary
            if let condition = dayDict["condition"]  {
                let conditionDict = condition as! NSDictionary
                if let wetherType = conditionDict["text"] {
                    cell.lblWeather.text = wetherType as? String
                }
                
                
                if let iconUrl = conditionDict["icon"] {
                    let iconStr = iconUrl as! String
                    let  url = "https:\(iconStr)"
                    
                    
                    URLSession.shared.dataTask(with: NSURL(string: url)! as URL, completionHandler: { (data, response, error) -> Void in
                        
                        if error != nil {
                            print(error)
                            return
                        }
                        DispatchQueue.main.async(execute: { () -> Void in
                            let image = UIImage(data: data!)
                            cell.weatherIconImage.image = image
                        })
                        
                    }).resume()
                    
                    
                }
                
                
                
            }
            
            if let avgTemprature = dayDict["avgtemp_c"] {
                cell.lblTemprature.text = "\(avgTemprature)"
            }
            
            
            
            
            
            
        }
        */
        
        
        return cell
    }
    
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 20
        let collectionCellSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionCellSize/3, height: 75)
    }*/
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    
}
