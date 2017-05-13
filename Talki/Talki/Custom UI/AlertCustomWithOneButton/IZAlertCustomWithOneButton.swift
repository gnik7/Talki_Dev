//
//  IZAlertViewController.swift
//  Talki
//
//  Created by Nikita Gil on 8/9/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

class IZAlertCustomWithOneButton: UIView {
    
    //IBOutlet
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var mainAlertView: UIView!
    @IBOutlet weak var okButton: UIButton!
    
    //var
    var textMessage : String?
    var completion : (() -> ())?
    
    
    //let
    let mainViewRadius : CGFloat = 0.1
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    class func loadFromXib(_ bundle : Bundle? = nil) -> IZAlertCustomWithOneButton? {
        return UINib(
            nibName: "IZAlertCustomWithOneButton",
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? IZAlertCustomWithOneButton
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
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateUI()
    }

    //*****************************************************************
    // MARK: - Set UI
    //*****************************************************************
    
    fileprivate func updateCorner(){
        self.mainAlertView.setNeedsDisplay()
        self.mainAlertView.layoutIfNeeded()
        self.okButton.setNeedsDisplay()
        self.okButton.layoutIfNeeded()
    }
    
    fileprivate func updateUI() {
        
        self.mainAlertView.layer.cornerRadius = self.mainAlertView.frame.size.height * mainViewRadius
        self.mainAlertView.clipsToBounds = true
        
        self.okButton.layer.cornerRadius = self.okButton.frame.height / 2
        self.okButton.clipsToBounds = true
    }

    fileprivate func bringToFront() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        if let windowView = UIApplication.shared.keyWindow {
            windowView.endEditing(true)
            windowView.addSubview(self)
        }

        self.superview?.bringSubview(toFront: self)
        updateCorner()
    }
    
    //*****************************************************************
    // MARK: - Show/ Hide
    //*****************************************************************
    
    func showView(_ text : String) {
        
        self.messageLabel.text = text
        self.messageLabel.frame.size.height = self.messageLabel.requiredHeight()
        
        self.bringToFront()
        
        UIView.animate(withDuration: 0.0, animations: {
            self.alpha = 0.0
            self.isHidden = false
            }, completion: { (fininshed) in
                self.okButton.layer.cornerRadius = self.okButton.frame.height / 2
                self.okButton.clipsToBounds = true
                self.mainAlertView.layer.cornerRadius = self.mainAlertView.frame.size.height * self.mainViewRadius
                self.mainAlertView.clipsToBounds = true
                
                UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
                    self.alpha = 1.0
                    }, completion: nil)

        })
    }
    
    func showViewWithCompletion(_ text : String, action: (() -> ())?) {
        self.completion = action
        self.messageLabel.text = text
        self.messageLabel.frame.size.height = self.messageLabel.requiredHeight()
        
        self.bringToFront()
        
        UIView.animate(withDuration: 0.0, animations: {
            self.alpha = 0.0
            self.isHidden = false
            }, completion: { (fininshed) in
                self.okButton.layer.cornerRadius = self.okButton.frame.height / 2
                self.okButton.clipsToBounds = true
                self.mainAlertView.layer.cornerRadius = self.mainAlertView.frame.size.height * self.mainViewRadius
                self.mainAlertView.clipsToBounds = true
                
                UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
                    self.alpha = 1.0
                    }, completion: nil)
                
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
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        self.hideView()
        if let action = completion {
            action()
        }
    }

}
