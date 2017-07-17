//
//  SearchResults.swift
//  MyDunia
//
//  Created by Maahi on 16/07/17.
//  Copyright © 2017 TalentTrobe(India.com. All rights reserved.
//

import UIKit

class SearchResults: UIViewController {

    
    
    @IBOutlet weak var advanceSearch: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchResultTblView: UITableView!
    
    let resultArray = ["$ 100","$ 200","$ 800","$ 1000"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

extension SearchResults : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath )
        cell.textLabel?.text = resultArray[indexPath.row]
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
    
    
}


extension SearchResults:UISearchBarDelegate{
    
    
    
    
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
