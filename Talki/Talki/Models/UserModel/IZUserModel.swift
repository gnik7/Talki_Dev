//
//  IZUserModel.swift
//  Talki
//
//  Created by Nikita Gil on 30.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import ObjectMapper

class  IZUserModel: NSObject, NSCopying, Mappable {
    
    var id                  : String?
    var token               : String?
    var name                : String?
    var email               : String?
    var role                : String?
    var gender              : String?
    var urlAvatar           : IZUserAvatarModel?
    var birth_date          : String?
    var age                 : Int?
    var images              : [IZUserImagesModel]?
    var badgeCounter        : Int?
    var blockUsers          : [String]?
    
    override init() {}
    
    init(name :String,  email :String, gender:String, urlAvatar :IZUserAvatarModel? , birth_date :String, images :[IZUserImagesModel], role :String, id :String, token :String, blockUsers : [String]) {
        
        self.id = id
        self.token = token
        self.name = name
        self.email = email
        self.role = role
        self.gender = gender
        self.urlAvatar = urlAvatar
        self.birth_date = birth_date
        self.images = images
        self.blockUsers = [String]()
        self.blockUsers?.append(contentsOf: blockUsers)
    }
    func copy(with zone: NSZone?) -> Any {
        let copy = IZUserModel(name: name!, email: email!, gender: gender!, urlAvatar: urlAvatar!, birth_date: birth_date!, images: images!, role: role!, id: id!, token: token!, blockUsers: blockUsers!)
        return copy
    }
    
    init(name :String, gender:String, birth_date :String, avatar: String) {

        self.name = name
        self.gender = gender
        self.birth_date = birth_date
        let tmpAvatar = IZUserAvatarModel()
        tmpAvatar.full = avatar
        self.urlAvatar = tmpAvatar
    }
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        self.id             <- map["result.data.items.id"]
        self.token          <- map["result.data.items.token"]
        self.name           <- map["result.data.items.name"]
        self.email          <- map["result.data.items.email"]
        self.role           <- map["result.data.items.role"]
        self.gender         <- map["result.data.items.gender"]
        self.urlAvatar      <- map["result.data.items.avatar"]
        self.birth_date     <- map["result.data.items.birth_date"]
        self.images         <- map["result.data.items.images"]
        self.age            <- map["result.data.items.age"]
        self.badgeCounter   <- map["result.data.items.count_notification"]
        self.blockUsers     <- map["result.data.items.block_users"]
        
        guard let badge = self.badgeCounter else {
            return
        }
        UIApplication.shared.applicationIconBadgeNumber = badge
    }
    
}

class  IZUserImagesModel : Mappable {

    var full    : String?
    var preview : String?
    var key     : String?
    
    init() {
        
    }
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        self.full         <- map["full"]
        self.preview      <- map["preview"]
        self.key          <- map["key"]
    }
}

class  IZUserAvatarModel : Mappable {
    
    var full    : String?
    var preview : String?
    
    init() {
        
    }
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        self.full         <- map["full"]
        self.preview      <- map["preview"]
    }
}


class IZUserModelSingletone: NSObject, NSCopying{
    
    static let sharedInstance = IZUserModelSingletone()
    
    var user                : IZUserModel?
    var id                  : String?
    var token               : String?
    var name                : String?
    var email               : String?
    var role                : String?
    var gender              : String?
    var urlAvatar           : IZUserAvatarModel?
    var birth_date          : String?
    var age                 : Int?
    var images              : [IZUserImagesModel]?
    var blockUsers          : [String]?
    
    override init(){        
    }
    
    init(name :String,  email :String, gender:String, urlAvatar :IZUserAvatarModel? , birth_date :String, images :[IZUserImagesModel], role :String, id :String, token :String, blockUsers : [String]) {
        
        self.id = id
        self.token = token
        self.name = name
        self.email = email
        self.role = role
        self.gender = gender
        self.urlAvatar = urlAvatar
        self.birth_date = birth_date
        self.images = images
        self.blockUsers = [String]()
        self.blockUsers?.append(contentsOf: blockUsers)
    }
    func copy(with zone: NSZone?) -> Any {
        let copy = IZUserModel(name: name!, email: email!, gender: gender!, urlAvatar: urlAvatar!, birth_date: birth_date!, images: images!, role: role!, id: id!, token: token!, blockUsers: blockUsers!)
        return copy
    }

    
//    class func convertUserModelToSingletone(user: IZUserModel) {
//        IZUserModelSingletone.sharedInstance.id = user.id
//        IZUserModelSingletone.sharedInstance.token = user.token
//        IZUserModelSingletone.sharedInstance.name = user.name
//        IZUserModelSingletone.sharedInstance.email = user.email
//        IZUserModelSingletone.sharedInstance.role = user.role
//        IZUserModelSingletone.sharedInstance.gender = user.gender
//        IZUserModelSingletone.sharedInstance.birth_date = user.birth_date
//        IZUserModelSingletone.sharedInstance.age = user.age
//        
//        let avatar = IZUserAvatarModel()
//        avatar.preview = user.urlAvatar?.preview
//        avatar.full = user.urlAvatar?.full
//        IZUserModelSingletone.sharedInstance.urlAvatar = avatar
//        
//        IZUserModelSingletone.sharedInstance.images = user.images
//    }
    
}



