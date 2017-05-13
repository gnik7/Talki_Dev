//
//  IZRestAPIChatCalls.swift
//  Talki
//
//  Created by Nikita Gil on 7/28/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON
import ObjectMapper


class IZRestAPIChatCalls {

    
    //--------------------------------------------
    // MARK: - History Chats List
    //--------------------------------------------
    
    class func historyChatsListCall(_ offset : Int,
                                 limit : Int ,
                                 completed:@escaping (_ responceObject : IZChatMessageModel?, _ statusResponse: RestStatus)-> (),
                                 failed:@escaping (String) -> ()) {
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_last_messages_chat
        
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
                    let respObj = Mapper<IZChatMessageModel>().map(JSON: responseData.value as! [String : Any])
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
    // MARK: - Chat for 1 person
    //--------------------------------------------

    class func singleChatMessagesCall(_ userId : String,
                                      offset : Int,
                                       limit : Int ,
                                    completed:@escaping (_ responceObject : IZSingleChatMessageModel?, _ statusResponse: RestStatus)-> (),
                                    failed:@escaping (String) -> ()) {
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_messages_chat
        
        print(IZHelper.URL(url))
        
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": [ "user_id" : userId ,"offset":offset,  "limit":limit]
        ]
        guard let token = IZUserDefaults.getTokenToUserDefault() as String? else {
            completed(nil ,RestStatus.failure)
            return
        }
        
        let header : [String: String] = ["Authorization" : token]
        
        defaultManager.request(IZHelper.URL(url), method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default , headers: header).validate().responseJSON { (responseData) in
            
            switch responseData.result {
            case .success:
                
                print(responseData.result.value)
                
                let swiftyJsonVar = JSON(responseData.result.value!)
                let status = swiftyJsonVar["result"]["status"]
                
                if status.rawString()! == IZRestAPIConstants.statusCode1 {
                    //
                    let respObj = Mapper<IZSingleChatMessageModel>().map(JSON:responseData.value as! [String : Any])
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
    // MARK: - Status Opponent online/offline
    //--------------------------------------------
    
    class func statusUserCall(_ userId : String, completed:@escaping (_ responceObject : Bool?, _ statusResponse: RestStatus)-> (),
                                failed:@escaping (String) -> ()) {
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_get_user_status_chat
        
        print(IZHelper.URL(url))
        
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": [ "user_id" : userId ]
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
                    if let userStatus = swiftyJsonVar["result"]["data"]["items"]["online"].bool as Bool? {
                        completed(userStatus ,RestStatus.success)
                    }
                    
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
    // MARK: - Chat upload image
    //--------------------------------------------
    
    class func uploadChatImageCall(_ image : UIImage ,
                                   completed:@escaping (_ responceObject : IZSingleChatPictureModel?, _ statusResponse: RestStatus)-> (),
                                      failed:@escaping (String) -> ()) {
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_upload_image_chat
        
        print(IZHelper.URL(url))
        
        let imageData:Data = UIImageJPEGRepresentation(image, 0.7)!
        let imageBase64:String = imageData.base64EncodedString(options: .lineLength64Characters)
        
        let paramString = "data:image/jpeg;base64,\(imageBase64)"
        
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": ["image":paramString]
        ]
        guard let token = IZUserDefaults.getTokenToUserDefault() as String? else {
            completed(nil,RestStatus.failure)
            return
        }
        
        let header : [String: String] = ["Authorization" : token]
        
        downloadManager.request(IZHelper.URL(url), method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default , headers: header).validate().responseJSON { (responseData) in
            
            switch responseData.result {
            case .success:
                
                print(responseData.result)
                
                let swiftyJsonVar = JSON(responseData.result.value!)
                let status = swiftyJsonVar["result"]["status"]
                
                if status.rawString()! == IZRestAPIConstants.statusCode1 {
                    //
                    let respObj = Mapper<IZSingleChatPictureItemModel>().map(JSON: responseData.value as! [String : Any])
                    completed(respObj?.item ,RestStatus.success)
                    
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
    // MARK: - Chat remove saved chat
    //--------------------------------------------

    class func removeSavedChatCall(_ userId : String, completed:@escaping (_ statusResponse: RestStatus)-> (),
                              failed:@escaping (String) -> ()) {
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_remove_dialog_chat
        
        print(IZHelper.URL(url))
        
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": [ "user_id" : userId ]
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
