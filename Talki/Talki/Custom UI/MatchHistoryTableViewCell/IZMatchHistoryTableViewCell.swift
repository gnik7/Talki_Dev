//
//  IZMatchHistoryTableViewCell.swift
//  Talki
//
//  Created by Nikita Gil on 12.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

class IZMatchHistoryTableViewCell: UITableViewCell {
    
    //IBOutlet
    @IBOutlet weak var avatarImageView      : UIImageView!
    @IBOutlet weak var stateImageView       : UIImageView!
    @IBOutlet weak var nameLabel            : UILabel!
    @IBOutlet weak var interestLabel        : UILabel!
    @IBOutlet weak var dateLabel            : UILabel!
    @IBOutlet weak var activityIndicator    : UIActivityIndicatorView!   
    @IBOutlet weak var indicatorView        : UIView!
    
    
    //let
    let interest = "also likes"
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
        
        self.avatarImageView.contentMode = UIViewContentMode.scaleAspectFill
        self.avatarImageView.layer.masksToBounds = false
        
        self.avatarImageView.setNeedsDisplay()
        self.avatarImageView.layoutIfNeeded()
        self.indicatorView.setNeedsDisplay()
        self.indicatorView.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //make circle image
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.bounds.width / 2
        self.avatarImageView.clipsToBounds = true
        self.indicatorView.layer.cornerRadius = self.indicatorView.bounds.width / 2
        self.indicatorView.clipsToBounds = true
    }
    
    //*****************************************************************
    // MARK: - Set Data
    //*****************************************************************
    
    func updateData(_ item : IZPushMatchItemModel){
        
        if let name = item.user?.name as String? {
            self.nameLabel.text = name
        } else {
            self.nameLabel.text = ""
        }
        
        if let interestsArray = item.interests as [IZInterestModel]? {
            let interests = self.interest + " " + ((interestsArray.first?.interest) ?? "")
            self.interestLabel.text = interests.lowercased()
        }
        
        if let time = item.matchTime as String? {
            let date = IZHelper.convertTimeFromString(time)
            let newDate = IZHelper.convertTimeToString(date)
            self.dateLabel.text = newDate
        } else {
            self.dateLabel.text = ""
        }
        
        if let isViewed = item.isView {
            if !isViewed {
                indicatorView.backgroundColor = selectedColor
            } else {
                indicatorView.backgroundColor = defaultColot
            }
        } else {
            indicatorView.backgroundColor = defaultColot
        }
        
        if let imageUrl = item.user?.urlAvatar?.preview as String? {
            DispatchQueue.main.async(execute: { () -> Void in
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
            })
            
            self.avatarImageView.kf.setImage(with: URL(string: imageUrl)!, placeholder: nil, options: [], progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                DispatchQueue.main.async(execute: { () -> Void in
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.avatarImageView.layer.cornerRadius = self.avatarImageView.bounds.width / 2
                    self.avatarImageView.clipsToBounds = true
                    self.avatarImageView.setNeedsDisplay()
                    self.avatarImageView.layoutIfNeeded()
                })
            })
        }
        
        if let myStatus = item.myStatus as String? {
            if myStatus == "accept" {
                self.stateImageView.image = UIImage(named: "checked_settings")
            } else if myStatus == "decline" {
                self.stateImageView.image = UIImage(named: "canceled_settings")
            } else if myStatus == "new" {
                self.stateImageView.image = UIImage(named: "new_match")
            }
        }
    }
    
}
