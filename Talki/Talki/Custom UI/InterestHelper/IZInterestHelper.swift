//
//  IZAlertViewController.swift
//  Talki
//
//  Created by Nikita Gil on 8/9/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit


class IZInterestHelper: UIView {
    
    //IBOutlet
    @IBOutlet weak var mainView         : UIView!
    @IBOutlet weak var customAlertView  : UIView!
    @IBOutlet weak var gotItButton      : UIButton!
    
    @IBOutlet weak var arrowImageView   : UIImageView!
    @IBOutlet weak var plusImageView    : UIImageView!
    @IBOutlet weak var alertTextLabel   : UILabel!
    
    
    //let
    let mainViewRadius : CGFloat = 0.2
    let dimention = UIScreen.main.bounds.size.height * 0.6
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    class func loadFromXib(_ bundle : Bundle? = nil) -> IZInterestHelper? {
        return UINib(
            nibName: "IZInterestHelper",
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? IZInterestHelper
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.animationMoveDown()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateUI()
    }

    //*****************************************************************
    // MARK: - Set UI
    //*****************************************************************
    
    fileprivate func updateUI() {
        DispatchQueue.main.async(execute: { () -> Void in
            self.mainView.layer.cornerRadius = self.mainView.frame.size.height * self.mainViewRadius
            self.mainView.clipsToBounds = true
            
            self.gotItButton.layer.cornerRadius = self.gotItButton.frame.height / 2
            self.gotItButton.clipsToBounds = true
        })
    }
    
    fileprivate func updateCorner(){
        self.mainView.setNeedsDisplay()
        self.mainView.layoutIfNeeded()
        self.gotItButton.setNeedsDisplay()
        self.gotItButton.layoutIfNeeded()
    }

    fileprivate func bringToFront() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        if let windowView = UIApplication.shared.keyWindow {
            windowView.endEditing(true)
            windowView.addSubview(self)
        }

        self.superview?.bringSubview(toFront: self)
    }
    
    func animationMoveDown() {
        UIView.animate(withDuration: 0.0, animations: {
            self.customAlertView.alpha = 0.0
            }, completion: nil)
    }
    
    func animationMoveUp() {
        UIView.animate(withDuration: 0.5, animations: {
            self.customAlertView.alpha = 1.0
            }, completion: nil)
    }
    
    func hideHelher() {
        self.arrowImageView.isHidden = true
        self.plusImageView.isHidden = true
    }
    
    //*****************************************************************
    // MARK: - Show/ Hide
    //*****************************************************************
    
    func showView() {
        self.updateCorner()
        self.updateUI()
        self.bringToFront()
        
        self.alpha = 0.0
        self.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.alpha = 1.0
            }, completion:{ _ in
               self.animationMoveUp()
        })
    }
    
    func hideView() {
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.alpha = 0.0
            }, completion: { (Bool) -> Void in
                self.isHidden = true
                self.removeFromSuperview()
        })
    }
    
    func updateText(_ text: String) {
        self.alertTextLabel.text = text
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************

    @IBAction func gotButtonPressed(_ sender: UIButton) {
        IZUserDefaults.updateFirstInterestHelperUserDefault()
        self.hideView()
    }
}
