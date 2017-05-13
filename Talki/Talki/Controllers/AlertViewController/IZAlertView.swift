//
//  IZAlertViewController.swift
//  Talki
//
//  Created by Nikita Gil on 8/9/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

class IZAlertView: UIView {
    
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
    
    class func loadFromXib(_ bundle : Bundle? = nil) -> IZAlertView? {
        return UINib(
            nibName: "IZAlertView",
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? IZAlertView
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
        
        self.acceptButton.layer.cornerRadius = self.acceptButton.frame.height / 2
        self.acceptButton.clipsToBounds = true
        
        self.declineButton.layer.cornerRadius = self.declineButton.frame.height / 2
        self.declineButton.clipsToBounds = true
        self.declineButton.layer.borderWidth = 1.0
        self.declineButton.layer.borderColor = UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1.0).cgColor
        }
    }

    func bringToFront() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        if let windowView = UIApplication.shared.keyWindow {
            windowView.endEditing(true)
            windowView.addSubview(self)
        }

        self.superview?.bringSubview(toFront: self)
    }
    
    fileprivate func updateCorner(){
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
    
    func showView(_ text : String, action: (() -> ())?) {
        updateCorner()
        self.updateUI()
        self.completion = action
        self.messageLabel.text = text
        
        self.showViewAnimation()
        self.updateUI()
    }
    
    func showViewWithCustomButtons(_ text: String, action: (() -> ())?) {
        
        self.setupShow()
        
        self.completion = action
        self.messageLabel.text = text
        
        self.acceptButton.setTitle("Ok", for: UIControlState())
        self.declineButton.setTitle("Cancel", for: UIControlState())
    }
    
    func showViewWithCustomButtonsPush(_ text: String, action: (() -> ())?) {
        
        self.setupShow()
        
        self.completion = action
        self.messageLabel.text = convertText(text)
        
        self.acceptButton.setTitle("See", for: UIControlState())
        self.declineButton.setTitle("Ignore", for: UIControlState())
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
    
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        self.hideView()
        if let action = completion {
            action()
        }
    }
    
    @IBAction func declineButtonPressed(_ sender: UIButton) {
        self.hideView()
    }
}
