//
//  IZImageTableViewCell.swift
//  Talki
//
//  Created by Nikita Gil on 8/23/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit


class IZImageTableViewCell: IZChatTypeBaseCell {

    @IBOutlet weak var activityIndicator        : UIActivityIndicatorView!
    @IBOutlet weak var sendImage                : UIImageView!
    @IBOutlet weak var timeLabel                : UILabel!

     var currentItem         : IZSingleChatMessageItemModel?
    //let  heightCell  : CGFloat = 160.0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    override func setupUI() {
        super.setupUI()
        self.activityIndicator.isHidden = true
    }
    
    fileprivate func boundCornerToSendImage() {
        self.sendImage.layer.cornerRadius = kRadius - 7.0
        self.sendImage.clipsToBounds = true
        self.sendImage.layer.borderWidth = 1.5
        self.sendImage.layer.borderColor = UIColor.white.cgColor
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
        
           if let picture = item?.picture?.preview as String? {
            
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
            
            self.sendImage.kf.setImage(with: URL(string: picture)!, placeholder: nil, options: [], progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                self.boundCornerToSendImage()
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            })
            
            self.sendImage.contentMode = UIViewContentMode.scaleAspectFill;
        }
    }
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        if let picture = self.currentItem?.picture?.full as String? {
            let fullImage = IZFullImage.loadFromXib()
            fullImage?.showView(picture)
        }
    }
}
