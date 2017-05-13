//
//  IZRestAPISettingsCalls.swift
//  Talki
//
//  Created by Nikita Gil on 21.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON
import ObjectMapper


class IZRestAPISettingsCalls {
    
    //--------------------------------------------
    // MARK: - Send Settings
    //--------------------------------------------
    class func settingsCall(_ notificationNewMatch        :Bool,
                            notificationMissedMatch     :Bool,
                            notificationUpdatedInterest :Bool,
                            notificationNewMessage      :Bool,
                            notificationPromotion       :Bool,
                            matchRadius                 :Int,
                            matchAgeMin                 :Int,
                            matchAgeMax                 :Int,
                            matchGender                 :String,
                            completed:@escaping (_ message : String?, _ statusResponse: RestStatus)-> (),
                                failed:@escaping (String) -> ()) {
        
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_settings
        
        print(IZHelper.URL(url))
        
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": [
                "notification_new_match": notificationNewMatch,
                "notification_missed_match": notificationMissedMatch,
                "notification_updated_interest": notificationUpdatedInterest,
                "notification_new_message": notificationNewMessage,
                "notification_promotion": notificationPromotion,
                
                "match_radius": matchRadius,
                "match_age_min": matchAgeMin,
                "match_age_max": matchAgeMax,
                
                "match_gender": matchGender
            ]
        ]
        
        guard let token = IZUserDefaults.getTokenToUserDefault() as String? else {
            completed(nil ,RestStatus.failure)
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
                    completed("Save OK" ,RestStatus.success)
                    
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
    // MARK: - Get Settings
    //--------------------------------------------
    
    class func userGetSettingsCall(_ completed:@escaping (_ responceObject: IZSettingsModel?, _ statusResponse: RestStatus)-> (),
                            failed:@escaping (String) -> ()) {
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_get_settings
        
        print(IZHelper.URL(url))
        
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": []
        ]
        
        guard let token = IZUserDefaults.getTokenToUserDefault() as String? else {
            completed(nil, RestStatus.failure)
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
                    let respObj = Mapper<IZSettingsModel>().map(JSON: responseData.value as! [String : Any])
                    completed(respObj ,RestStatus.success)
                    
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
