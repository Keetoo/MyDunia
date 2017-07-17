//
//  LoginVC.swift
//  MyDunia
//
//  Created by Rajeev kumar singh on 7/11/17.
//  Copyright © 2017 TalentTrobe(India.com. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    var locationManager = LocationManager.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        txtUserName.delegate = self
        txtPassword.delegate = self
        
        locationManager.autoUpdate = false
        locationManager.startUpdatingLocationWithCompletionHandler { (lat, lang, Status, verboseMsg, error)  in
            self.latitude = lat
            self.longitude = lang
            
            print(lat,lat,Status,verboseMsg)
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

    
    @IBAction func userLogin(_ sender: Any) {
        
        activityIndicator.startAnimating()
        
        guard
            let userName = txtUserName.text, !userName.isEmpty,
            let password = txtPassword.text, !password.isEmpty
            else {
                //doneBarButton.isEnabled = false
                
                let alert = UIAlertController(title: "Alert!", message: "Please enter the login credential", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                
                return
        }
        //N for normal
        //G for goofle+
        let urlString = BaseUrl + MyDunia_SignIn
        
        let paramString = ["userid":userName,"password":password,"lat":self.latitude,"lng": self.longitude] as [String : Any]
        MyDuniaConnectionHelper.GetDataFromJson(url: urlString, paramString: paramString) { (responce, status) in
            
            
            //  guard let sts = responce.object(forKey: "Status") else { return  }
            
            if let statusVal = responce.object(forKey: "status") { // If casting, use, eg, if let var = abc as? NSString
                
                
                if (statusVal as! NSNumber).intValue == 1 {//Success
                    
                    let users = User.DictionaryVal(jsonObject: responce.object(forKey: "response") as! NSDictionary)
                    
                    let encodedData = NSKeyedArchiver.archivedData(withRootObject: users)
                    UserDefaults.standard.setValue(encodedData, forKey: MyDuniaUserDetails)
                    self.activityIndicator.stopAnimating()
                    
                    
                    
                    /*let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                    let ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "ContainerVC") as! ContainerVC
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = ViewController
                    */
                    
                    
                    self.performSegue(withIdentifier: "toHomeView", sender: self)
                }
                
            }
            
            
            
            }
        
        print("loginUser")
        
    }
    
    
   
    @IBAction func SkipLogin(_ sender: Any) {
        self.performSegue(withIdentifier: "toHomeView", sender: self)
    }
    
    
  
    @IBAction func ResetPassword(_ sender: Any) {
    }
    
    
    @IBAction func doRegistration(_ sender: Any) {
        
        
        
    }
    
}



extension LoginVC:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

   /* func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        textField.resignFirstResponder()
        return true
    }*/
}


