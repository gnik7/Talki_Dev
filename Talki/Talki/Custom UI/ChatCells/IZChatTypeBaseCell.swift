//
//  IZChatBaseCell.swift
//  Talki
//
//  Created by Nikita Gil on 8/15/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

enum IZChatCellType {
    
    case izChatCellImage
    case izChatCellLocation
    case izChatCellText
    
    case izChatCellOwner
    case izChatCellOpponent
}

class IZChatTypeBaseCell: UITableViewCell {
    
    @IBOutlet weak var chatView             : UIView!
    @IBOutlet weak var profileLeftImage     : UIImageView!
    @IBOutlet weak var profileRightImage    : UIImageView!
    @IBOutlet weak var rightTailImageView   : UIImageView!
    @IBOutlet weak var leftTailImageView    : UIImageView!
    
    var heightCell     : CGFloat = 0.0
    let kRadius        : CGFloat = 15.0
    let ownerColor : UIColor = UIColor(red: 0/255.0, green: 178/255.0, blue: 191/255.0, alpha: 1.0)
    let recipientColor : UIColor = UIColor(red: 234/255.0, green: 101/255.0, blue: 88/255.0, alpha: 1.0)
    let opponentConstant : CGFloat = 0.07
    let ownerConstant : CGFloat = 0.03
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        self.profileLeftImage.setNeedsDisplay()
        self.profileLeftImage.layoutIfNeeded()
        self.chatView.setNeedsDisplay()
        self.chatView.layoutIfNeeded()
        self.profileRightImage.setNeedsDisplay()
        self.profileRightImage.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    func setupUI() {
       
        self.chatView.layer.cornerRadius = kRadius
        self.chatView.clipsToBounds = true
        
        self.profileLeftImage.layer.cornerRadius = self.profileLeftImage.bounds.width / 2
        self.profileLeftImage.clipsToBounds = true
        self.profileRightImage.layer.cornerRadius = self.profileRightImage.bounds.width / 2
        self.profileRightImage.clipsToBounds = true
    }
    
    func updateData(_ item : IZSingleChatMessageItemModel?, profileImage : UIImage?, type :IZChatCellType){
        
        if let image = profileImage as UIImage? {
            if type == IZChatCellType.izChatCellOwner {
                DispatchQueue.main.async {
                    self.profileRightImage.isHidden = true
                    self.profileLeftImage.isHidden = false
                    self.profileLeftImage.image = image
                    self.profileLeftImage.setNeedsDisplay()
                    self.profileLeftImage.layoutIfNeeded()
                }
            } else if type == IZChatCellType.izChatCellOpponent {
                DispatchQueue.main.async {
                    self.profileLeftImage.isHidden = true
                    self.profileRightImage.isHidden = false
                    self.profileRightImage.image = image
                    self.profileRightImage.setNeedsDisplay()
                    self.profileRightImage.layoutIfNeeded()
                }
            }
        }
        
        self.setupUI()
        
        if type == IZChatCellType.izChatCellOwner {
            self.chatView.backgroundColor = self.ownerColor
            self.leftTailImageView.isHidden = false
            self.rightTailImageView.isHidden = true
        } else if type == IZChatCellType.izChatCellOpponent {
            self.chatView.backgroundColor = self.recipientColor
            self.leftTailImageView.isHidden = true
            self.rightTailImageView.isHidden = false
        }
    }
  }
