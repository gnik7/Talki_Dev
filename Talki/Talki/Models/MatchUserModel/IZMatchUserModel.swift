//
//  IZMatchUserModel.swift
//  Talki
//
//  Created by Nikita Gil on 12.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import ObjectMapper
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



class IZMatchUserModel : Mappable {
    
    var id                  : String?
    var name                : String?
    var role                : String?
    var gender              : String?
    var urlAvatar           : IZUserAvatarModel?
    var age                 : Int?
    var images              : [IZUserImagesModel]?
    var interests           : [IZInterestModel]?
    
    init() {}
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        self.id         <- map["result.data.items.id"]
        self.name       <- map["result.data.items.name"]
        self.role       <- map["result.data.items.role"]
        self.gender     <- map["result.data.items.gender"]
        self.urlAvatar  <- map["result.data.items.avatar"]
        self.images     <- map["result.data.items.images"]
        self.age        <- map["result.data.items.age"]
        self.interests  <- map["result.data.items.interests"]
    }
    
    class func convertMatchUserToChatSender(_ user : IZMatchUserModel) -> IZChatSenderModel {
        
        let chatModel = IZChatSenderModel()
        chatModel.id = user.id
        chatModel.name = user.name
        chatModel.role = user.role
        chatModel.gender = user.gender
        chatModel.avatar = user.urlAvatar
        chatModel.images = user.images
        chatModel.age = user.age
        return chatModel
    }
    
    class func convertMatchUserToChatRecipient(_ user : IZMatchUserModel) -> IZChatRecipientModel {
        
        let chatModel = IZChatRecipientModel()
        chatModel.id = user.id
        chatModel.name = user.name
        chatModel.role = user.role
        chatModel.gender = user.gender
        chatModel.avatar = user.urlAvatar
        chatModel.images = user.images
        chatModel.age = user.age
        return chatModel
    }
    
    class func convertMatchUserToIZPushMatchItemModel(_ user : IZMatchUserModel) -> IZPushMatchItemModel {
        
        let item = IZPushMatchItemModel()
        
        let userMatch = IZPushMatchUserModel()
        userMatch.id = user.id
        userMatch.name = user.name
        userMatch.role = user.role
        userMatch.gender = user.gender
        userMatch.age = user.age
        
        let avatar = IZUserAvatarModel()
        avatar.full = user.urlAvatar?.full
        avatar.preview = user.urlAvatar?.preview
    
        userMatch.urlAvatar = avatar
        var imagesArray = [IZUserImagesModel]()
        if user.images?.count > 0 {
            for itemImage in user.images! {
                imagesArray.append(itemImage)
            }
        }
        userMatch.images = imagesArray
        
        item.user = userMatch
        
        var interestArray = [IZInterestModel]()
        if user.interests?.count > 0 {
            for interestItem in user.interests! {
                interestArray.append(interestItem)
            }
        }
        item.interests = interestArray
        
        return item
    }

    
}


