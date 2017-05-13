//
//  RestAPILoginOperations.swift
//  Talki
//
//  Created by Nikita Gil on 18.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation

class IZRestAPILoginOperations {
    
    //--------------------------------------------
    // MARK: - Registration
    //--------------------------------------------
    class func registrationOperation(   _ email :String,
                                        password :String,
                                        responce :@escaping (_ restStatus: RestStatus)-> () ) {
        
        IZLoaderManager.sharedInstance.showView()
        
        IZRestAPILoginCalls.registrationCall(email, password: password,
                                           completed: { (message, statusResponse) in
                                            
                                            IZLoaderManager.sharedInstance.hideView()
                                            
                                            responce(statusResponse)
            }, failed: { (errorMessage) in
                if !errorMessage.isEmpty {
                    IZAlertCustomManager.sharedInstance.showView(errorMessage, text2: "")
                }
                IZLoaderManager.sharedInstance.hideView()
                responce(.failure)
        })
        
    }
    
    //--------------------------------------------
    // MARK: - LOGIN
    //--------------------------------------------
    class func loginOperation(_ email     :String,
                              password  :String,
                              responce  :@escaping (_ responceObject :IZUserModel?, _ restStatus: RestStatus)-> () ) {
        IZLoaderManager.sharedInstance.showView()
        
        IZRestAPILoginCalls.loginCall(email, password: password,
                                    completed: { (responceObject, statusResponse) in
                                        
                                        IZLoaderManager.sharedInstance.hideView()
                                        if let user = responceObject as IZUserModel? {
                                            let token = user.token
                                            let userId = user.id
                                            IZUserDefaults.recordTokenInUserDefault(token!)
                                            IZUserDefaults.updateUserIdUserDefault(userId!)
                                        }
                                        responce(responceObject,statusResponse)
            }, failed: { (errorMessage) in
                if !errorMessage.isEmpty {
                    IZAlertCustomManager.sharedInstance.showView(errorMessage, text2: "")
                }
                IZLoaderManager.sharedInstance.hideView()
                responce(nil , .failure)
        })
    }
    
    //--------------------------------------------
    // MARK: - Forgot Password
    //--------------------------------------------
    
    class func forgotPasswordOperation(   _ email :String,
                                          responce :@escaping (_ message :String? ,_ restStatus: RestStatus)-> () ) {
        
        IZLoaderManager.sharedInstance.showView()
        
        IZRestAPILoginCalls.forgotPasswordCall(email, completed: { (message, statusResponse) in
            
            IZLoaderManager.sharedInstance.hideView()
            responce(message,statusResponse)
            
            }, failed: { (errorMessage) in
                if !errorMessage.isEmpty {
                    IZAlertCustomManager.sharedInstance.showView(errorMessage, text2: "")
                }
                IZLoaderManager.sharedInstance.hideView()
                responce(errorMessage, .failure)
        })
    }
    
    //--------------------------------------------
    // MARK: - Facebook login
    //--------------------------------------------
    
    class func facebookOperation( _ responce  :@escaping (_ responceObject :IZUserModel?, _ restStatus: RestStatus)-> () ) {
        
        IZLoaderManager.sharedInstance.showView()
        
        IZRestAPILoginCalls.facebookCall({ (responceObject, statusResponse) in
            
            IZLoaderManager.sharedInstance.hideView()
            if let user = responceObject as IZUserModel? {
                let token = user.token
                let userId = user.id
                IZUserDefaults.recordTokenInUserDefault(token!)
                IZUserDefaults.updateUserIdUserDefault(userId!)
            }
            responce(responceObject,statusResponse)
            
            }, failed: { (errorMessage) in
                if !errorMessage.isEmpty {
                    IZAlertCustomManager.sharedInstance.showView(errorMessage, text2: "")
                }
                IZLoaderManager.sharedInstance.hideView()
                responce(nil , .failure)
        })
        
    }
    
    //--------------------------------------------
    // MARK: - Delete account
    //--------------------------------------------
    
    class func deleteAccountOperation(_ responce :@escaping (_ message :String? ,_ restStatus: RestStatus)-> () ) {
        
        IZLoaderManager.sharedInstance.showView()
        IZRestAPILoginCalls.deleteAccountCall({ (message, statusResponse) in
            IZLoaderManager.sharedInstance.hideView()
            responce(message,statusResponse)
            }, failed: { (errorMessage) in
                if !errorMessage.isEmpty {
                    IZAlertCustomManager.sharedInstance.showView(errorMessage, text2: "")
                }
                IZLoaderManager.sharedInstance.hideView()
                responce(errorMessage, .failure)
        })
    }    
}
