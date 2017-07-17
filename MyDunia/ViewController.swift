//
//  ViewController.swift
//  MyDunia
//
//  Created by Rajeev kumar singh on 7/11/17.
//  Copyright © 2017 TalentTrobe(India.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

     var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var controllerArray : [UIViewController] = []
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let controller1 : LoginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        controller1.title = "Login"
        controllerArray.append(controller1)
        
        let controller2 : RegistrationVC = storyboard.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationVC
        controller2.title = "Registration"
        controllerArray.append(controller2)
        
        
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)),
            .selectionIndicatorColor(UIColor.hexStringToUIColor(hex: MyDuniaMenuTextColor)),
            .addBottomMenuHairline(false),
            .menuItemFont(UIFont(name: "HelveticaNeue", size: 16.0)!),
            .menuHeight(40.0),
            .selectionIndicatorHeight(3.0),
            .useMenuLikeSegmentedControl(true),
            .menuItemWidthBasedOnTitleTextWidth(false),
            .selectedMenuItemLabelColor(UIColor.hexStringToUIColor(hex: MyDuniaMenuTextColor))
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 5.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        
        self.view.addSubview(pageMenu!.view)
        

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

