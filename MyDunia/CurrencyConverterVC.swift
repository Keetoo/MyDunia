//
//  CurrencyConverterVC.swift
//  MyDunia
//
//  Created by Maahi on 12/07/17.
//  Copyright © 2017 TalentTrobe(India.com. All rights reserved.
//

import UIKit
import ReachabilitySwift


class CurrencyConverterVC: UIViewController {

    
    @IBOutlet weak var selectionPicker: UIPickerView!
    @IBOutlet weak var doneView: UIView!
    
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lblFromCurrencyCode: UILabel!
    @IBOutlet weak var lblFromCurrency: UILabel!
    
    @IBOutlet weak var lblToCurrencyCode: UILabel!
    @IBOutlet weak var lblTocurrency: UILabel!
    
    var activeFieldSts = 0
    
    var currencyList: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCurrencyList()
        
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
        
        print("CurrencyConverterVC deinit Called")
        
    }
    
    
    func getCurrencyList()  {
        
        activityIndicator.startAnimating()
        
        let reachability = Reachability()!
        if !reachability.isReachable {
            let alert = UIAlertController(title: "Alert!", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let paramString = ["lat":"28.6567","lng":"76.64675"] as [String : Any]
        let urlString = BaseUrl + MyDunia_GetCurrencyList
        MyDuniaConnectionHelper.GetDataFromJson(url: urlString, paramString:paramString ) { (responce, Status) in
            
            DispatchQueue.main.async(execute: { [weak self] () -> Void  in
                guard let strongSelf = self else { return }
                strongSelf.activityIndicator.stopAnimating()
                })
            
            
            
            if let resultResponce = responce.object(forKey: "response"){
            let responceDict = resultResponce as! NSDictionary
            if let statusVal = responceDict.object(forKey: "status") {
                
                if (statusVal as! NSNumber).intValue == 1 {//Success
                    
                    if  let resultDict = responceDict.object(forKey: "result") {
                     self.currencyList = [resultDict as! NSDictionary]
                        
                        
                    }
                    
                }
                
            }
            }
            
        }
    }
    
    
    @IBAction func ConvertCurrency(_ sender: Any) {
        
        activityIndicator.startAnimating()
        
       /* guard
            let userName = txtUserName.text, !userName.isEmpty,
            let password = txtPassword.text, !password.isEmpty
            else {
                //doneBarButton.isEnabled = false
                
                let alert = UIAlertController(title: "Alert!", message: "Please enter the login credential", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                
                return
        }*/

        let urlString = BaseUrl + MyDunia_GetConvertCurrency
        
        let paramString = ["lat":"28.5710132", "lng":"77.2363538", "from":"USD","to":"INR","amount":1] as [String : Any]
        MyDuniaConnectionHelper.GetDataFromJson(url: urlString, paramString: paramString) { (responce, status) in
            
            
            self.activityIndicator.stopAnimating()
            
            
            if let resultResponce = responce.object(forKey: "response"){
                
            let responceDict = resultResponce as! NSDictionary
            
            if let statusVal = responceDict.object(forKey: "status") {
                
                if (statusVal as! NSNumber).intValue == 1 {//Success
                    
                    if  let resultString = responceDict.object(forKey: "result") {
                       
                       self.lblResult.text = resultString as? String
                        
                        
                    }
                    
                }
                
            }

            
        }
        
            
        }
        
       
        
    }
    
    
    
    @IBAction func chooseCurrency(_ sender: AnyObject) {
        
        if sender.tag == 1 {
            
        }else if sender.tag == 2 {
            
            
        }
        
        
        selectionPicker.isHidden = false
        doneView .isHidden = false
        
    }
    
    
    
    
    
    @IBAction func pickerDoneClicked(_ sender: AnyObject) {
        
        selectionPicker.isHidden = true
        doneView .isHidden = true
        
    }
    
    
}


extension CurrencyConverterVC: UIPickerViewDelegate,UIPickerViewDataSource{
    
    /* func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
     
     
     let attributedString = NSAttributedString(string: "YOUR STRING", attributes: [NSForegroundColorAttributeName : UIColor.white])
     return attributedString
     }*/
    
    // DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
            return currencyList.count
            
        
    }
    
    // Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
            /*if currencyList.count > 0  {
                
                let str  = currencyList[row] as String
                let listArray = str.components(separatedBy: "=")
                
                if listArray.count > 1 {
                    return listArray[1]
                }else{
                    return "hi"
                }
            }else{
                return ""
            }*/
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
       /* if currencyList.count > 0  {
            
            let str  = currencyList[row] as NSDictionary
            let listArray = str.components(separatedBy: "=")
            
            if listArray.count > 1 {
                
                
                if activeFieldSts == 1 {
                    
                }else{
                    
                    
                }
                
            }
        }*/
        
    }
    
    
}
