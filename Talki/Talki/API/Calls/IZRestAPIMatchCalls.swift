//
//  IZRestAPIMatchCalls.swift
//  Talki
//
//  Created by Nikita Gil on 27.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON
import ObjectMapper

class IZRestAPIMatchCalls {
    
    //--------------------------------------------
    // MARK: - Mathed User by id
    //--------------------------------------------
    class func matchedUserByIdCall(_ userId : String,
        completed:@escaping (_ responceObject : IZMatchUserModel?, _ statusResponse: RestStatus)-> (),
                             failed:@escaping (String) -> ()) {

        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_get_user_match
        
        print(IZHelper.URL(url))
        
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": ["user_id" : userId]
        ]
        guard let token = IZUserDefaults.getTokenToUserDefault() as String? else {
            completed(nil ,RestStatus.failure)
            return
        }
        print(token)
        
        let header : [String: String] = ["Authorization" : token]
        
        defaultManager.request(IZHelper.URL(url), method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default , headers: header).validate().responseJSON { (responseData) in
            
            switch responseData.result {
            case .success:
                
                print(responseData.result)
                
                let swiftyJsonVar = JSON(responseData.result.value!)
                let status = swiftyJsonVar["result"]["status"]
                
                if status.rawString()! == IZRestAPIConstants.statusCode1 {
                    //
                    let respObj = Mapper<IZMatchUserModel>().map(JSON: responseData.value as! [String : Any])
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
    // MARK: - Accept/Decline  Match  User 
    //--------------------------------------------

    class func acceptDeclineUserCall(_ userId : String, status : Bool,
                                   completed:@escaping (_ responceObject : IZPushMatchItemModel?, _ statusResponse: RestStatus)-> (),
                                   failed:@escaping (String) -> ()) {
        
        
        var url = base_url! + IZRestAPIConstants.suffix_version 
        
        if status {
            url +=  IZRestAPIConstants.suffix_accept_match
        } else {
            url +=  IZRestAPIConstants.suffix_decline_match
        }
        
        print(IZHelper.URL(url))
        
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": ["match_id" : userId]
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
                    let respObj = Mapper<IZPushMatchItemModel>().map(JSON: responseData.value as! [String : Any])
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
    // MARK: - Match  User from Push get interest and profile
    //--------------------------------------------
    
    class func userFromPushMatchCall(_ userId : String,
                                     completed:@escaping (_ responceObject : IZPushMatchModel?, _ statusResponse: RestStatus)-> (),
                                     failed:@escaping (String) -> ()) {
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_match
        
        print(IZHelper.URL(url))
        
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": ["match_id" : userId]
        ]
        guard let token = IZUserDefaults.getTokenToUserDefault() as String? else {
            completed(nil ,RestStatus.failure)
            return
        }
        print(token)
        
        let header : [String: String] = ["Authorization" : token]

        defaultManager.request(IZHelper.URL(url), method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default , headers: header).validate().responseJSON { (responseData) in
            
            switch responseData.result {
            case .success:
                
                print(responseData.result)
                
                let swiftyJsonVar = JSON(responseData.result.value!)
                let status = swiftyJsonVar["result"]["status"]
                
                if status.rawString()! == IZRestAPIConstants.statusCode1 {
                    //
                    let respObj = Mapper<IZPushMatchModel>().map(JSON: responseData.value as! [String : Any])
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
    // MARK: - History Match
    //--------------------------------------------
    
    class func historyMatchCall(_ offset : Int,
                                limit : Int ,
                                completed:@escaping (_ responceObject : IZHistoryMatchModel?, _ statusResponse: RestStatus)-> (),
                                     failed:@escaping (String) -> ()) {
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_matches
        
        print(IZHelper.URL(url))
        
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": [ "offset":offset,  "limit":limit]
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
                    let respObj = Mapper<IZHistoryMatchModel>().map(JSON: responseData.value as! [String : Any])
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
    // MARK: - Remove Match from match history
    //--------------------------------------------
    
    class func removeUserMatchCall(_ matchId : String,
                                     completed:@escaping (_ responceObject : IZHistoryMatchModel?, _ statusResponse: RestStatus)-> (),
                                     failed:@escaping (String) -> ()) {
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_remove_match
        
        print(IZHelper.URL(url))
        
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": ["match_id" : matchId]
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
                    let respObj = Mapper<IZHistoryMatchModel>().map(JSON: responseData.value as! [String : Any])
                    completed(respObj ,RestStatus.success)
                    
                } else {
                    let errorMessage = IZErrorConverter.messageMapperError(responseData.value as AnyObject)
                    failed(errorMessage)
                }
                
            case .failure(let error):
                let errorMessage = IZErrorConverter.failureError(error as NSError)
                failed(errorMessage)
            }        }
    }
    
    //--------------------------------------------
    // MARK: - Block Match from match history
    //--------------------------------------------
    
    class func blockUserMatchCall(_ user_id : String,
                                   completed:@escaping (_ statusResponse: RestStatus)-> (),
                                   failed:@escaping (String) -> ()) {
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_block_user_match
        
        print(IZHelper.URL(url))
        
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": ["user_id" : user_id]
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


}
