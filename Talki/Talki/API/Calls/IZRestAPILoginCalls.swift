//
//  RestAPILoginCalls.swift
//  Talki
//
//  Created by Nikita Gil on 18.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON
import ObjectMapper

class IZRestAPILoginCalls {
 
    //--------------------------------------------
    // MARK: - Registration
    //--------------------------------------------
    class func registrationCall(_ email   :String,
                                password:String,
                                completed:@escaping (_ message : String?, _ statusResponse: RestStatus)-> (),
                                failed:@escaping (String) -> ()) {
        
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_register
        
        print(IZHelper.URL(url))
        
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id ,
            "params": [
                "email": email,
                "password": password
            ]
        ]
        
        defaultManager.request(IZHelper.URL(url), method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default , headers: nil).validate().responseJSON { (responseData) in
            
            switch responseData.result {
            case .success:
                
                print(responseData.result)
                
                let swiftyJsonVar = JSON(responseData.result.value!)
                let status = swiftyJsonVar["result"]["status"]
                
                if status.rawString()! == IZRestAPIConstants.statusCode1 {
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
    // MARK: - Login
    //--------------------------------------------
    
    class func loginCall(_ email   :String,
                         password:String,
                         completed:@escaping (_ responceObject : IZUserModel?, _ statusResponse: RestStatus)-> (),
                         failed:@escaping (String) -> ()) {
        
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_login
        
        print(IZHelper.URL(url))
        
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": [
                "email": email,
                "password": password
            ]
        ]
        
        defaultManager.request(IZHelper.URL(url), method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default , headers: nil).validate().responseJSON { (responseData) in
            
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
    // MARK: - Forgot Password
    //--------------------------------------------
    
    
    class func forgotPasswordCall(_ email   :String,
                                  completed:@escaping (_ message : String?, _ statusResponse: RestStatus)-> (),
                                  failed:@escaping (String) -> ()) {
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_forgot
        
        print(IZHelper.URL(url))
        
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": [
                "email": email
            ]
        ]
        
        defaultManager.request(IZHelper.URL(url), method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default , headers: nil).validate().responseJSON { (responseData) in
            
            switch responseData.result {
            case .success:
                
                print(responseData.result)
                
                let swiftyJsonVar = JSON(responseData.result.value!)
                let status = swiftyJsonVar["result"]["status"]
                
                if status.rawString()! == IZRestAPIConstants.statusCode1 {
                    //
                    if let message = swiftyJsonVar["result"]["message"].rawString() as String? {
                        completed(message ,RestStatus.success)
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
    // MARK: - Facebook login
    //--------------------------------------------
    class func facebookCall(_ completed:@escaping (_ responceObject : IZUserModel?, _ statusResponse: RestStatus)-> (),
                            failed:@escaping (String) -> ()) {
        
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_fb
        
        print(IZHelper.URL(url))
        
        guard let token = IZUserDefaults.getFBTokenToUserDefault() as String? else {            
            completed(nil ,RestStatus.failure)
            return
        }
        
        print(token)
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": [
                "token": token
            ]
        ]
        
        defaultManager.request(IZHelper.URL(url), method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default , headers: nil).validate().responseJSON { (responseData:  DataResponse<Any>) in
            
            switch responseData.result {
            case .success:
                
                print(responseData)
                
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
    // MARK: - Delete account
    //--------------------------------------------
    
    class func deleteAccountCall(_ completed:@escaping (_ message : String?, _ statusResponse: RestStatus)-> (),
                             failed:@escaping (String) -> ()) {
        
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_delete_account
        
        print(IZHelper.URL(url))
        
       
        
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": [ ]
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
