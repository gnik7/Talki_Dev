//
//  IZChatMessageModel.swift
//  Talki
//
//  Created by Nikita Gil on 7/28/16.
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



//*****************************************************************
// MARK: -   Singe Room Chat
//*****************************************************************

class IZSingleChatMessageModel : Mappable {
    
    var items : [IZSingleChatMessageItemModel]?
    
    init() {}
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        self.items  <- map["result.data.items"]
    }
}

class IZSingleChatMessageItemModel : NSObject, NSCopying, Mappable {
    
    var id                  : String?
    var isRead              : Bool?
    var senderId            : String?
    var recipientId         : String?
    var text                : String?
    var time                : String?
    var location            : IZSingleChatLocationModel?
    var picture             : IZSingleChatPictureModel?
    var cellType            : IZChatCellType?

    
    override init() {}
    
    init(id : String?, isRead : Bool?, senderId : String?, recipientId : String?, text: String?, time : String?,location : IZSingleChatLocationModel?, picture: IZSingleChatPictureModel?, cellType : IZChatCellType?) {
    
        self.id = id
        self.isRead = isRead
        self.senderId = senderId
        self.recipientId = recipientId
        self.text = text
        self.time = time
        self.location = location
        self.picture = picture
        self.cellType = cellType
    }
    
    func copy(with zone: NSZone?) -> Any {
        let copy = IZSingleChatMessageItemModel(id: id, isRead: isRead, senderId: senderId, recipientId: recipientId, text: text, time: time, location: location, picture: picture, cellType: cellType)
        return copy
    }
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        self.id           <- map["id"]
        self.isRead       <- map["is_read"]
        self.senderId     <- map["sender"]
        self.text         <- map["text"]
        self.time         <- map["time"]
        self.recipientId  <- map["recipient"]
        self.location     <- map["location"]
        self.picture      <- map["image"]
            
        self.cellType = self.updateTypeCell()
    }
    
    fileprivate func updateTypeCell() -> IZChatCellType {
        if !(self.text?.isEmpty)! {
            return IZChatCellType.izChatCellText
        } else if self.location?.latitude != nil || self.location?.longitude != nil  {
            return IZChatCellType.izChatCellLocation
        } else if self.picture?.full != nil || self.picture?.preview != nil {
            return IZChatCellType.izChatCellImage
        }
        return IZChatCellType.izChatCellText
    }
    
    class func convertSocketInfoToIZSingleChatMessageItemModel(_ userInfo : NSDictionary) -> IZSingleChatMessageItemModel {
        
        let item = IZSingleChatMessageItemModel()
        
        item.senderId = userInfo["sender"] as? String
        item.recipientId = userInfo["recipient"] as? String
        item.text = userInfo["text"] as? String
        item.time = userInfo["time"] as? String
        item.id = userInfo["id"] as? String
        item.cellType = IZChatCellType.izChatCellText
               
        if let coordinate = userInfo["location"] as? NSDictionary {
            if let latCoordinate = coordinate["lat"] as? Double, let longCoordinate = coordinate["lon"] as? Double {
                let location = IZSingleChatLocationModel()
                location.latitude = latCoordinate
                location.longitude = longCoordinate
                item.location = location
                item.cellType = IZChatCellType.izChatCellLocation
            }
        }
        
        if let picture = userInfo["image"] as? NSDictionary {
            if let fullImage = picture["full"] as? String, let previewImage = picture["preview"] as? String {
                let image = IZSingleChatPictureModel()
                image.full = fullImage
                image.preview = previewImage
                item.picture = image
                item.cellType = IZChatCellType.izChatCellImage
            }
        }
        return item
    }
    
    //*****************************************************************
    // MARK: - Convert 1D -> 2D array
    //*****************************************************************
    
    class func convertArrayItemsToArrayWithSection(_ simple : [IZSingleChatMessageItemModel])-> [[IZSingleChatMessageItemModel]] {
        
        var previousDate = Date()
        var array2D = [[IZSingleChatMessageItemModel]]()
        var array2DFin = [[IZSingleChatMessageItemModel]]()
        var tmpArray = [IZSingleChatMessageItemModel]()
        
        for (index, item) in simple.enumerated() {
            if index == 0 {
                tmpArray.append(item)                
                previousDate = IZHelper.convertTimeFromString(item.time!) as Date
                if simple.count == 1 {
                   array2D.append(tmpArray)
                }
            } else {
                let currentDate = IZHelper.convertTimeFromString(item.time!) as Date
                let result = IZHelper.compareDateInChat(currentDate, previousDate: previousDate)
                if result {
                    tmpArray.append(item)
                    if (index == (simple.count - 1) && array2D.count == 0){
                        array2D.append(tmpArray)
                    } else if (index == (simple.count - 1)) {
                        array2D.append(tmpArray)
                    }
                } else {
                    array2D.append(tmpArray)
                    tmpArray.removeAll()
                    tmpArray.append(item)
                    if (index == (simple.count - 1)) {
                        array2D.append(tmpArray)
                    }
                }
                previousDate = currentDate
            }
        }
        // sort to descending by date /change row places
        tmpArray.removeAll()
        if array2D.count > 0 {
            let dimention2DArray = array2D.count - 1
            
            for index in 0..<array2D.count / 2  {
                tmpArray = array2D[index]
                array2D[index] = array2D[dimention2DArray - index]
                array2D[dimention2DArray - index] = tmpArray
                tmpArray.removeAll()
            }
        }
        // sort by date in descending for sections / items in row change with places
        for index in 0..<array2D.count {
            let count = array2D[index].count / 2
            var rowArray = array2D[index]
            for i in 0..<count  {
                let tmpItem = rowArray[i]
                rowArray[i] = rowArray[array2D[index].count - 1 - i]
                rowArray[array2D[index].count - 1 - i] = tmpItem
            }
            array2DFin.append(rowArray)
            rowArray.removeAll()
        }
        
        array2D.removeAll()
        return array2DFin
    }
    
    class func compareIZSingleChatMessageItem(_ item1: String, item2 : String) -> Bool {
        
        if item1 == item2 {
            return true
        }
        
        return false
    }
}

