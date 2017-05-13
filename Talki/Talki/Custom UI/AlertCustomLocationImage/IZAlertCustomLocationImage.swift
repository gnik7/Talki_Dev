//
//  IZAlertViewController.swift
//  Talki
//
//  Created by Nikita Gil on 8/9/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

enum ActionType {
    case takePhotoActionType
    case galleryPhotoActionType
    case locationActionType
    case cancelActionType
}

class IZAlertCustomLocationImage: UIView {
    
    //IBOutlet
    @IBOutlet weak var mainView         : UIView!
    @IBOutlet weak var cancelView       : UIView!
    @IBOutlet weak var customAlertView  : UIView!
   
    
    //var
    var completion : ((_ typeAction : ActionType) -> ())?
    
    //let
    let mainViewRadius : CGFloat = 0.1
    let dimention = UIScreen.main.bounds.size.height * 0.6
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    class func loadFromXib(_ bundle : Bundle? = nil) -> IZAlertCustomLocationImage? {
        return UINib(
            nibName: "IZAlertCustomLocationImage",
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? IZAlertCustomLocationImage
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateUI()
        self.animationMoveDown()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateUI()
    }

    //*****************************************************************
    // MARK: - Set UI
    //*****************************************************************
    
    private func updateCorner(){
        self.mainView.setNeedsDisplay()
        self.mainView.layoutIfNeeded()
        self.cancelView.setNeedsDisplay()
        self.cancelView.layoutIfNeeded()
    }
    
    private func updateUI() {

        self.mainView.layer.cornerRadius = self.mainView.frame.size.height * mainViewRadius
        self.mainView.clipsToBounds = true
        
        self.cancelView.layer.cornerRadius = self.cancelView.frame.height / 2
        self.cancelView.clipsToBounds = true
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
            self.customAlertView.transform = CGAffineTransform(translationX: 0, y: self.dimention)
            }, completion: nil)
    }
    
    func animationMoveUp() {
        UIView.animate(withDuration: 0.5, animations: {
            self.customAlertView.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
    }
    
    //*****************************************************************
    // MARK: - Show/ Hide
    //*****************************************************************
    
    func showView(_ action: ((_ typeAction : ActionType) -> ())?) {
        
        updateCorner()
        
        self.completion = action
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
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************

    @IBAction func takePhotoButtonPressed(_ sender: UIButton) {
        self.hideView()
        if let action = completion {
            action(ActionType.takePhotoActionType)
        }
    }
    
    @IBAction func galleryButtonPressed(_ sender: UIButton) {
        self.hideView()
        if let action = completion {
            action(ActionType.galleryPhotoActionType)
        }
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        self.hideView()
        if let action = completion {
            action(ActionType.locationActionType)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.hideView()
        if let action = completion {
            action(ActionType.cancelActionType)
        }
    }

}
