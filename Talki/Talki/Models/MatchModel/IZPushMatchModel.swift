//
//  IZPushMatchModel.swift
//  Talki
//
//  Created by Nikita Gil on 8/1/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import ObjectMapper

class IZPushMatchModel : Mappable {
    
    var items : IZPushMatchItemModel?
    
    init() {}
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        self.items  <- map["result.data.items"]
    }
}

class IZPushMatchItemModel : Mappable {
    
    var id                  : String?
    var user                : IZPushMatchUserModel?
    var lat                 : Double?
    var lon                 : Double?
    var myStatus            : String?
    var status              : String?
    var interests           : [IZInterestModel]?
    var matchTime           : String?
    var isView              : Bool?
    var isMatched           : Bool?
    
    init() {}
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        self.id             <- map["id"]
        self.user           <- map["user"]
        self.lat            <- map["lat"]
        self.lon            <- map["lon"]
        self.myStatus       <- map["my_status"]
        self.status         <- map["status"]
        self.interests      <- map["interests"]
        self.matchTime      <- map["created_at"]
        self.isView         <- map["is_view"]
        self.isMatched      <- map["is_matched"]
    }
}

class IZPushMatchUserModel : Mappable {
    
    var id                  : String?
    var name                : String?
    var role                : String?
    var gender              : String?
    var age                 : Int?
    var urlAvatar           : IZUserAvatarModel?
    var images              : [IZUserImagesModel]?
    var time                : String?
    
    init() {}
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        self.id         <- map["id"]
        self.name       <- map["name"]
        self.role       <- map["role"]
        self.gender     <- map["gender"]
        self.urlAvatar  <- map["avatar"]
        self.images     <- map["images"]
        self.age        <- map["age"]
        self.time       <- map["created_at"]
    }
}

class IZHistoryMatchModel : Mappable {
    
    var items : [IZPushMatchItemModel]?
    
    init() {}
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        self.items  <- map["result.data.items"]
    }
}

