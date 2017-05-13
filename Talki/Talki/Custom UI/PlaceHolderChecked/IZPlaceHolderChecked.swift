//
//  IZAlertViewController.swift
//  Talki
//
//  Created by Nikita Gil on 8/9/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit


class IZPlaceHolderChecked: UIView {
    
    //IBOutlet
    @IBOutlet weak var checkImageView    : UIImageView!
    
    let apearingTime = 0.7
    let freezeTime = 2.0
    let totalTime = 1.8
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    class func loadFromXib(_ bundle : Bundle? = nil) -> IZPlaceHolderChecked? {
        return UINib(
            nibName: "IZPlaceHolderChecked",
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? IZPlaceHolderChecked
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.endEditing(true)
        checkImageView.isHidden = true
        checkImageView.alpha = 0.0
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }

    //*****************************************************************
    // MARK: - Set UI
    //*****************************************************************
    
    fileprivate func bringToFront() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        if let windowView = UIApplication.shared.keyWindow {
            windowView.endEditing(true)
            windowView.addSubview(self)
        }

        self.superview?.bringSubview(toFront: self)
    }
    
    //*****************************************************************
    // MARK: - Show/ Hide
    //*****************************************************************
    
    func showView() {
       
        self.bringToFront()
        
        self.alpha = 0.0
        self.isHidden = false
        
        UIView.animate(withDuration: self.apearingTime, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.alpha = 1.0
            self.checkImageView.isHidden = false
            }, completion:{ _ in
              UIView.animate(withDuration: self.apearingTime, animations: {
                self.checkImageView.alpha = 1.0
                }, completion: { (fin) in
                    UIView.animate(withDuration: self.freezeTime, animations: {
                        
                        }, completion: { (fin) in
                            UIView.animate(withDuration: self.apearingTime, animations: {
                                self.alpha = 0.0
                                }, completion: { (fin) in
                                    self.isHidden = true
                                    self.removeFromSuperview()
                            })
                    })
              })
        })
    }
    
}
