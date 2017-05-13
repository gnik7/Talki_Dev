//
//  IZGenderSettingTableViewCell.swift
//  Talki
//
//  Created by Nikita Gil on 11.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

class IZGenderSettingTableViewCell: IZGenericCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genderTypeLabel: UILabel!
    
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
    
    override func updateData(_ item :IZSettingsCellModel){
        
        if let title = item.title as String? {
           self.titleLabel.text = title
        }
        if let typeGender = item.genderType as String? {
            self.genderTypeLabel.text = typeGender
        } else {
            self.genderTypeLabel.text = ""
        }
        
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func typeGenderButtonPressed(_ sender: UIButton) {
        if let delegate = self.delegate as IZGenericCellDelegate? {
            delegate.typeGenderButtonWasPressed()
        }
    }
    

}
