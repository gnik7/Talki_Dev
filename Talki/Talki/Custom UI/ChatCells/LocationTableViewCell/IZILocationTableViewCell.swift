//
//  IZImageTableViewCell.swift
//  Talki
//
//  Created by Nikita Gil on 8/23/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

protocol IZChatLocationCellDelegate : NSObjectProtocol {
    func locationLoaded(_ indexPath : IndexPath, text : String?)
    func showChatLocation(_ item : IZSingleChatMessageItemModel)
}

class IZILocationTableViewCell: IZChatTypeBaseCell {

    @IBOutlet weak var activityIndicator        : UIActivityIndicatorView!
    @IBOutlet weak var locationLabel            : UILabel!
    @IBOutlet weak var timeLabel                : UILabel!
    
    @IBOutlet weak var leftViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightViewConstraint: NSLayoutConstraint!
    
    weak var delegate       : IZChatLocationCellDelegate?
    var currentItem         : IZSingleChatMessageItemModel?
    var locationText        : String?
    var currentIndexPath    : IndexPath?
    var currentTypeCell     : IZChatCellType!
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
    
    override func updateData(_ item : IZSingleChatMessageItemModel?, profileImage : UIImage?, type :IZChatCellType) {
        super.updateData(item, profileImage: profileImage, type: type)
        
        currentTypeCell = type
        
        if type == IZChatCellType.izChatCellOwner {
            self.rightViewConstraint.constant = self.contentView.frame.size.width * self.opponentConstant
            self.leftViewConstraint.constant = self.contentView.frame.size.width * self.ownerConstant
        } else if type == IZChatCellType.izChatCellOpponent {
            self.leftViewConstraint.constant = self.contentView.frame.size.width * self.opponentConstant
            self.rightViewConstraint.constant = self.contentView.frame.size.width * self.ownerConstant
        }
        
        guard let currentItem = item as IZSingleChatMessageItemModel? else {
            return
        }
        
        self.currentItem = currentItem

        if let timeMessage = currentItem.time as String? {
            let date = IZHelper.convertTimeFromString(timeMessage)
            let time = IZHelper.convertTimeHourMinitToString(date)
            self.timeLabel.text = time
        }
        
        if self.locationText == nil {
            if let location = currentItem.location as IZSingleChatLocationModel? {
                if let longt = location.longitude as Double?, let lat = location.latitude as Double? {
                    
                    self.locationLabel.text = "Waiting ..."
                    self.locationLabel.isHidden = false
                    
                    let coordinate = UserLocation.locationFromDoubleToCLLocation(lat, longitude:  longt)
                    self.activityIndicator.startAnimating()
                    self.activityIndicator.isHidden = false
                    UserLocation.updateCurrentLocationAddress(coordinate, completed:{ (address) in
                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                        }
                        if let delegate = self.delegate {
                            delegate.locationLoaded(self.currentIndexPath!, text: address)
                        }
                    })
                }
            }
        } else {
            self.locationLabel.text = self.locationText!
        }
    }
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        
        if currentTypeCell == IZChatCellType.izChatCellOwner {
            return
        }        
        guard let currentItem = self.currentItem, let delegate = self.delegate  else {
            return
        }
        
        delegate.showChatLocation(currentItem)
        
//        let coordinate = UserLocation.locationFromDoubleToCLLocation((self.currentItem?.location?.latitude!)!, longitude: (self.currentItem?.location?.longitude!)!)
//        
//        let url = UserLocation.updateLocationAddressForMap(coordinate)
//        self.openURL(url)
    }
}
