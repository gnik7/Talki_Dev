//
//  IZAlertViewController.swift
//  Talki
//
//  Created by Nikita Gil on 8/9/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

class IZAlertMessagePush: UIView {
    
    //IBOutlet
    @IBOutlet weak var messageLabel     : UILabel!
    @IBOutlet weak var mainAlertView    : UIView!
    @IBOutlet weak var titleImage       : UIImageView!
    
    //var
    var textMessage : String?
    var completion  : (() -> ())?
    var timer       : Timer?
   
    let mainViewRadius  : CGFloat = 0.1
    let timeForHide     : TimeInterval = 4.5
    let heightView      : CGFloat = 70
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    class func loadFromXib(_ bundle : Bundle? = nil) -> IZAlertMessagePush? {
        return UINib(
            nibName: "IZAlertMessagePush",
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? IZAlertMessagePush
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
        
        self.mainAlertView.cornerRadius = 7.0
        self.mainAlertView.clipsToBounds = true
            
        self.mainAlertView.layer.borderWidth = 0.5
            self.mainAlertView.layer.borderColor = UIColor(red: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1.0).cgColor
        
        self.titleImage.layer.cornerRadius = 5
        self.titleImage.clipsToBounds = true
        }
    }

    func bringToFront() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: heightView)
        if let windowView = UIApplication.shared.keyWindow {
            windowView.endEditing(true)
            windowView.addSubview(self)
        }

        self.superview?.bringSubview(toFront: self)
    }
    
    fileprivate func updateCorner(){
        self.mainAlertView.setNeedsDisplay()
        self.mainAlertView.layoutIfNeeded()
        self.titleImage.setNeedsDisplay()
        self.titleImage.layoutIfNeeded()
    }
    
    
    //*****************************************************************
    // MARK: - Show/ Hide
    //*****************************************************************
    
    func showNewMessage(_ text: String, action: (() -> ())?) {
        UIApplication.shared.isStatusBarHidden = true
        self.setupShow()
        
        self.completion = action
        self.messageLabel.text = text
    }

    fileprivate func setupShow() {
        updateCorner()
        self.updateUI()
        
        self.showViewAnimation()
    }
    
    fileprivate func showViewAnimation() {
        
        self.timer = Timer.scheduledTimer(timeInterval: self.timeForHide, target: self, selector: #selector(IZAlertMessagePush.hideView), userInfo: nil , repeats: false)
        
        self.bringToFront()
        
        self.alpha = 0.0
        self.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.alpha = 1.0
            }, completion: nil)
    }
    
   func hideView() {
    UIApplication.shared.isStatusBarHidden = false
        self.timer?.invalidate()
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
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
        self.hideView()
        if let action = completion {
            action()
        }
    }
}
