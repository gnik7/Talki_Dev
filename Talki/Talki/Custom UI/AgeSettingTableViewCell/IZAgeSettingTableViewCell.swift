//
//  IZAgeSettingTableViewCell.swift
//  Talki
//
//  Created by Nikita Gil on 11.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit
import TTRangeSlider


class IZAgeSettingTableViewCell: IZGenericCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ageSlider: TTRangeSlider!
    
    //let 
    let minAge : Float = 16.0
    let maxAge : Float = 99.0
    let lineWidth : CGFloat = 2.0
    let colorBetweenHandles = UIColor(red: 0/255.0, green: 178/255.0, blue: 191/255.0, alpha: 1.0)
    let handleColor = UIColor(red: 162/255.0, green: 162/255.0, blue: 162/255.0, alpha: 1.0)
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        //set Age Slider
        self.ageSlider.minValue = self.minAge
        self.ageSlider.maxValue = self.maxAge
        self.ageSlider.handleColor = self.handleColor
        self.ageSlider.tintColorBetweenHandles = self.colorBetweenHandles
        self.ageSlider.lineHeight = self.lineWidth
        self.ageSlider.delegate = self
        self.ageSlider.step = 1.0
        self.ageSlider.enableStep = true
        self.ageSlider.minDistance = 1.0
        
        // step = 1 was enabled in storyboard

        self.ageSlider.handleImage = UIImage(named: "handle_settings")        
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
        
        guard let minAgeSelected = item.ageMin , let maxAgeSelected = item.ageMax else {
            return
        }
        self.ageSlider.selectedMinimum = Float(minAgeSelected)
        self.ageSlider.selectedMaximum = Float(maxAgeSelected)
        
        self.ageSlider.handleDiameter = 22.0
    }
}

extension IZAgeSettingTableViewCell : TTRangeSliderDelegate {
    
    //*****************************************************************
    // MARK: - TTRangeSliderDelegate
    //*****************************************************************
    
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {

        if let delegate = self.delegate as IZGenericCellDelegate? {
            delegate.selectedAge(Int(selectedMinimum), maxAge: Int(selectedMaximum))
        }
    }
}
