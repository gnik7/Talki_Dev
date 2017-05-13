//
//  IZMaxDistanceSettingTableViewCell.swift
//  Talki
//
//  Created by Nikita Gil on 05.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

class IZMaxDistanceSettingTableViewCell: IZGenericCell {
    
    //IBOutlet
    @IBOutlet weak var currentDistanceLabel : UILabel!
    @IBOutlet weak var titleLabel           : UILabel!
    @IBOutlet weak var distanceSlider       : UISlider!
    
    //var
    let maxDistance:Float = 250
    let minDistance:Float = 50
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        let imageHandel = UIImage(named: "handle_settings")
        self.distanceSlider.setThumbImage(UIImage.scaleSizeImage(imageHandel!, scale: 1.5)  , for: UIControlState())
        self.selectionStyle = UITableViewCellSelectionStyle.none
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
        if let distance = item.maxDistance as Int? {
            
            self.currentDistanceLabel.text = "\(distance) m"
            let percant = calculatePercentage(distance)
            self.distanceSlider.value = percant
        }
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************

    @IBAction func sliderValueChanged(_ sender: UISlider) {
    
        let distance = Int(calculateValue(sender.value))
        self.currentDistanceLabel.text = "\(distance) m"
        
        if let delegate = self.delegate as IZGenericCellDelegate? {
            delegate.selectedDistance(distance)
        }
    }
    
    fileprivate func  calculateValue(_ percentage :Float)  -> Float{
        return ((minDistance - maxDistance) * (1 - percentage) + maxDistance)
    }
    
    fileprivate func  calculatePercentage(_ value :Int)  -> Float{
        return (1 - ((Float(value) - maxDistance)/(minDistance - maxDistance)))
    }
    
}
