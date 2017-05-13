//
//  IZCheckSettingTableViewCell.swift
//  Talki
//
//  Created by Nikita Gil on 11.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

protocol IZGenderChooseDelegate : NSObjectProtocol {
    func genderWasChoose(_ type :String?)
}

protocol IZGenderChooseToParentDelegate : NSObjectProtocol {
    func genderWasChoose(_ type :String?)
}

class IZGenderChooseSettingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel       : UILabel!
    @IBOutlet weak var checkImageView   : UIImageView!

    
    var state           : Bool?
    weak var delegate   : IZGenderChooseDelegate?
    weak var delegateParent   : IZGenderChooseToParentDelegate?
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    //*****************************************************************
    // MARK: - updateData
    //*****************************************************************
    
    func updateData(_ currentSetting : String? , setting : String){
  
        self.titleLabel.text = setting
        
        var current = ""
        if let title = currentSetting as String? {
            current = title
        }
        
        if setting == current {
            self.state = true
            self.checkImageView.image = UIImage(named: "checked_settings")
        } else {
            self.state = false
            self.checkImageView.image = UIImage(named: "unchecked_settings")
        }
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func checkboxButtonPressed(_ sender: UIButton) {

        self.state = !self.state!
        
        if self.state! {
            self.checkImageView.image = UIImage(named: "checked_settings")
        } else {
            self.checkImageView.image = UIImage(named: "unchecked_settings")
        }
        
        if let delegate = self.delegate as IZGenderChooseDelegate? {
            delegate.genderWasChoose(self.titleLabel.text)
        }
        
        if let delegate = self.delegateParent as IZGenderChooseToParentDelegate? {
            delegate.genderWasChoose(self.titleLabel.text)
        }
    }
    
}

