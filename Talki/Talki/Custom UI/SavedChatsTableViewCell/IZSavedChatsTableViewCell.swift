//
//  IZSavedChatsTableViewCell.swift
//  Talki
//
//  Created by Nikita Gil on 13.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

class IZSavedChatsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView : UIImageView!
    @IBOutlet weak var nameLabel        : UILabel!
    @IBOutlet weak var chatTextLabel    : UILabel!
    @IBOutlet weak var chatDateLabel    : UILabel!
    @IBOutlet weak var profileActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var indicatorView    : UIView!
    @IBOutlet weak var locatioFotoImage : UIImageView!
    @IBOutlet weak var locationFotoLabel: UILabel!
    
    @IBOutlet weak var heightImageLocationFotoConstraint: NSLayoutConstraint!

    let fotoText = "photo"
    let locationText = "location"
    let selectedColor = UIColor(red: 234.0/255.0, green: 96.0/255.0, blue: 83.0/255.0, alpha: 1.0)
    let defaultColot = UIColor.white
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileActivityIndicator.isHidden = true
        
        self.profileImageView.setNeedsDisplay()
        self.profileImageView.layoutIfNeeded()
        self.indicatorView.setNeedsDisplay()
        self.indicatorView.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //make circle image
        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.width / 2
        self.profileImageView.clipsToBounds = true
        self.indicatorView.layer.cornerRadius = self.indicatorView.bounds.width / 2
        self.indicatorView.clipsToBounds = true
    }

    //*****************************************************************
    // MARK: - Set Data
    //*****************************************************************
    
    func updateData(_ item : IZChatMessageItemModel?) {
        
        if let image = item?.recipient!.avatar?.preview as String? {
            if !image.isEmpty {
                
                self.profileActivityIndicator.isHidden = false
                self.profileActivityIndicator.startAnimating()
                
                self.profileImageView.kf.setImage(with: URL(string: image)!, placeholder: nil, options: [], progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                    self.profileActivityIndicator.stopAnimating()
                    self.profileActivityIndicator.isHidden = true
                })
            }
        }
        
        if let name = item?.recipient?.name as String? {
            self.nameLabel.text = name
        } else {
            self.nameLabel.text = ""
        }
    
        if let time = item?.time as String? {
            let date = IZHelper.convertTimeFromString(time)
            let convertDate = IZHelper.convertTimeToString(date)
            self.chatDateLabel.text = convertDate
        } else {
            self.chatDateLabel.text = ""
        }
        
        if let isViewed = item?.isView {
            if !isViewed {
                indicatorView.backgroundColor = selectedColor
            } else {
                indicatorView.backgroundColor = defaultColot
            }
        } else {
            indicatorView.backgroundColor = defaultColot
        }
        
        if IZChatCellType.izChatCellText == item?.cellType {
            if let chatText = item?.text as String? {
                self.chatTextLabel.text = chatText
            } else {
                self.chatTextLabel.text = ""
            }
            self.locatioFotoImage.isHidden = true
            self.locationFotoLabel.isHidden = true
            self.chatTextLabel.isHidden = false
        } else if IZChatCellType.izChatCellLocation == item?.cellType || IZChatCellType.izChatCellImage == item?.cellType   {
            self.locatioFotoImage.isHidden = false
            self.locationFotoLabel.isHidden = false
            self.chatTextLabel.isHidden = true
        }
        
        if IZChatCellType.izChatCellImage == item?.cellType  {
            self.locationFotoLabel.text = fotoText
            self.locatioFotoImage.image = UIImage(named: "photo_chat_message")
        } else if IZChatCellType.izChatCellLocation == item?.cellType {
            self.locationFotoLabel.text = locationText
            self.locatioFotoImage.image = UIImage(named: "location_chat")
            heightImageLocationFotoConstraint.constant = 11.0
        }
    }
}
