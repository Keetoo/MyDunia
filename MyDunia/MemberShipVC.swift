//
//  MemberShipVC.swift
//  MyDunia
//
//  Created by Rajeev kumar singh on 7/12/17.
//  Copyright © 2017 TalentTrobe(India.com. All rights reserved.
//

import UIKit

class MemberShipVC: UIViewController {

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var membershipTblView: UITableView!
    
    let membershipArray = ["$ 100","$ 200","$ 800","$ 1000"]
    
    @IBOutlet weak var btnMemberShip: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var selectPlan :String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        membershipTblView.tableFooterView = UIView()
        membershipTblView.tableHeaderView = nil
        
        
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
    
    
    
    func loadMembership()  {
        activityIndicator.startAnimating()
        
        
        let urlString = BaseUrl + MyDunia_ServiceList
        let paramString = ["lat":"28.5465","lng":"76.435345"] as [String : Any]
        MyDuniaConnectionHelper.GetDataFromJson(url: urlString, paramString: paramString) { (responce, status)  in
            
            
            
        }
        
    }
    
    
    
    
    
    @IBAction func SkipSteps(_ sender: Any) {
        
        activityIndicator.stopAnimating()
        
        self.performSegue(withIdentifier: "toHomeView", sender: self)    }

    
    
    @IBAction func submitMembership(_ sender: Any) {
        
        if selectPlan.characters.count == 0 {
            
            let alert = UIAlertController(title: "Alert!", message: "Please select a Plan or Skip this step", preferredStyle: UIAlertControllerStyle.alert)
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
        
        
        let urlString = BaseUrl + MyDunia_PostAreaOfIntrest
        let paramString = ["lat":"28.5465", "lng":"76.435345", "auth_id":authToken, "sid":selectPlan] as [String : Any]
        
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


extension MemberShipVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath )
        cell.textLabel?.text = membershipArray[indexPath.section]
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int{
         return membershipArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
    
    
}