class IZSingleChatLocationModel : Mappable {
    
    var latitude    : Double?
    var longitude   : Double?
    
    init() {
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        self.latitude  <- map["lat"]
        self.longitude  <- map["lon"]
    }
}

class IZSingleChatPictureModel : Mappable {
    
    var preview     : String?
    var full        : String?
    var key         : String?
    
    init() {}
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        self.preview    <- map["preview"]
        self.full       <- map["full"]
        self.key        <- map["key"]
    }
}

class IZSingleChatPictureItemModel : Mappable {
    
    var item     : IZSingleChatPictureModel?
    
    init() {}
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        self.item    <- map["result.data.items"]
    }
}

//*****************************************************************
// MARK: - All Chats with last message
//*****************************************************************

class IZChatMessageModel : Mappable {
    
    var items : [IZChatMessageItemModel]?
    
    init() {}
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        self.items  <- map["result.data.items"]
    }
}

class IZChatMessageItemModel : NSObject, NSCopying, Mappable {
    
    var id                  : String?
    var isRead              : Bool?
    var sender              : IZChatSenderModel?
    var text                : String?
    var time                : String?
    var recipient           : IZChatRecipientModel?
    var location            : IZSingleChatLocationModel?
    var picture             : IZSingleChatPictureModel?
    var cellType            : IZChatCellType?
    var isView              : Bool?
    
    override init() {}
    
    init(id: String?, isRead : Bool?,sender: IZChatSenderModel?, text : String?,time : String?,recipient : IZChatRecipientModel?) {
        self.id = id
        self.isRead = isRead
        self.sender = sender
        self.text = text
        self.time = time
        self.recipient = recipient
    }
    
    func copy(with zone: NSZone?) -> Any {
        let copy = IZChatMessageItemModel(id: id, isRead: isRead, sender: sender, text: text, time: time, recipient: recipient)
        return copy
    }
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        self.id           <- map["id"]
        self.isRead       <- map["is_read"]
        self.sender       <- map["sender"]
        self.text         <- map["text"]
        self.time         <- map["time"]
        self.recipient    <- map["recipient"]
        self.location     <- map["location"]
        self.picture      <- map["image"]
        self.isView       <- map["is_view"]
        
