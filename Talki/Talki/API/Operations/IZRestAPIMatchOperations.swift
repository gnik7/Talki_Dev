//
//  IZRestAPIMatchOperations.swift
//  Talki
//
//  Created by Nikita Gil on 27.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation

class IZRestAPIMatchOperations {

    //--------------------------------------------
    // MARK: - Get User by Id
    //--------------------------------------------
    
    class func matchedUserByIdOperation( _ userId : String ,responce  :@escaping (_ responceObject :IZMatchUserModel?, _ restStatus: RestStatus)-> () ) {
        
        IZLoaderManager.sharedInstance.showView()
        
        IZRestAPIMatchCalls.matchedUserByIdCall(userId, completed: { (responceObject, statusResponse) in
            
                IZLoaderManager.sharedInstance.hideView()
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
    // MARK: - Accept/Decline  Match  User
    //--------------------------------------------

    class func acceptDeclineUserOperation(_ userId : String, status : Bool,
                                     responce:@escaping (_ responceObject : IZPushMatchItemModel?, _ statusResponse: RestStatus)-> ()) {
        
        IZLoaderManager.sharedInstance.showView()
        
        IZRestAPIMatchCalls.acceptDeclineUserCall(userId, status: status, completed: { (responceObject, statusResponse) in
            
            IZLoaderManager.sharedInstance.hideView()
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
    // MARK: - Match  User from Push get interest and profile
    //--------------------------------------------
    
    class func userFromPushMatchOperation(_ userId : String,
                                     responce:@escaping (_ responceObject : IZPushMatchModel?, _ statusResponse: RestStatus)-> ()) {
        
        IZLoaderManager.sharedInstance.showView()
        IZRestAPIMatchCalls.userFromPushMatchCall(userId, completed: { (responceObject, statusResponse) in
            
            IZLoaderManager.sharedInstance.hideView()
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
    // MARK: - History Match
    //--------------------------------------------
    
    class func historyMatchOperation(_ offset : Int,
                                limit : Int ,
                                responce:@escaping (_ responceObject : IZHistoryMatchModel?, _ statusResponse: RestStatus)-> ()) {
        
        IZLoaderManager.sharedInstance.showView()
        
        IZRestAPIMatchCalls.historyMatchCall(offset, limit: limit, completed: { (responceObject, statusResponse) in
            
            IZLoaderManager.sharedInstance.hideView()
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
    // MARK: - Remove Match from match history
    //--------------------------------------------
    
    class func removeUserMatchOperation(_ matchId : String,
                                     responce:@escaping (_ responceObject : IZHistoryMatchModel?, _ statusResponse: RestStatus)-> ()) {
        
        IZLoaderManager.sharedInstance.showView()
        
        IZRestAPIMatchCalls.removeUserMatchCall(matchId, completed: { (responceObject, statusResponse) in
            IZLoaderManager.sharedInstance.hideView()
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
    // MARK: - Block Match from match history
    //--------------------------------------------
    
    class func blockUserMatchOperation(_ matchId : String,
                                        responce:@escaping (_ statusResponse: RestStatus)-> ()) {
        
        IZLoaderManager.sharedInstance.showView()
        
        IZRestAPIMatchCalls.blockUserMatchCall(matchId, completed: { (statusResponse) in
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


}
    
