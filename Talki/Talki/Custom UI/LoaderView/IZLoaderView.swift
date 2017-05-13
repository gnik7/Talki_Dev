//
//  IZLoaderView.swift
//  ShakerApp
//
//  Created by Nikita Gil on 21.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

class  IZLoaderView :UIView {
    
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    /**
     Get IZLoaderView from xib
     
     - parameter bundle: bundle for search. Default nil
     
     - returns: object IZLoaderView
     */
    class func loadFromXib(_ bundle : Bundle? = nil) -> IZLoaderView? {
        return UINib(
            nibName: "IZLoaderView",
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? IZLoaderView
    }
    
    func configureView() {
        self.centerView.layer.cornerRadius = 10.0
        self.centerView.clipsToBounds = true
        
        self.activityIndicatorView.startAnimating()
    }
    
    func loadView() {
        
        if let windowView = UIApplication.shared.keyWindow {
            windowView.addSubview(self)
        }
    }
    
    func bringToFront() {
        
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        self.superview?.bringSubview(toFront: self)
    }
    
    func showView() {
        
        self.bringToFront()
        self.configureView()
        
        self.alpha = 0.0
        self.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.alpha = 0.6
            }, completion: nil)
    }
    
    func hideView() {
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.alpha = 0.0
            }, completion: { (Bool) -> Void in
                self.isHidden = true
        })
    }

}