        self.cellType = self.updateTypeCell()
    }
    
    fileprivate func updateTypeCell() -> IZChatCellType {
        if !(self.text?.isEmpty)! {
            return IZChatCellType.izChatCellText
        } else if self.location?.latitude != nil || self.location?.longitude != nil  {
            return IZChatCellType.izChatCellLocation
        } else if self.picture?.full != nil || self.picture?.preview != nil {
            return IZChatCellType.izChatCellImage
        }
        return IZChatCellType.izChatCellText
    }
    
    class func convertPushMatchItemToChatMessageItem(_ pushModel : IZPushMatchItemModel, sender : IZChatSenderModel) -> IZChatMessageItemModel {
        
        let chatMessageItemModel = IZChatMessageItemModel()
        let recipient = IZChatRecipientModel()
        
        recipient.id = pushModel.user?.id
        recipient.name = pushModel.user?.name
        recipient.role = pushModel.user?.role
        recipient.gender = pushModel.user?.gender
        recipient.age = pushModel.user?.age
        recipient.avatar = pushModel.user?.urlAvatar
        recipient.images = pushModel.user?.images
        
        chatMessageItemModel.sender = sender
        chatMessageItemModel.recipient = recipient
        
        return chatMessageItemModel
    }
    
    class func convertPushSenderAndRecipientToChatMessageItem(_ recipient : IZChatRecipientModel, sender : IZChatSenderModel) -> IZChatMessageItemModel {
        
        let chatMessageItemModel = IZChatMessageItemModel()
        
        chatMessageItemModel.sender = sender
        chatMessageItemModel.recipient = recipient
        
        return chatMessageItemModel
    }

}

class IZChatSenderModel : Mappable {
    
    var id                  : String?
    var age                 : Int?
    var avatar              : IZUserAvatarModel?
    var images              : [IZUserImagesModel]?
    var gender              : String?
    var name                : String?
    var role                : String?
    
    init() {}
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        self.id             <- map["id"]
        self.age            <- map["age"]
        self.avatar         <- map["avatar"]
        self.images         <- map["images"]
        self.gender         <- map["gender"]
        self.name           <- map["name"]
        self.role           <- map["role"]
    }
    class func convertRecipientToSender(_ recipient : IZChatRecipientModel) -> IZChatSenderModel {
        let sender = IZChatSenderModel()
        sender.id = recipient.id
        sender.age = recipient.age
        sender.gender = recipient.gender
        sender.name = recipient.name
        sender.role = recipient.role
        
        let avatar = IZUserAvatarModel()
        avatar.full = recipient.avatar?.full
        avatar.preview = recipient.avatar?.preview
        sender.avatar = avatar
        
        var images = [IZUserImagesModel]()
        if recipient.images?.count > 0 {
            for item in recipient.images! {
                let image = IZUserImagesModel()
                image.full = item.full
                image.preview = item.preview
                image.key = item.key
                images.append(image)
            }
            sender.images = images
        }
        return sender
    }
}

class IZChatRecipientModel : Mappable {
    
    var id                  : String?
    var age                 : Int?
    var avatar              : IZUserAvatarModel?
    var images              : [IZUserImagesModel]?
    var gender              : String?
    var name                : String?
    var role                : String?
    
    init() {}
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        self.id             <- map["id"]
        self.age            <- map["age"]
        self.avatar         <- map["avatar"]
        self.images         <- map["images"]
        self.gender         <- map["gender"]
        self.name           <- map["name"]
        self.role           <- map["role"]
    }
    
    class func convertSenderToRecipient(_ sender : IZChatSenderModel) -> IZChatRecipientModel {
        
        let recipient = IZChatRecipientModel()
        recipient.id = sender.id
        recipient.age = sender.age
        recipient.gender = sender.gender
        recipient.name = sender.name
        recipient.role = sender.role
        
        let avatar = IZUserAvatarModel()
        avatar.full = sender.avatar?.full
        avatar.preview = sender.avatar?.preview
        recipient.avatar = avatar
        
        var images = [IZUserImagesModel]()
        if sender.images?.count > 0 {
            for item in sender.images! {
                let image = IZUserImagesModel()
                image.full = item.full
                image.preview = item.preview
                image.key = item.key
                images.append(image)
            }
            recipient.images = images
        }
        return recipient
    }
}


