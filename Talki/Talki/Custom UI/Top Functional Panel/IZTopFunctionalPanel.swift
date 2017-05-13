//
//  IZTopFunctionalPanel.swift
//  Talki
//
//  Created by Nikita Gil on 01.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

protocol TopFunctionalPanelDelegate: NSObjectProtocol {
    func rightButtonWasPressed()
    func leftButtonWasPressed()
}

enum BackgroundRightButton {
    case textBackgroundRightButton
    case imageBackgroundRightButton
}

enum BackgroundLeftButton {
    case crossBackgroundLeftButton
    case backBackgroundLeftButton
}



class IZTopFunctionalPanel: UIView {
    
    // @IBOutlet
    @IBOutlet weak var titleLabel                       : UILabel!
    @IBOutlet weak var titleForButtonLabel              : UILabel!
    @IBOutlet weak var placeholderForButtonImageView    : UIImageView!
    @IBOutlet weak var backButtonImageView              : UIImageView!
    @IBOutlet weak var backButton                       : UIButton!
    

    // var
    weak var delegate: TopFunctionalPanelDelegate?
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleForButtonLabel.isHidden = true
        self.placeholderForButtonImageView.isHidden = true
        self.backButtonImageView.isHidden = true
        self.backButton.isEnabled = false
    }
    
    /**
     Get IZTopFunctionalPanel from xib
     
     - parameter bundle: bundle for search. Default nil
     
     - returns: object IZTopFunctionalPanel
     */
    
    class func loadFromXib(_ bundle : Bundle? = nil) -> IZTopFunctionalPanel? {
        return UINib(
            nibName: IZRouterConstant.kIZTopFunctionalPanel,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? IZTopFunctionalPanel
    }
    
    /**
     Setting ui for current viewcontroller
     */
    
    func updateUI(_ title :String?, titleRightButton :BackgroundRightButton?, rightTitleText : String? , titleLeftButton :BackgroundLeftButton?){
        
        self.titleLabel.text = title!
        
        if let right = titleRightButton as BackgroundRightButton? {
            
            if right == BackgroundRightButton.textBackgroundRightButton {
                
                if let rightTitle = rightTitleText as String? {
                    self.titleForButtonLabel.text = rightTitle
                    self.titleForButtonLabel.isHidden = false
                    self.placeholderForButtonImageView.isHidden = true
                }
            } else if right == BackgroundRightButton.imageBackgroundRightButton {
                self.titleForButtonLabel.isHidden = true
                self.placeholderForButtonImageView.isHidden = false
            }
        }
        
        if let left = titleLeftButton as BackgroundLeftButton? {
            
            self.backButtonImageView.isHidden = false
            self.backButton.isEnabled = true
            
            if left == BackgroundLeftButton.crossBackgroundLeftButton {
                self.backButtonImageView.image = UIImage(named: "")
            } else if left == BackgroundLeftButton.backBackgroundLeftButton {
                self.backButtonImageView.image = UIImage(named: "back_button")
            }
        }
    }
    
    func rightButtonChange(_ name: String) {
        self.placeholderForButtonImageView.image = UIImage(named: name)
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        
        if let delegate = self.delegate as TopFunctionalPanelDelegate?  {
            delegate.rightButtonWasPressed()
        }
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        if let delegate = self.delegate as TopFunctionalPanelDelegate?  {
            delegate.leftButtonWasPressed()
        }
    }
    
    
}
