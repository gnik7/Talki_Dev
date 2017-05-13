//
//  RestAPIProfileCalls.swift
//  Talki
//
//  Created by Nikita Gil on 19.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON
import ObjectMapper

class IZRestAPIProfileCalls {
    
    //--------------------------------------------
    // MARK: - Get Profile
    //--------------------------------------------
    
    class func profileGetCall(_ completed:@escaping (_ responceObject : IZUserModel?, _ statusResponse: RestStatus)-> (),
                         failed:@escaping (String) -> ()) {
        
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_get_profile
        
        print(IZHelper.URL(url))
        
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": []
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
                
                print(responseData.result.value ?? "")
                
                let swiftyJsonVar = JSON(responseData.result.value!)
                let status = swiftyJsonVar["result"]["status"]
                
                if status.rawString()! == IZRestAPIConstants.statusCode1 {
                    //
                    let respObj = Mapper<IZUserModel>().map(JSON: responseData.value as! [String : Any])
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
    // MARK: - Save Profile
    //--------------------------------------------
    
    class func saveProfileCall(   _ name : String,
                                gender : String,
                                   age : String,
        completed:@escaping (_ statusResponse: RestStatus)-> (),
                              failed:@escaping (String) -> ()) {
        
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_save_profile
        
        print(IZHelper.URL(url))
        
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": [ "name":name,
                       "gender":gender,
                         "age":age]
        ]
        guard let token = IZUserDefaults.getTokenToUserDefault() as String? else {
            completed(RestStatus.failure)
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
    // MARK: - Upload Profile Image
    //--------------------------------------------
    
    class func uploadProfileImageCall(_ image : UIImage ,
                                      completed:@escaping (_ profileUrl: String? ,_ statusResponse: RestStatus)-> (),
                                  failed:@escaping (String) -> ()) {
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_upload_avatar
        
        print(IZHelper.URL(url))
        
        let imageData:Data = UIImageJPEGRepresentation(image, 0.7)!
        let imageBase64:String = imageData.base64EncodedString(options: .lineLength64Characters)
        
        let paramString = "data:image/jpeg;base64,\(imageBase64)"
        //print(paramString)
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": [ "image":paramString]
        ]
        guard let token = IZUserDefaults.getTokenToUserDefault() as String? else {
            completed(nil, RestStatus.failure)
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
                    let respObj = Mapper<IZUserModel>().map(JSON: responseData.value as! [String : Any])
                    let profileUrl = respObj?.urlAvatar?.full
                    completed(profileUrl ,RestStatus.success)
                    
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
    // MARK: - Upload Images
    //--------------------------------------------

    class func uploadImagesCall(_ images : UIImage ,
                                      completed:@escaping (_ responceObject : IZUserModel?, _ statusResponse: RestStatus)-> (),
                                      failed:@escaping (String) -> ()) {
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_upload_images
        
        print(IZHelper.URL(url))
        
        var imagesArray = [String]()
        
        let imageData:Data = UIImageJPEGRepresentation(images, 0.7)!
        let imageBase64:String = imageData.base64EncodedString(options: .lineLength64Characters)
        
        let paramString = "data:image/jpeg;base64,\(imageBase64)"
        imagesArray.append(paramString)
        
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": [ "images":imagesArray]
        ]
        guard let token = IZUserDefaults.getTokenToUserDefault() as String? else {
            completed(nil ,RestStatus.failure)
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
                    let respObj = Mapper<IZUserModel>().map(JSON: responseData.value as! [String : Any])
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
    // MARK: - Delete Images
    //--------------------------------------------
    
    class func deleteImagesCall(_ images : [String] ,
                                completed:@escaping (_ responceObject : IZUserModel?, _ statusResponse: RestStatus)-> (),
                                failed:@escaping (String) -> ()) {
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_remove_images
        
        print(IZHelper.URL(url))
        
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": [ "images":images]
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
                    let respObj = Mapper<IZUserModel>().map(JSON: responseData.value as! [String : Any])
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
