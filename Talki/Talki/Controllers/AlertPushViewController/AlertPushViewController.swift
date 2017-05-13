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
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    
    
    //var
    var textMessage : String?
    var completion : (() -> ())?
    
    //let
    let alsoInterest = "Also likes "
    let mainViewRadius : CGFloat = 0.1
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    class func loadFromXib(bundle : NSBundle? = nil) -> IZAlertView? {
        return UINib(
            nibName: "AlertPushViewController",
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? AlertPushViewController
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateUI()
    }

    //*****************************************************************
    // MARK: - Set UI
    //*****************************************************************
    
    private func updateUI() {

        dispatch_async(dispatch_get_main_queue()) {
        
        self.mainAlertView.layer.cornerRadius = self.mainAlertView.frame.size.height * self.mainViewRadius
        self.mainAlertView.clipsToBounds = true
        
        self.acceptButton.layer.cornerRadius = CGRectGetHeight(self.acceptButton.frame) / 2
        self.acceptButton.clipsToBounds = true
        
        self.declineButton.layer.cornerRadius = CGRectGetHeight(self.declineButton.frame) / 2
        self.declineButton.clipsToBounds = true
        self.declineButton.layer.borderWidth = 1.0
        self.declineButton.layer.borderColor = UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1.0).CGColor
        }
    }

    func bringToFront() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
        if let windowView = UIApplication.sharedApplication().keyWindow {
            windowView.addSubview(self)
        }

        self.superview?.bringSubviewToFront(self)
    }
    
    private func updateCorner(){
        self.mainAlertView.setNeedsDisplay()
        self.mainAlertView.layoutIfNeeded()
        self.acceptButton.setNeedsDisplay()
        self.acceptButton.layoutIfNeeded()
        self.declineButton.setNeedsDisplay()
        self.declineButton.layoutIfNeeded()
    }
    
    //*****************************************************************
    // MARK: - Show/ Hide
    //*****************************************************************
    
    func showView(text : String, action: (() -> ())?) {
        updateCorner()
        self.updateUI()
        self.completion = action
        self.messageLabel.text = text
        
        self.showViewAnimation()
        self.updateUI()
    }
    
    func showViewWithCustomButtons(text: String, action: (() -> ())?) {
        
        self.setupShow()
        
        self.completion = action
        self.messageLabel.text = text
        
        self.acceptButton.setTitle("Ok", forState: UIControlState.Normal)
        self.declineButton.setTitle("Cancel", forState: UIControlState.Normal)
    }
    
    func showViewWithCustomButtonsPush(text: String, action: (() -> ())?) {
        
        self.setupShow()
        
        self.completion = action
        self.messageLabel.text = convertText(text)
        
        self.acceptButton.setTitle("See", forState: UIControlState.Normal)
        self.declineButton.setTitle("Ignore", forState: UIControlState.Normal)
    }
    
    private func convertText(text: String) -> String {
        
        if text.containsString("!") {
            let array = text.componentsSeparatedByString("!")
            let newText = array.first! + "!" + "\n" + array.last!
            return newText
        }
        
        return text
    }

    
    private func setupShow() {
        updateCorner()
        self.updateUI()
        
        self.showViewAnimation()
    }
    
    private func showViewAnimation() {
        
        self.bringToFront()
        
        self.alpha = 0.0
        self.hidden = false
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            self.alpha = 1.0
            }, completion: nil)

    }
    
    private  func hideView() {
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.alpha = 0.0
            }, completion: { (Bool) -> Void in
                self.hidden = true
                self.removeFromSuperview()
        })
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func acceptButtonPressed(sender: UIButton) {
        self.hideView()
        if let action = completion {
            action()
        }
    }
    
    @IBAction func declineButtonPressed(sender: UIButton) {
        self.hideView()
    }
}
