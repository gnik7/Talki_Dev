//
//  IZInterestModel.swift
//  Talki
//
//  Created by Nikita Gil on 05.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import ObjectMapper

class  IZInterestModel : Mappable {
    
    var id          : String?
    var interest    :String?
    var state       :Bool?
    
    init() {}
    
    init(interest :String, state :Bool) {
        
        self.interest = interest
        self.state = state
    }
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        self.id         <- map["id"]
        self.interest   <- map["title"]
        self.state      <- map["selected"]
    }
}

class  IZInterestsItemsModel : Mappable {
    
    var items : [IZInterestModel]?
 
    
    init() {}
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        self.items  <- map["result.data.items"]
    }
}
