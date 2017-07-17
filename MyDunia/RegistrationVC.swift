//
//  RegistrationVC.swift
//  MyDunia
//
//  Created by Rajeev kumar singh on 7/11/17.
//  Copyright © 2017 TalentTrobe(India.com. All rights reserved.
//

import UIKit
import ReachabilitySwift

class RegistrationVC: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var registerScrollView: UIScrollView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtCity: UITextField!

    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtOccupation: UITextField!
    @IBOutlet weak var txtMaritalStatus: UITextField!
    @IBOutlet weak var lblmobCountryCode: UILabel!
    
    @IBOutlet weak var dobDatePicker: UIDatePicker!
    @IBOutlet weak var selectionPicker: UIPickerView!
    @IBOutlet weak var doneView: UIView!
    
    var keySize = CGSize(width: 20, height: 30)
    
    
    
    var activeField: UITextField?
    var countryList: [Dictionary<String, String>] = []
    
    var genderList = ["None","Male","Female","Other"]
    var occupationList = ["None","Student","Salaried","Self-Employed","Professional","Homemaker","Retired/Pensioner"]
    var maritalStsList = ["None","Single","Married"]
    
    var activeFieldSts = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCountryList()
        
        self.registerForKeyboardNotifications()
       
        
        let path = UIBezierPath(roundedRect:lblmobCountryCode.bounds, byRoundingCorners:[.topLeft, .bottomLeft],  cornerRadii: CGSize(width: 6, height:  6))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        lblmobCountryCode.layer.mask = maskLayer
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
    }

    func tap(gesture: UITapGestureRecognizer) {
        dismissKeyboard()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.registerScrollView.endEditing(true)
        
    }
    
    deinit {
        print("RegistrationVC")
        self.deregisterFromKeyboardNotifications()
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

    
    
    func getCountryList()  {
        
        let reachability = Reachability()!
        if !reachability.isReachable {
            let alert = UIAlertController(title: "Alert!", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        
        
        
        let urlString = BaseUrl + MyDunia_CountryList
        
        MyDuniaConnectionHelper.GetDataFromJson(url: urlString) { (responce, Status) in
            
           self.countryList = ((responce.object(forKey: "response"))  as! [Dictionary<String, String>])
            
        }
    }
    
    
    
    func ShowDatePicker()  {
        
        dismissKeyboard()
        //txtCity.resignFirstResponder()
        
        dobDatePicker.isHidden = false
        doneView.isHidden = false
        
        self.view.bringSubview(toFront: dobDatePicker)
        self.view.bringSubview(toFront: doneView)
        
        
        
//        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keySize.height, 0.0)
//        self.registerScrollView.contentInset = contentInsets
//        self.registerScrollView.scrollIndicatorInsets = contentInsets

    }
    
    func ShowSelectionPicker(_ status : Int )  {
        
        activeFieldSts = status
        
        dismissKeyboard()
        selectionPicker.isHidden = false
        doneView.isHidden = false
        
        selectionPicker.reloadAllComponents()
        
        self.view.bringSubview(toFront: selectionPicker)
        self.view.bringSubview(toFront: doneView)
    }

    
    
    
    
    
    @IBAction func Submit(_ sender: Any) {
        
        activityIndicator.startAnimating()
        
        
        guard
            let firstName = txtFirstName.text, !firstName.isEmpty,
            let lastName = txtLastName.text, !lastName.isEmpty,
            let country = txtCountry.text, !country.isEmpty,
            let mobileNo = txtMobile.text, !mobileNo.isEmpty,
            let emaiId = txtEmail.text, !emaiId.isEmpty,
            let password = txtPassword.text, !password.isEmpty,
            let confirmPassword = txtConfirmPassword.text, !confirmPassword.isEmpty,
            let dob = txtDOB.text, !dob.isEmpty,
            let cityName = txtDOB.text, !cityName.isEmpty,
            let occupation = txtOccupation.text, !occupation.isEmpty,
            let gender = txtGender.text, !gender.isEmpty,
            let maritalSts = txtMaritalStatus.text, !maritalSts.isEmpty
        
            else {
                //doneBarButton.isEnabled = false
                DispatchQueue.main.async(execute: { [weak self] () -> Void  in
                    guard let strongSelf = self else { return }
                    strongSelf.activityIndicator.stopAnimating()
                    
                    })
                
                let alert = UIAlertController(title: "Alert!", message: "Please Fill all mendatory fields", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                
                return
        }

        if password != confirmPassword {
            
            let alert = UIAlertController(title: "Alert!", message: "Password missmatch", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
        //Call api
        let reachability = Reachability()!
        if !reachability.isReachable {
            let alert = UIAlertController(title: "Alert!", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        
        let urlString = BaseUrl + MyDunia_SignUp
        
        let paramString = ["userid":firstName,"firstName":firstName,"last_name":lastName,"gender":gender,"marital_status":maritalSts,"occupation":occupation,"phoneno":mobileNo,"password":password,"passconf":confirmPassword,"dob":dob,"country_id":country,"city":cityName,"email":emaiId,"termsandcondition":"","lat":28.65765,"lng": 76.5754] as [String : Any]
        MyDuniaConnectionHelper.GetDataFromJson(url: urlString, paramString: paramString) { (responce, status) in
            
            if let statusVal = responce.object(forKey: "status") { // If casting, use, eg, if let var = abc as? NSString
                    
                    
                    if (statusVal as! NSNumber).intValue == 1 {//Success
                        
                        let users = User.DictionaryVal(jsonObject: responce.object(forKey: "response") as! NSDictionary)
                        
                        let encodedData = NSKeyedArchiver.archivedData(withRootObject: users)
                        UserDefaults.standard.setValue(encodedData, forKey: MyDuniaUserDetails)
                        
                        
                        DispatchQueue.main.async(execute: { [weak self] () -> Void  in
                            guard let strongSelf = self else { return }
                                strongSelf.activityIndicator.stopAnimating()
                            
                            })
                        
                //next Screen
                   self.performSegue(withIdentifier: "toAOI", sender: self)
                    }
                    
                }
            
        }
            
        
        
    }
    
    
    
    
    @IBAction func hidePicker(_ sender: Any) {
        
        dobDatePicker.isHidden = true
        selectionPicker.isHidden = true
        doneView .isHidden = true
        
        if activeField == txtCountry{
            txtMobile.becomeFirstResponder()
        }/*if activeField == txtDOB{
            txtMobile.becomeFirstResponder()
        }*/
        
        
    }
    
    
    
    @IBAction func SkipsTheSteps(_ sender: Any) {
        
        
        self.performSegue(withIdentifier: "toHomeView", sender: self)
    }
    
    
    //Date Picker method change
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
       let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        txtDOB.text = dateFormatter.string(from: sender.date)
    }
    
    
    //*****
    
    
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.registerScrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        keySize = keyboardSize!
        
        self.registerScrollView.contentInset = contentInsets
        self.registerScrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.registerScrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0, 0.0)
        self.registerScrollView.contentInset = contentInsets
        self.registerScrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
       
        //self.registerScrollView.isScrollEnabled = false
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
        self.registerScrollView.endEditing(true)
         self.registerScrollView.isScrollEnabled = true
    }
    
}


extension RegistrationVC:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
       /* if textField.returnKeyType == .next {
            
            if textField == txtFirstName {
                txtLastName.becomeFirstResponder()
            }else if textField == txtLastName {
            //country called
                textField.resignFirstResponder()
                ShowSelectionPicker( 1)
            }else if textField == txtMobile {
                txtEmail.becomeFirstResponder()
            }else if textField == txtEmail {
                txtPassword.becomeFirstResponder()
            }else if textField == txtPassword {
                txtConfirmPassword.becomeFirstResponder()
            }else if textField == txtConfirmPassword {
                txtCity.becomeFirstResponder()
            }else if textField == txtCity {
                txtDOB.resignFirstResponder()
                //Open date picker
                ShowDatePicker()
                
            }else if textField == txtConfirmPassword {
                txtCity.becomeFirstResponder()
            }



            
            
            
            
        }else if textField.returnKeyType == .go{
            
            //self.Submit(any)
        }*/
        
        
        
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        activeFieldSts = 0
        
        self.hidePicker(UIButton())//downl All picker if any one shows
        activeField = textField
        
       /* if textField == txtCountry {
           // textField.resignFirstResponder()
            //ShowSelectionPicker( 1)
        }else */if textField == txtDOB {
            textField.resignFirstResponder()
            ShowDatePicker()
        }else if textField == txtGender {
            textField.resignFirstResponder()
            ShowSelectionPicker( 2)
        }
        else if textField == txtOccupation {
            textField.resignFirstResponder()
           ShowSelectionPicker(3)
        }
        else if textField == txtMaritalStatus {
            textField.resignFirstResponder()
            ShowSelectionPicker( 4)
        }
        
        
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField != txtDOB ||  textField != txtCountry ||  textField != txtGender ||  textField != txtOccupation || textField != txtMaritalStatus{
        activeField = nil
        }
    }
    
    
    
    
    
    

}


extension RegistrationVC: UIPickerViewDelegate,UIPickerViewDataSource{
    
   /* func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        
        let attributedString = NSAttributedString(string: "YOUR STRING", attributes: [NSForegroundColorAttributeName : UIColor.white])
        return attributedString
    }*/
    
    // DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if activeFieldSts == 1 {
            return countryList.count
            
        }else if activeFieldSts == 2{
            return genderList.count
        }else if activeFieldSts == 3{
            return occupationList.count
        }else if activeFieldSts == 4{
            return maritalStsList.count
        }else{
            return 0
        }
        
    }
    
    // Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if activeFieldSts == 1 {
            
            if countryList.count > 0  {
                
                let dic  = countryList[row] as NSDictionary
                return dic.value(forKey: "country_name") as! String?
            }else{
                return ""
            }
                
            
            
            
        }else if activeFieldSts == 2{
            
            return genderList[row]
        }else if activeFieldSts == 3{
            
            return occupationList[row]
        }else if activeFieldSts == 4{
            
            return maritalStsList[row]
        }else{
            return "hi"
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if activeFieldSts == 1 {
            let dic  = countryList[row] as NSDictionary
            txtCountry.text = dic.value(forKey: "country_name") as! String?
            lblmobCountryCode.text =  dic.value(forKey: "isd_code") as! String?
            
        }else if activeFieldSts == 2{
            
            txtGender.text = genderList[row]
        }else if activeFieldSts == 3{
            
            txtOccupation.text = occupationList[row]
        }else if activeFieldSts == 4{
            
            txtMaritalStatus.text = maritalStsList[row]
        }

        
    }
    
    
    
    
}
