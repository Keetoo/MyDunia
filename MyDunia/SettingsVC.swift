//
//  SettingsVC.swift
//  MyDunia
//
//  Created by Maahi on 12/07/17.
//  Copyright © 2017 TalentTrobe(India.com. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    
    var settingsArray = ["$ 100","$ 200","$ 800","$ 1000"]
    @IBOutlet weak var settingsTblView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingsTblView.tableFooterView = UIView()
        settingsTblView.tableHeaderView = nil
        
        
        
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
        
        print("SettingsVC deinit Called")
        
    }

    
}

extension SettingsVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath )
        cell.textLabel?.text = settingsArray[indexPath.section]
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 2
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
    
    
}
