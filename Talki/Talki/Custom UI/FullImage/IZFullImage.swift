//
//  IZFullImage.swift
//  Talki
//
//  Created by Nikita Gil on 15.08.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

class IZFullImage: UIView {
    
    @IBOutlet weak var fullImageView        : UIImageView!
    @IBOutlet weak var activityIndicator    : UIActivityIndicatorView!
    
    lazy var tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(IZFullImage.gestureTap))
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    class func loadFromXib(_ bundle : Bundle? = nil) -> IZFullImage? {
        return UINib(
            nibName: "IZFullImage",
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? IZFullImage
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
    }
    
    //*****************************************************************
    // MARK: - Set UI
    //*****************************************************************
    
    fileprivate func updateUI() {
        self.activityIndicator.isHidden = true
        self.fullImageView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    }
    
    func bringToFront() {
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
    
    func showView(_ url : String) {

        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        
        self.fullImageView.kf.setImage(with: URL(string: url)!, placeholder: nil, options: [], progressBlock: nil) { (image, error, cacheType, imageURL) in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            
            UIView.animate(withDuration: 0.7, animations: {
                self.fullImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.fullImageView.addGestureRecognizer(self.tapGesture)
            })
        }
        
        self.bringToFront()
        
        self.alpha = 0.0
        self.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.alpha = 1.0
            }, completion: nil)
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
    
    func gestureTap(){
        self.fullImageView.removeGestureRecognizer(tapGesture)
        self.hideView()
    }
    
}
