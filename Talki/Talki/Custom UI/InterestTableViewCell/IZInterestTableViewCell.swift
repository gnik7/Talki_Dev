//
//  IZInterestTableViewCell.swift
//  Talki
//
//  Created by Nikita Gil on 05.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

class IZInterestTableViewCell: UITableViewCell {
    
    //
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //let
    let defaultColor = UIColor.white
    let selectedColor = UIColor(red: 229.0 / 255.0, green: 247.0 / 255.0, blue: 248.0 / 255.0, alpha: 1.0)
    
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //*****************************************************************
    // MARK: - Set Data
    //*****************************************************************
    
    func setupData(_ item :IZInterestModel){
        
        self.titleLabel.text = item.interest?.capitalized
        
        if item.state == true {
            self.mainImageView.image = UIImage(named: "checkbox_checked_homepage")
            self.contentView.backgroundColor = selectedColor
        } else {
            self.mainImageView.image = UIImage(named: "checkbox_homepage")
            self.contentView.backgroundColor = defaultColor
        }
    }    
    
}
