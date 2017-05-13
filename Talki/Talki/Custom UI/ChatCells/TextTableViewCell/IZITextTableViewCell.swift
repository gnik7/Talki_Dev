//
//  IZImageTableViewCell.swift
//  Talki
//
//  Created by Nikita Gil on 8/23/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

class IZITextTableViewCell: IZChatTypeBaseCell {

    
    @IBOutlet weak var timeLabel                : UILabel!
    @IBOutlet weak var messageLabel             : UILabel!
    
    @IBOutlet weak var rightViewConstarint: NSLayoutConstraint!
    @IBOutlet weak var leftViewConstraint: NSLayoutConstraint!
    
    
    
    var currentItem         : IZSingleChatMessageItemModel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func updateData(_ item : IZSingleChatMessageItemModel?, profileImage : UIImage?, type :IZChatCellType){
        super.updateData(item, profileImage: profileImage, type: type)
        
        guard let currentItem = item as IZSingleChatMessageItemModel? else {
            return
        }
        
        self.currentItem = currentItem

        if let timeMessage = currentItem.time as String? {
            let date = IZHelper.convertTimeFromString(timeMessage)
            let time = IZHelper.convertTimeHourMinitToString(date)
            self.timeLabel.text = time
        }
        
        if let message = currentItem.text as String? {
            if !message.isEmpty {
                self.messageLabel.text = message
                self.messageLabel.frame.size.height = self.messageLabel.requiredHeight()
                self.heightCell = self.messageLabel.requiredHeight() + 25
            }
        }
        
        self.profileRightImage.layoutIfNeeded()
        self.profileLeftImage.layoutIfNeeded()
        
        if type == IZChatCellType.izChatCellOwner {
            self.rightViewConstarint.constant = self.contentView.frame.size.width * self.opponentConstant
            self.leftViewConstraint.constant = self.contentView.frame.size.width * self.ownerConstant
        } else if type == IZChatCellType.izChatCellOpponent {
            self.leftViewConstraint.constant = self.contentView.frame.size.width * self.opponentConstant
            self.rightViewConstarint.constant = self.contentView.frame.size.width * self.ownerConstant
        }
    }
}
