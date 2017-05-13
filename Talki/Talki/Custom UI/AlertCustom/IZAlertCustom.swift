//
//  IZAlertCustom.swift
//  Talki
//
//  Created by Nikita Gil on 8/1/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

protocol IZAlertCustomDelegate: NSObjectProtocol {
    func okButtonWasPressed()
}


class IZAlertCustom: UIView {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var okButton: UIButton!
    
    @IBOutlet weak var upperLabel: UILabel!
    @IBOutlet weak var lowerLabel: UILabel!
    
    weak var delegate : IZAlertCustomDelegate?
    var completion : (() -> ())?
    
    let mainViewRadius : CGFloat = 0.1
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.endEditing(true)
    }
    
    fileprivate func updateUI(){
        self.mainView.layer.cornerRadius = self.mainView.frame.height * mainViewRadius
        self.mainView.clipsToBounds = true
    }
    
    fileprivate func updateCorner(){
        self.mainView.setNeedsDisplay()
        self.mainView.layoutIfNeeded()
    }
    
    class func loadFromXib(_ bundle : Bundle? = nil) -> IZAlertCustom? {
        return UINib(
            nibName: "IZAlertCustom",
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? IZAlertCustom
    }
    
    func loadView() {
        
        if let windowView = UIApplication.shared.keyWindow {
            windowView.endEditing(true)
            windowView.addSubview(self)
        }
    }
    
    func bringToFront() {
        
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        self.superview?.bringSubview(toFront: self)
    }
    
    func showView() {        
        updateCorner()
        self.loadView()
        self.bringToFront()
        
        UIView.animate(withDuration: 0.0, animations: {
            self.alpha = 0.0
            self.isHidden = false
            
            }, completion: { (finished) in
                self.okButton.layer.cornerRadius = self.okButton.frame.height / 2
                self.okButton.clipsToBounds = true
                UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
                    self.alpha = 1.0
                    }, completion: {finished in })
        })      
    }
    
    func hideView() {
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.alpha = 0.0
            }, completion: { (Bool) -> Void in
                self.isHidden = true
               //self.removeFromSuperview()
        })
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        self.hideView()
        if let delegate = self.delegate as IZAlertCustomDelegate?  {
            delegate.okButtonWasPressed()
        }
        
        if let action = completion {
            action()
        }
    }
    
    //*****************************************************************
    // MARK: - Set Data
    //*****************************************************************
    
    func updateData(_ text1 : String, text2 : String) {
        self.upperLabel.text = text1
        self.lowerLabel.text = text2
    }
    
    func showViewForAcceptDeclinePush(_ text: String, action: (() -> ())?) {
        
        self.showView()
        
        self.completion = action
        self.upperLabel.text = text
    }

}
