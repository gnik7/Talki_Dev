//
//  IZRestAPIInterestsCalls.swift
//  Talki
//
//  Created by Nikita Gil on 22.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON
import ObjectMapper


class IZRestAPIInterestsCalls {

    //--------------------------------------------
    // MARK: - List of Interest
    //--------------------------------------------
    
    class func interestsListCall(_ keyWord: String?,
                                 offset : Int,
                                  limit : Int ,
                               completed:@escaping (_ responceObject : IZInterestsItemsModel?, _ statusResponse: RestStatus)-> (),
                                failed:@escaping (String) -> ()) {
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_interests
        
        print(IZHelper.URL(url))
        
        var params: [String: Any]!
        
        if let key = keyWord as String? {
            params = [
                "id": IZRestAPIConstants.constant_id,
                "params": [ "offset":offset,  "limit":limit, "q":key]
            ]
        } else {
            params = [
                "id": IZRestAPIConstants.constant_id,
                "params": [ "offset":offset,  "limit":limit]
            ]
        }
        
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
                    let respObj = Mapper<IZInterestsItemsModel>().map(JSON: responseData.value as! [String : Any])
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

    //--------------------------------------------
    // MARK: - Add Interest
    //--------------------------------------------
    
    
    class func addInterestCall(_ title : String ,completed:@escaping (_ statusResponse: RestStatus)-> (),
                                 failed:@escaping (String) -> ()) {
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_add_interest
        
        print(IZHelper.URL(url))
        
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": [ "title":title]
        ]
        guard let token = IZUserDefaults.getTokenToUserDefault() as String? else {
            completed(RestStatus.failure)
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
                    completed(RestStatus.success)
                    
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
    // MARK: - Save Selected Interest
    //--------------------------------------------
    
    
    class func saveInterestCall(_ interests : [String] ,completed:@escaping (_ statusResponse: RestStatus)-> (),
                               failed:@escaping (String) -> ()) {
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_set_interests
        
        print(IZHelper.URL(url))
        
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": [ "interests" : interests]
        ]
        guard let token = IZUserDefaults.getTokenToUserDefault() as String? else {
            completed(RestStatus.failure)
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
                    completed(RestStatus.success)
                    
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
    // MARK: - Get News Messed Pushes
    //--------------------------------------------
    
    class func updateNewMissedPushesCall(_ completed:@escaping (_ responceObject: IZNewMissedPushModel?)-> (),
                               failed:@escaping (String) -> ()) {
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_missed_new_pushes
        
        print(IZHelper.URL(url))
        
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": []
        ]
        
        guard let token = IZUserDefaults.getTokenToUserDefault() as String? else {
            completed(nil)
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
                    let respObj = Mapper<IZNewMissedPushModel>().map(JSON: responseData.value as! [String : Any])
                    completed(respObj)
                    
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

