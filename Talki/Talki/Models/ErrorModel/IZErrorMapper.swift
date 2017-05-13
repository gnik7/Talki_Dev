//
//  IZErrorMapper.swift
//  Talki
//
//  Created by Nikita Gil on 18.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import ObjectMapper


class IZErrorDataMapper : Mappable {
    
    var error : [IZErrorMapper]?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        self.error    <- map["result.data.error"]
    }
}

class IZErrorMapper : Mappable {
    
    
    var code        :String?
    var message       :String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        self.code       <- map["code"]
        self.message    <- map["message"]
    }
}

class IZErrorMessageMapper : Mappable {
    
    var message       :String?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        self.message    <- map["result.message"]
    }
}
