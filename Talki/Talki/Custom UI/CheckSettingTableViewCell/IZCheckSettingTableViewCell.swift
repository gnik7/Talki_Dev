//
//  IZCheckSettingTableViewCell.swift
//  Talki
//
//  Created by Nikita Gil on 11.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit


class IZCheckSettingTableViewCell: IZGenericCell {
    
    @IBOutlet weak var titleLabel       : UILabel!
    @IBOutlet weak var checkImageView   : UIImageView!
    @IBOutlet weak var checkButton      : UIButton!
    
    var type                : SettingsTypeCell?
    var state               : Bool = false
    var notificationType    : NotificationType?
    
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
        
        self.type = item.typeCell
        self.notificationType = item.notificationType
        
        if let title = item.title as String? {
            self.titleLabel.text = title
        }
        if let checked = item.checkboxSelected as Bool? {
            self.checkedState(checked)
        } else {
            self.checkImageView.isHidden = true
        }
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func checkboxButtonPressed(_ sender: UIButton) {

        self.checkedState(!self.state)
        
        if let delegate = self.delegate as IZGenericCellDelegate? {
            delegate.checkedCellWithType(self.type!, state: self.state, notificationType: self.notificationType!)
        }
    }
    
    fileprivate func checkedState(_ state : Bool) {
        self.state = state
        if state {
            self.checkImageView.image = UIImage(named: "checked_settings")
        } else {
            self.checkImageView.image = UIImage(named: "canceled_settings")
        }
    }
    
}

