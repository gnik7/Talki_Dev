//
//  IZPageControl.swift
//  Talki
//
//  Created by Nikita Gil on 10.08.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

class IZPageControl: UIPageControl {
    var activeImage: UIImage!
    var inactiveImage: UIImage!
    override var currentPage: Int {
        //willSet {
        didSet { //so updates will take place after page changed
            self.updateDots()
        }
    }
    
    convenience init(activeImage: UIImage, inactiveImage: UIImage) {
        self.init()
        
        self.activeImage = activeImage
        self.inactiveImage = inactiveImage
        
        self.pageIndicatorTintColor = UIColor.clear
        self.currentPageIndicatorTintColor = UIColor.clear
    }
    
    func updateDots() {
        for i in 0 ..< subviews.count {
            let view: UIView = subviews[i] 
            if view.subviews.count == 0 {
                self.addImageViewOnDotView(view, imageSize: activeImage.size)
            }
            let imageView: UIImageView = view.subviews.first as! UIImageView
            imageView.image = self.currentPage == i ? activeImage : inactiveImage
        }
    }
    
    // MARK: - Private
    
    fileprivate func addImageViewOnDotView(_ view: UIView, imageSize: CGSize) {
        var frame = view.frame
        frame.origin = CGPoint.zero
        frame.size = imageSize
        
        let imageView = UIImageView(frame: frame)
        imageView.contentMode = UIViewContentMode.center
        view.addSubview(imageView)
    }
    
}
