//
//  WeatherForecast.swift
//  MyDunia
//
//  Created by Maahi on 12/07/17.
//  Copyright © 2017 TalentTrobe(India.com. All rights reserved.
//

import UIKit
import ReachabilitySwift


private let reuseIdentifier = "WeatherCell"

class WeatherForecast: UIViewController {

    
    var weatherList : [Dictionary<String, Any>] = []
    @IBOutlet weak var weatherCollView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    var locationManager = LocationManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(self.view.frame.size.width)
        
        locationManager.autoUpdate = false
        locationManager.startUpdatingLocationWithCompletionHandler { (lat, lang, Status, verboseMsg, error)  in
            self.latitude = lat
            self.longitude = lang
            
            print(lat,lat,Status,verboseMsg)
        }

        
        CallWeatherForecast()
        // Do any additional setup after loading the view.
    }

    
    
    
    func CallWeatherForecast()  {
        
        //Call api
        let reachability = Reachability()!
        if !reachability.isReachable {
            let alert = UIAlertController(title: "Alert!", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        activityIndicator.startAnimating()
        let urlString = BaseUrl + MyDunia_GetweatherForcast
        let paramString = ["lat":"28.6567","lng":"76.64675","days":10] as [String : Any]
        MyDuniaConnectionHelper.GetDataFromJson(url: urlString, paramString: paramString) { (responce, status) in
            
            self.activityIndicator.stopAnimating()
            
            let responceDict = (responce.object(forKey: "response") as! NSDictionary)
            
            if let statusVal = responceDict.object(forKey: "status") {
                if (statusVal as! NSNumber).intValue == 1 {
                    
                    if  let resultDict = responceDict.object(forKey: "result") {
                        
                    let result = resultDict as! NSDictionary
                      if  let forecastDict = result.object(forKey: "forecast") {
                         let forecast = forecastDict as! NSDictionary
                        
                       if  let forecastdayArr = forecast.object(forKey: "forecastday")  {
                        
                        //print(forecastdayArr  as! [Dictionary<String, Any>])
                    self.weatherList = forecastdayArr  as! [Dictionary<String, Any>]
                   
                    DispatchQueue.main.async(execute: { [weak self] () -> Void  in
                        guard let strongSelf = self else { return }
                        strongSelf.activityIndicator.stopAnimating()
                        strongSelf.weatherCollView.reloadData()
                    })
                        
                        }
                        
                        
                        
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



extension WeatherForecast : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return weatherList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:WeatherCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! WeatherCell
          cell.backgroundColor = .yellow
        
        var dic = weatherList [indexPath.item]
        
        if let date = dic["date"] {
            cell.lblDate.text = date as? String
        }
        
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
        
        
        
       /* if let urlString = dic ["icon"] {
            
            
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
            
        }*/
        
        
        
        
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
