//
//  IZRestAPIChatOperations.swift
//  Talki
//
//  Created by Nikita Gil on 7/28/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

class IZRestAPIChatOperations {
    
    //--------------------------------------------
    // MARK: - History Chats List
    //--------------------------------------------
    
    class func historyChatOperation(_ offset : Int,
                                 limit : Int ,
                                 completed:@escaping (_ responceObject : IZChatMessageModel?, _ statusResponse: RestStatus)-> ()) {
        
        IZLoaderManager.sharedInstance.showView()
        
        IZRestAPIChatCalls.historyChatsListCall(offset, limit: limit,
                                                
        completed: { (responceObject, statusResponse) in
            
            IZLoaderManager.sharedInstance.hideView()
            completed(responceObject, RestStatus.success)
            
            }, failed: { (errorMessage) in
                if !errorMessage.isEmpty {
                    IZAlertCustomManager.sharedInstance.showView(errorMessage, text2: "")
                }
                IZLoaderManager.sharedInstance.hideView()
                completed(nil, RestStatus.failure)
        })
    }

    //--------------------------------------------
    // MARK: - Chat for 1 person
    //--------------------------------------------
    
    class func singleChatMessagesOperations(_ userId : String,
                                      offset : Int,
                                      limit : Int ,
                                      completed:@escaping (_ responceObject : IZSingleChatMessageModel?, _ statusResponse: RestStatus)-> ()) {
        
        IZLoaderManager.sharedInstance.showView()
        IZRestAPIChatCalls.singleChatMessagesCall(userId, offset: offset, limit: limit, completed: { (responceObject, statusResponse) in
            
            IZLoaderManager.sharedInstance.hideView()
            completed(responceObject, RestStatus.success)
            
            }, failed: { (errorMessage) in
                if !errorMessage.isEmpty {
                    IZAlertCustomManager.sharedInstance.showView(errorMessage, text2: "")
                }
                IZLoaderManager.sharedInstance.hideView()
                completed(nil, RestStatus.failure)
        })
    }
    
    //--------------------------------------------
    // MARK: - Status Opponent online/offline
    //--------------------------------------------
    
    class func statusUserOperations(_ userId : String, completed:@escaping (_ responceObject : Bool?, _ statusResponse: RestStatus)-> ()) {
        
        IZRestAPIChatCalls.statusUserCall(userId, completed: { (responceObject, statusResponse) in         
            completed(responceObject, RestStatus.success)
            
            }, failed: { (errorMessage) in
                
                if !errorMessage.isEmpty {
                    IZAlertCustomManager.sharedInstance.showView(errorMessage, text2: "")
                }
                completed(nil, RestStatus.failure)
        })
    }
    
    //--------------------------------------------
    // MARK: - Chat upload image
    //--------------------------------------------
    
    class func uploadImageChatOperation(_ image : UIImage,
                                     responce  :@escaping (_ responceObject :IZSingleChatPictureModel?, _ restStatus: RestStatus)-> () ) {
        
        IZRestAPIChatCalls.uploadChatImageCall(image, completed: { (picture, statusResponse) in
            
            responce(picture,statusResponse)
            
            }, failed: { (errorMessage) in
                DispatchQueue.main.async() {
                    IZLoaderManager.sharedInstance.hideView()
                }
                if !errorMessage.isEmpty {
                    IZAlertCustomManager.sharedInstance.showView(errorMessage, text2: "")
                }
                responce(nil, .failure)
        })
    }
    
    //--------------------------------------------
    // MARK: - Chat remove saved chat
    //--------------------------------------------
    
    class func removeSavedChatOperation(_ userId : String, completed:@escaping ( _ statusResponse: RestStatus)-> ()) {
        
        IZRestAPIChatCalls.removeSavedChatCall(userId, completed: { ( statusResponse) in
            completed(RestStatus.success)
            
            }, failed: { (errorMessage) in
                
                if !errorMessage.isEmpty {
                    IZAlertCustomManager.sharedInstance.showView(errorMessage, text2: "")
                }
                completed(RestStatus.failure)
        })
    }
}
