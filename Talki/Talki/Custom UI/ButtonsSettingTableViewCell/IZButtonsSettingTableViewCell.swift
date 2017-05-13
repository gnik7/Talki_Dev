//
//  IZButtonsSettingTableViewCell.swift
//  Talki
//
//  Created by Nikita Gil on 11.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//


import UIKit

class IZButtonsSettingTableViewCell: IZGenericCell {
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!

    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.updateUI()
    }
    
    fileprivate func updateUI(){
        
        self.logoutButton.layer.cornerRadius = self.logoutButton.frame.height / 2
        self.logoutButton.clipsToBounds = true
        
        self.deleteAccountButton.layer.cornerRadius = self.deleteAccountButton.frame.height / 2
        self.deleteAccountButton.clipsToBounds = true
        self.deleteAccountButton.layer.borderWidth = 1.0
        self.deleteAccountButton.layer.borderColor = UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1.0).cgColor
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    //*****************************************************************
    // MARK: - updateData
    //*****************************************************************
    
    override func updateData(_ item :IZSettingsCellModel){
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        if let delegate = self.delegate as IZGenericCellDelegate? {
            delegate.logoutButtonWasPressed()
        }
    }
    
    @IBAction func deleteAccountButtonPressed(_ sender: UIButton) {
        if let delegate = self.delegate as IZGenericCellDelegate? {
            delegate.deleteAccountButtonWasPressed()
        }
    }

}

