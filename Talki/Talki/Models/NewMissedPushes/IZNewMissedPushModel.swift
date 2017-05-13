//
//  IZNewMissedPushModel.swift
//  Talki
//
//  Created by Nikita on 11/23/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import ObjectMapper

class IZNewMissedPushModel : Mappable {

    var matches    :Bool?
    var messages   :Bool?
    
    init() {}

    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        
        self.matches   <- map["result.data.items.matches"]
        self.messages  <- map["result.data.items.messages"]
        
        self.setupindicator()
    }
    
    fileprivate func setupindicator() {
        if self.matches == true {
            IZUserDefaults.recordMissedMatch()
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: missedMathPushNotification), object: nil))
        } else {
            IZUserDefaults.cleanMissedMatch()
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: missedMathPushNotification), object: nil))
        }
        
        if self.messages == true {
            IZUserDefaults.recordMissedMessage()
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: missedMessagePushNotification), object: nil))
        } else {
            IZUserDefaults.cleanMissedMessage()
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: missedMessagePushNotification), object: nil))
        }
    }
}

