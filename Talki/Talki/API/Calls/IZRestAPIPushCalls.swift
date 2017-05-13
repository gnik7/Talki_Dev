//
//  IZRestAPIPushCalls.swift
//  Talki
//
//  Created by Nikita Gil on 7/25/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON
import ObjectMapper

class IZRestAPIPushCalls {
    
    //--------------------------------------------
    // MARK: - Add Push Id
    //--------------------------------------------
    class func addPushIdCall(_ completed:@escaping (_ message : String?, _ statusResponse: RestStatus)-> (),
                                failed:@escaping (String) -> ()) {
        
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_add_device
        
        print(IZHelper.URL(url))
        
        guard let deviceToken = IZUserDefaults.getDevicePushTokenUserDefault() else {
            completed("Device token is absent" ,RestStatus.failure)
            return
        }
        
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": [
                "id": deviceToken
            ]
        ]
        
        guard let token = IZUserDefaults.getTokenToUserDefault() as String? else {
            completed("Token is absent", RestStatus.failure)
            return
        }
        let header : [String: String] = ["Authorization" : token]
        
        defaultManager.request(IZHelper.URL(url), method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default , headers: header).validate().responseJSON { (responseData) in
            
            switch responseData.result {
            case .success:
                
                print(responseData.result)
                
                let swiftyJsonVar = JSON(responseData.result.value!)
                let status = swiftyJsonVar["result"]["status"]
                
                if status.rawString()! == IZRestAPIConstants.statusCode1 {
                    //
                    completed(nil ,RestStatus.success)
                    
                } else {
                    let errorMessage = IZErrorConverter.messageMapperError(responseData.value as AnyObject)
                    failed(errorMessage)
                }
                
            case .failure(let error):
                let errorMessage = IZErrorConverter.failureError(error as NSError)
                failed(errorMessage)
            }
        }
    }
    
    //--------------------------------------------
    // MARK: - Remove Push Id
    //--------------------------------------------

    class func removePushIdCall(_ completed:@escaping (_ message : String?, _ statusResponse: RestStatus)-> (),
                             failed:@escaping (String) -> ()) {
        
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_remove_device
        
        print(IZHelper.URL(url))
        
        guard let deviceToken = IZUserDefaults.getDevicePushTokenUserDefault() else {
            completed("Device token is absent" ,RestStatus.failure)
            return
        }
        
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": [
                "id": deviceToken
            ]
        ]
        
        guard let token = IZUserDefaults.getTokenToUserDefault() as String? else {
            completed("Token is absent", RestStatus.failure)
            return
        }
        let header : [String: String] = ["Authorization" : token]
        
        defaultManager.request(IZHelper.URL(url), method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default , headers: header).validate().responseJSON { (responseData) in
            
            switch responseData.result {
            case .success:
                
                print(responseData.result)
                
                let swiftyJsonVar = JSON(responseData.result.value!)
                let status = swiftyJsonVar["result"]["status"]
                
                if status.rawString()! == IZRestAPIConstants.statusCode1 {
                    //
                    completed(nil ,RestStatus.success)
                    
                } else {
                    let errorMessage = IZErrorConverter.messageMapperError(responseData.value as AnyObject)
                    failed(errorMessage)
                }
                
            case .failure(let error):
                let errorMessage = IZErrorConverter.failureError(error as NSError)
                failed(errorMessage)
            }
        }
    }

}

