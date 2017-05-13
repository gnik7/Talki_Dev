//
//  IZErrorConverter.swift
//  Talki
//
//  Created by Nikita Gil on 10/6/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class IZErrorConverter {
    
    static func messageMapperError(_ requestResult: AnyObject) -> String{
       
        let respObj = Mapper<IZErrorDataMapper>().map(JSON: requestResult as! [String : Any])
        if let errorArray = respObj?.error as [IZErrorMapper]? {
            var errorString = ""
            for item in errorArray {
                errorString += item.message! + "  "
            }
            if !errorString.isEmpty{
                return errorString
            }
        }
        
        if let message = Mapper<IZErrorMessageMapper>().map(JSONObject: requestResult)   {
            if let mess = message.message as String? {
                return mess
            }
        }
        return AlertTitle.Error.rawValue
    }
    
    static func failureError(_ error: NSError) -> String {
        
        if let info = error.userInfo["NSLocalizedDescription"] as? String {
            if info != "cancelled" {
                return info
            }
        } else if let info = error.userInfo["NSLocalizedFailureReason"] as? String {
            if info != "cancelled" {
                return info
            }
        } else {
            return error.description
        }
        return error.description
    }
    
}
