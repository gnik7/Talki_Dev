//
//  IZHelper.swift
//  Talki
//
//  Created by Nikita Gil on 14.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class IZHelper {
    
    //--------------------------------------------
    // MARK: - Convert String with date
    //--------------------------------------------
    class func convertTimeToString(_ date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        let dateString = dateFormatter.string(from: date)
        let stringWithOutDot = dateString.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range: nil)
        return stringWithOutDot
    }
    
    class func convertTimeFromString(_ date : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        //2011-07-18T10:17:17.553Z
        return dateFormatter.date(from: date)!
    }
    
    class func convertTimeHourMinitToString(_ date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return (dateFormatter.string(from: date))
    }
    
    //--------------------------------------------
    // MARK: - Count Age
    //--------------------------------------------
    
    class func yearsAge(_ fromDate: Date) -> Int {
        
        let calendar: Calendar = Calendar.current
        
        let dateNow = calendar.startOfDay(for: Date())
        let dateAge = calendar.startOfDay(for: fromDate)
        
        let flag = NSCalendar.Unit.year
        let components = (calendar as NSCalendar).components(flag, from: dateAge, to: dateNow, options: [])
        let age = components.year
        
        return age!
    }
    
    class func updateYearMonthDay(_ fromDate: Date) -> (Int, Int, Int) {
        
        let calendar: Calendar = Calendar.current
        
        let components = (calendar as NSCalendar).components([.year , .month, .day], from: fromDate)
        let year = components.year
        let month = components.month
        let day = components.day
        
        return (year!, month!, day!)
    }
    
    class func compareDateInChat(_ currentDate : Date, previousDate : Date) -> Bool {
        
        let(currentYear, currentMonth, currentDay) = IZHelper.updateYearMonthDay(currentDate)
        let(previousYear, previousMonth, previousDay) = IZHelper.updateYearMonthDay(previousDate)
        
        if (currentYear == previousYear && currentMonth == previousMonth && currentDay == previousDay) {
            return true
        }
        
        return false
    }
    
    //--------------------------------------------
    // MARK: - URL
    //--------------------------------------------
    
    class func URL(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    //--------------------------------------------
    // MARK: - Check Image Size
    //--------------------------------------------
    
    class func checkFileSizeImage(_ image : UIImage) -> Bool {
        
        let maxSize = 10 * 1024 * 1024
        let lengthImage = UIImageJPEGRepresentation(image, 0.7)?.count
               
        if maxSize > lengthImage {
            return true
        }
        return false
    }
    
    //--------------------------------------------
    // MARK: - Convert Push Info
    //--------------------------------------------
    
    class func convertPushInfo(_ userInfo: [AnyHashable: Any]) -> (IZPushType, String, String) {
        
        var typePush : IZPushType = IZPushType.izPushNoType
        var message = ""
        var matchId = ""
        var messageFrom = ""
        
        if let aps = userInfo["aps"] as! [String: AnyObject]? {
            if let alert = aps["alert"] as! String? {
                message = alert
            }
        }
        
        if let match_id = userInfo["match_id"] as? String {
            typePush = IZPushType.izPushOneMatchType
            matchId = match_id
        }
        
        if let recipientId = userInfo["recipient_id"] as! String? {
            typePush = IZPushType.izPushOneMatchType
            matchId = recipientId
        }
        
        if let messFrom = userInfo["messageFrom"] as! String? {
            messageFrom = messFrom
        }
        
        if let type = userInfo["type"] as! String? {
            if type == "no_matches" {
                typePush = IZPushType.izPushNoMatchType
            } else if type == "matches" {
                typePush = IZPushType.izPushMatchesType
//                message = message + " " + messageFrom
            } else if type == "new_message" {
                typePush = IZPushType.izPushNessageType
               /* message = message + " " + messageFrom*/
            } else if type == "accepted_match" {
                typePush = IZPushType.izPushAcceptedMatchType
                //message = message /*+ " " + messageFrom*/
            }
        }
        if typePush == IZPushType.izPushOneMatchType {
            message = message + " " + messageFrom
        }
        
        return (typePush, message, matchId)
    }
    
    //*****************************************************************
    // MARK: - Create Title for Section
    //*****************************************************************
    
    class func createUILabelForSectionTitle(_ xOffset :CGFloat, width: CGFloat, text :String) -> UILabel {
        
        let headerLabel = UILabel(frame: CGRect(x: xOffset, y: 0, width: 200, height: 18.0))
        headerLabel.text = text
        headerLabel.font = UIFont(name: "SF-UI-Display-Light", size: 12.0)
        headerLabel.textColor = UIColor.init(colorLiteralRed: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1.0)
        headerLabel.textAlignment = .center
        headerLabel.sizeToFit()
        
        return headerLabel
    }
    
    //*****************************************************************
    // MARK: - Sort interests Array
    //*****************************************************************
    
    class func sortCheckerArrayInterests(_ interests: [IZInterestModel]) -> [IZInterestModel] {
        var checkedArray = [IZInterestModel]()
        var unCheckedArray = [IZInterestModel]()
        
        for item in interests {
            if item.state == true {
                checkedArray.append(item)
            }
            if item.state == false {
                unCheckedArray.append(item)
            }
        }
        let sortedArray: [IZInterestModel] = checkedArray + unCheckedArray
        
        return sortedArray
    }
    
}

enum UIUserInterfaceIdiom : Int
{
    case unspecified
    case phone
    case pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}

