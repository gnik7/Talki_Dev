//
//  IZGenericCell.swift
//  Talki
//
//  Created by Nikita Gil on 11.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

protocol IZGenericCellDelegate : NSObjectProtocol {
    
    func selectedDistance(_ value : Int)
    func typeGenderButtonWasPressed()
    func selectedAge(_ minAge : Int, maxAge : Int)
    func checkedCellWithType(_ typeCell : SettingsTypeCell, state : Bool, notificationType : NotificationType)
    func logoutButtonWasPressed()
    func deleteAccountButtonWasPressed()
}


class IZGenericCell: UITableViewCell {
    
    weak var delegate : IZGenericCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateData(_ item :IZSettingsCellModel){
        
    }
}
