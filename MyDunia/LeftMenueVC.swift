//
//  LeftMenueVC.swift
//  MyDunia
//
//  Created by Rajeev kumar singh on 7/11/17.
//  Copyright © 2017 TalentTrobe(India.com. All rights reserved.
//

import UIKit
import MessageUI


class LeftMenueVC: UIViewController {

    
   public var previousIndex: NSIndexPath?
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblEmailID: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var leftMenuTableView: UITableView!
    
    var leftItemArray = ["Home","Weather Forecast","Currecy Converter","Emergency Contact","Language Translator"]
    
    var leftItemArray2 = ["Share","Send mail","Settings","Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // retrieving a value for a key
        if let data = UserDefaults.standard.data(forKey: MyDuniaUserDetails),
            let myUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
            
            lblUserName.text = myUser.username
            
        } else {
            print("There is an issue")
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
    
    
    
    
    
    func SendMail()  {
        
        if MFMailComposeViewController.canSendMail() {
            
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            // Configure the fields of the interface.
            composeVC.setToRecipients(["address@example.com"])
            composeVC.setSubject("Hello!")
            composeVC.setMessageBody("Hello from California!", isHTML: false)
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
            
        }else{
            
            let alert = UIAlertController(title: "Alert!", message: "Please configure mail", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            print("Mail services are not available")
            return
            
        }
    }
    
    
    

}


extension LeftMenueVC: UITableViewDelegate,UITableViewDataSource{
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1.0
        }else{
        return 2.0
        }
    }


    func numberOfSections(in tableView: UITableView) -> Int {
         return 2
    }
        
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return leftItemArray.count
        }else{
            return leftItemArray2.count
        }
        
        
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if indexPath.section == 0{
            cell.textLabel?.text = leftItemArray[indexPath.row]
        }else{
             cell.textLabel?.text = leftItemArray2[indexPath.row]
        }
        return cell
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
       /* if let index = previousIndex {
            leftMenuTableView.deselectRow(at: index as IndexPath, animated: true)
        }
        
        
        previousIndex = indexPath as NSIndexPath?
        */
        
        
        if indexPath.section == 1{
            
            switch indexPath.row {
            case 0:
                self.sharepopup("Hellow.....")
                print("openModalWindow")
            case 1:
                SendMail()
                print("openPushWindow")
            case 2:
                sideMenuController?.performSegue(withIdentifier: "showSetting", sender: nil)
            case 3:
                self.app_logout()
                print("Logout")
            default:
                print("indexPath.row:: \(indexPath.row)")
            }

            
            
            
        }else{
            
            
            switch indexPath.row {
            case 0:
                sideMenuController?.performSegue(withIdentifier: "showHome", sender: nil)
                print("openModalWindow")
            case 1:
                sideMenuController?.performSegue(withIdentifier: "showWeather", sender: nil)
                print("openModalWindow")
            case 2:
                sideMenuController?.performSegue(withIdentifier: "showCurrencyConvert", sender: nil)
                print("openPushWindow")
            case 3:
                sideMenuController?.performSegue(withIdentifier: "showEmergencyContact", sender: nil)
            case 4:
                sideMenuController?.performSegue(withIdentifier: "showLanguageChange", sender: nil)
                print("openPushWindow")
            default:
                print("indexPath.row:: \(indexPath.row)")
            }

            
        }
        
        
    }
    
    //http://www.codingexplorer.com/sharing-swift-app-uiactivityviewcontroller/
    func sharepopup(_ title:String)  {
        
        let textToShare = "Swift is awesome!  Check out this website about it!"
        
        if let myWebsite = NSURL(string: "http://www.codingexplorer.com/") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
           // activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    
    }
    
    
    
    
    
    
    //Logout MyDunia
    func app_logout()  {
        UserDefaults.standard.removeObject(forKey: MyDuniaUserDetails)
        
        // Remove data from singleton (where all my app data is stored)
        //[AppData clearData];
        
        // Reset view controller (this will quickly clear all the views)
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.window?.rootViewController = ViewController
        
        let navController = UINavigationController(rootViewController: ViewController)
        ViewController.navigationItem.title = "Login"
        navController.navigationBar.tintColor = UIColor.hexStringToUIColor(hex: "#00A5D7")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = navController
    }
    
}

extension LeftMenueVC:MFMailComposeViewControllerDelegate{
    
    func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}



