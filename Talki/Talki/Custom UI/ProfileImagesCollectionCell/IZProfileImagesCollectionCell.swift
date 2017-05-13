//
//  IZProfileImagesCollectionCell.swift
//  Talki
//
//  Created by Nikita Gil on 04.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

protocol IZProfileImagesCollectionCellDelegate: NSObjectProtocol {
    func trashtButtonWasPressed(_ index :Int)
}

class IZProfileImagesCollectionCell: UICollectionViewCell {
    
    //BOutlet
    @IBOutlet weak var mainImageView            : UIImageView!
    @IBOutlet weak var cameraImageView          : UIImageView!
    @IBOutlet weak var closeImageView           : UIImageView!
    @IBOutlet weak var closeView                : UIView!
    @IBOutlet weak var addImageLabel            : UILabel!
    @IBOutlet weak var trashButton              : UIButton!
    @IBOutlet weak var imageActivityIndicator   : UIActivityIndicatorView!
    
    
    //var
    weak var delegate: IZProfileImagesCollectionCellDelegate?
    var index : Int?
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.mainImageView.isHidden = true
        self.addImageLabel.isHidden = true
        self.closeView.isHidden = true
        self.closeImageView.isHidden = true
        self.cameraImageView.isHidden = true
    }
    
    func configurateUI(_ imageName :String?, currentIndex :Int?) {
        
        if let image = imageName as String? {
            // with new Image
            self.mainImageView.isHidden = false
            self.addImageLabel.isHidden = true
            self.cameraImageView.isHidden = true
            
            DispatchQueue.main.async(execute: { () -> Void in
                    self.imageActivityIndicator.isHidden = false
                    self.imageActivityIndicator.startAnimating()
                })
            
            self.mainImageView.kf.setImage(with: URL(string: image)!, placeholder: UIImage(named: "add_image_dash"), options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL)  in
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    self.imageActivityIndicator.stopAnimating()
                    self.imageActivityIndicator.isHidden = true
                    
                    self.closeView.isHidden = false
                    self.closeImageView.isHidden = false
                    
                    self.closeView.clipsToBounds = true
                    self.closeView.layer.cornerRadius = self.closeView.frame.height / 2
                })
                
            })
//            self.mainImageView.contentMode = UIViewContentMode.ScaleAspectFill;
          
        } else {
            //empty
            self.mainImageView.image = UIImage(named: "add_image_dash")
            self.mainImageView.contentMode = UIViewContentMode.scaleToFill;
            self.addImageLabel.isHidden = false
            self.mainImageView.isHidden = false
            self.closeView.isHidden = true
            self.closeImageView.isHidden = true
            self.cameraImageView.isHidden = false
            self.imageActivityIndicator.isHidden = true
        }
        self.index = currentIndex
    }
    
    class func sizeCollectionCell(_ numberColumns: Int, heightCell :CGFloat) -> CGSize {
        
        //for margin on both side
        let margingConst :CGFloat = 0.9
        
        let width = UIScreen.main.bounds.size.width * margingConst
        
        let widthCell  = width / CGFloat(numberColumns)
        let height = widthCell * margingConst
        
        return CGSize(width: widthCell, height: height)
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func trashButtonPressed(_ sender: UIButton) {
        if let delegate = self.delegate as IZProfileImagesCollectionCellDelegate?  {
            delegate.trashtButtonWasPressed(self.index!)
        }
    }
 
}

extension UICollectionViewCell {
    //*****************************************************************
    // MARK: - Highlight
    //*****************************************************************
    func didHighlight() {
        //self.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
    }
    
    func didUnhighlight() {
        //self.backgroundColor = UIColor.whiteColor()
    }
}
