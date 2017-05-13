//
//  IZAlertViewController.swift
//  Talki
//
//  Created by Nikita Gil on 8/9/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

class AlertPushViewController: UIView {
    
    //IBOutlet
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var mainAlertView: UIView!
    @IBOutlet weak var ignoreButton: UIButton!  
    @IBOutlet weak var seeButton: UIButton!
    
    
    //var
    var textMessage : String?
    var completion : (() -> ())?
    
    //let
    let alsoInterest = "Also likes "
    let mainViewRadius : CGFloat = 0.1
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    class func loadFromXib(_ bundle : Bundle? = nil) -> AlertPushViewController? {
        return UINib(
            nibName: "AlertPushViewController",
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? AlertPushViewController
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
    
    fileprivate func updateUI() {

        DispatchQueue.main.async {
        
        self.mainAlertView.layer.cornerRadius = self.mainAlertView.frame.size.height * self.mainViewRadius
        self.mainAlertView.clipsToBounds = true
        
        self.seeButton.layer.cornerRadius = self.seeButton.frame.height / 2
        self.seeButton.clipsToBounds = true
        
        self.ignoreButton.layer.cornerRadius = self.ignoreButton.frame.height / 2
        self.ignoreButton.clipsToBounds = true
        self.ignoreButton.layer.borderWidth = 1.0
        self.ignoreButton.layer.borderColor = UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1.0).cgColor
        }
    }

    func bringToFront() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        if let windowView = UIApplication.shared.keyWindow {
            
            //check if load image alert is showed
            var flag = false
            let  windowViewArray = windowView.subviews
            for v in windowViewArray {
                if v.isKind(of: IZAlertCustomTakeImage.self) {
                    flag = true
                }
            }
            if !flag {
                windowView.endEditing(true)
                windowView.addSubview(self)
                self.superview?.bringSubview(toFront: self)
            }
        }
    }
    
    fileprivate func updateCorner(){
        self.mainAlertView.setNeedsDisplay()
        self.mainAlertView.layoutIfNeeded()
        self.seeButton.setNeedsDisplay()
        self.seeButton.layoutIfNeeded()
        self.ignoreButton.setNeedsDisplay()
        self.ignoreButton.layoutIfNeeded()
    }
    
    //*****************************************************************
    // MARK: - Show/ Hide
    //*****************************************************************
    
    func show(_ text: String, action: (() -> ())?) {
        
        self.setupShow()
        
        self.completion = action
        self.messageLabel.text = text
    }
    
    func showNewMatch(_ text: String, action: (() -> ())?) {
        
        self.setupShow()
        
        self.completion = action
        self.messageLabel.text = convertText(text)
    }
    
    func showAcceptedMatch(_ text: String, action: (() -> ())?) {
        
        self.setupShow()
        
        self.completion = action
        self.messageLabel.text = "Match accepted!\n" + convertAcceptedText(text)
        
        self.seeButton.setTitle("Let's Talk!", for: UIControlState())
    }
    
    fileprivate func convertAcceptedText(_ text: String) -> String {
        let truncated = String(text.characters.dropLast())
        return truncated
    }

    fileprivate func convertText(_ text: String) -> String {
        
        if text.contains("!") {
            let array = text.components(separatedBy: "!")
            let newText = array.first! + "!" + "\n" + array.last!
            return newText
        }
        return text
    }
    
    fileprivate func setupShow() {
        updateCorner()
        self.updateUI()
        
        self.showViewAnimation()
    }
    
    fileprivate func showViewAnimation() {
        
        self.bringToFront()
        
        self.alpha = 0.0
        self.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.alpha = 1.0
            }, completion: nil)

    }
    
    fileprivate  func hideView() {
        
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
    
    @IBAction func seeButtonPressed(_ sender: UIButton) {
        self.hideView()
        if let action = completion {
            action()
        }
    }
    
    @IBAction func ignoreButtonPressed(_ sender: UIButton) {
        self.hideView()
    }
}
