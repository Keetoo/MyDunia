//
//  CheckBoxButton.swift
//  MyDunia
//
//  Created by Rajeev kumar singh on 7/14/17.
//  Copyright © 2017 TalentTrobe(India.com. All rights reserved.
//

import UIKit

class CheckBoxButton: UIButton {

    
    // Images
    let checkedImage = UIImage(named: "CheckBoxChecked")! as UIImage
    let uncheckedImage = UIImage(named: "CheckBoxUnChecked")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
      //  self.addTarget(self, action: #selector(CheckBoxButton.buttonClicked(_:)), for: UIControlEvents.TouchUpInside)
        self.isChecked = false
    }
    
    func buttonClicked(sender: UIButton) {
        if sender == self {
            if isChecked == true {
                isChecked = false
            } else {
                isChecked = true
            }
        }
    }
    
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
