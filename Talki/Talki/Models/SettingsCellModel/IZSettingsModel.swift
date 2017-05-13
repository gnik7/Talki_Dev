//
//  IZSettingsModel.swift
//  Talki
//
//  Created by Nikita Gil on 02.08.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import ObjectMapper

class IZSettingsModel : Mappable {
    
    var notificationNewMatch            : Bool?
    var notificationMissedMatch         : Bool?
    var notificationUpdatedInterest     : Bool?
    var notificationNewMessage          : Bool?
    var matchRadius                     : Int?
    var matchAgeMin                     : Int?
    var matchAgeMax                     : Int?
    var matchGender                     : String?
    
    init() {}
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        self.notificationNewMatch           <- map["result.data.items.notification_new_match"]
        self.notificationMissedMatch        <- map["result.data.items.notification_missed_match"]
        self.notificationUpdatedInterest    <- map["result.data.items.notification_updated_interest"]
        self.notificationNewMessage         <- map["result.data.items.notification_new_message"]
        self.matchRadius                    <- map["result.data.items.match_radius"]
        self.matchAgeMin                    <- map["result.data.items.match_age_min"]
        self.matchAgeMax                    <- map["result.data.items.match_age_max"]
        self.matchGender                    <- map["result.data.items.match_gender"]
  
    }
}
