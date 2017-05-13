//
//  IZExtentions.swift
//  Talki
//
//  Created by Nikita Gil on 04.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit


extension NSObject {
    
    //*****************************************************************
    // MARK: - Convert from class to string and Nib - for Cells
    //*****************************************************************
    
    class func classNibFromString(_ className :AnyClass) -> (String?, UINib?) {
        
        let classNameString = NSStringFromClass(className).components(separatedBy: ".").last!
        let nibObject = UINib(nibName: classNameString, bundle:nil)
        
        return (classNameString, nibObject)
    }
    
    class func classFromString(_ className :AnyClass) -> String? {
        return NSStringFromClass(className).components(separatedBy: ".").last
    }
}


extension String {
    
    //*****************************************************************
    // MARK: - Check Email
    //*****************************************************************
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: self)
    }
    
    func isValidInterest() -> Bool {
        let interstRegEx = "[A-Za-z0-9 ]"
        let predicate = NSPredicate(format:"SELF MATCHES %@", interstRegEx)
        return predicate.evaluate(with: self)
    }
    
    func isValidNameOnly() -> Bool {
        let emailRegEx = "[A-Za-z]"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: self)
    }
}

extension UIImage {
    
    class func scaleSizeImage(_ image : UIImage , scale : CGFloat) -> UIImage {
    
        let newWidth = image.size.width * scale
        let newHeight = image.size.height * scale
        
        
        let targetSize = CGSize(width: newWidth, height: newHeight)
        let rect = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        return newImage!
    }
    
    func imageFixOrientation(_ img:UIImage) -> UIImage {
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform:CGAffineTransform = CGAffineTransform.identity
        // Rotate image clockwise by 90 degree
        if (img.imageOrientation == UIImageOrientation.up) {
            transform = transform.translatedBy(x: 0, y: img.size.height);
            transform = transform.rotated(by: CGFloat(-Double.pi/2));
        }
        
        if (img.imageOrientation == UIImageOrientation.down
            || img.imageOrientation == UIImageOrientation.downMirrored) {
            
            transform = transform.translatedBy(x: img.size.width, y: img.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        }
        
        if (img.imageOrientation == UIImageOrientation.left
            || img.imageOrientation == UIImageOrientation.leftMirrored) {
            
            transform = transform.translatedBy(x: img.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi/2))
        }
        
        if (img.imageOrientation == UIImageOrientation.right
            || img.imageOrientation == UIImageOrientation.rightMirrored) {
            
            transform = transform.translatedBy(x: 0, y: img.size.height);
            transform = transform.rotated(by: CGFloat(-Double.pi/2));
        }
        
        if (img.imageOrientation == UIImageOrientation.upMirrored
            || img.imageOrientation == UIImageOrientation.downMirrored) {
            
            transform = transform.translatedBy(x: img.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        if (img.imageOrientation == UIImageOrientation.leftMirrored
            || img.imageOrientation == UIImageOrientation.rightMirrored) {
            
            transform = transform.translatedBy(x: img.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }
        
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx:CGContext = CGContext(data: nil, width: Int(img.size.width), height: Int(img.size.height),
                                                     bitsPerComponent: img.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                                     space: img.cgImage!.colorSpace!,
                                                     bitmapInfo: img.cgImage!.bitmapInfo.rawValue)!;
        ctx.concatenate(transform)
        
        
        if (img.imageOrientation == UIImageOrientation.left
            || img.imageOrientation == UIImageOrientation.leftMirrored
            || img.imageOrientation == UIImageOrientation.right
            || img.imageOrientation == UIImageOrientation.rightMirrored
            || img.imageOrientation == UIImageOrientation.up
            ) {
            
            ctx.draw(img.cgImage!, in: CGRect(x: 0,y: 0,width: img.size.height,height: img.size.width))
        } else {
            ctx.draw(img.cgImage!, in: CGRect(x: 0,y: 0,width: img.size.width,height: img.size.height))
        }
        
        
        // And now we just create a new UIImage from the drawing context
        let cgimg:CGImage = ctx.makeImage()!
        let imgEnd:UIImage = UIImage(cgImage: cgimg)
        
        return imgEnd
    }
}

extension UILabel{
    
    //*****************************************************************
    // MARK: - Resize cell height
    //*****************************************************************
    
    func requiredHeight() -> CGFloat{
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = self.text
        
        label.sizeToFit()
        
        return label.frame.height + 20
    }
}

extension UITextView {
    
    //*****************************************************************
    // MARK: - Resize  height
    //*****************************************************************
    
    func requiredHeight() -> CGFloat{
        
        let textView:UITextView = UITextView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
        textView.sizeToFit()
        textView.layoutIfNeeded()
        let height = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height

        return height + 10
    }
    
    //*****************************************************************
    // MARK: - UITextView count rows
    //*****************************************************************
    
    func numberOfLines() -> Int{
        if let fontUnwrapped = self.font{
            return Int(self.contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }

}

extension UITableViewCell {
    func openURL(_ urlString: String) {
        if let urlWithPercentEscapes = urlString.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed), let url = URL(string: urlWithPercentEscapes) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

extension UITableView {
    func reloadData(_ completion: @escaping ()->()) {
        self.reloadData()
        DispatchQueue.main.async {
            completion()
        }
    }
}

//*****************************************************************
// MARK: - forbid emoji
//*****************************************************************
extension String {
    func containsEmoji() -> Bool {
        if self.isEmoji() {
            return true
        }
        return false
    }
    
    func isEmoji() -> Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x3030, 0x00AE, 0x00A9,// Special Characters
            0x1D000...0x1F77F,          // Emoticons
            0x2100...0x27BF,            // Misc symbols and Dingbats
            0xFE00...0xFE0F,            // Variation Selectors
            0x1F900...0x1F9FF:          // Supplemental Symbols and Pictographs
                return true
            default:
                continue
            }
        }
        return false
    }
    
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

//*****************************************************************
// MARK: - UIDevice
//*****************************************************************

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}
