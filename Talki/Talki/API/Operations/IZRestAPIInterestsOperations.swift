//
//  IZRestAPIInterestsOperations.swift
//  Talki
//
//  Created by Nikita Gil on 22.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation

class IZRestAPIInterestsOperations {

    //--------------------------------------------
    // MARK: - List of Interest
    //--------------------------------------------

    class func interestsListCall(_ keyWord: String?,
                                 offset : Int,
                                 limit : Int ,
                                 completed:@escaping (_ responceObject : IZInterestsItemsModel?, _ statusResponse: RestStatus)-> ()) {
        
        IZRestAPIInterestsCalls.interestsListCall(keyWord , offset: offset, limit: limit,
            completed: { (responceObject, statusResponse) in

                completed(responceObject, RestStatus.success)
            }, failed: { (errorMessage) in
                if !errorMessage.isEmpty {
                    IZAlertCustomManager.sharedInstance.showView(errorMessage, text2: "")
                }
                completed(nil, RestStatus.failure)
        })
    }
    
    //--------------------------------------------
    // MARK: - Add Interest
    //--------------------------------------------
    
    class func addInterestCall(_ title : String,
                                 completed:@escaping (_ statusResponse: RestStatus)-> ()) {
        
        IZLoaderManager.sharedInstance.showView()
        
        IZRestAPIInterestsCalls.addInterestCall(title,
            completed: { (statusResponse) in
            
                IZLoaderManager.sharedInstance.hideView()
                completed(RestStatus.success)
                
            }, failed: { (errorMessage) in
                
                if !errorMessage.isEmpty {
                    IZAlertCustomManager.sharedInstance.showView(errorMessage, text2: "")
                }
                IZLoaderManager.sharedInstance.hideView()
                completed(RestStatus.failure)
        })
    }
    
    //--------------------------------------------
    // MARK: - Save Selected Interest
    //--------------------------------------------
    
    class func saveSelectedInterestCall(_ interests : [String] ,
                               completed:@escaping (_ statusResponse: RestStatus)-> ()) {
        
        IZLoaderManager.sharedInstance.showView()
        
        IZRestAPIInterestsCalls.saveInterestCall(interests, completed: { (statusResponse) in
            
            IZLoaderManager.sharedInstance.hideView()
            completed(RestStatus.success)
            
            }, failed:  { (errorMessage) in
                
                if !errorMessage.isEmpty {
                    IZAlertCustomManager.sharedInstance.showView(errorMessage, text2: "")
                }
                IZLoaderManager.sharedInstance.hideView()
                completed(RestStatus.failure)
        })
    }
    //--------------------------------------------
    // MARK: - Get News Messed Pushes
    //--------------------------------------------
    
    class func updateNewMissedPushesOperation(_ completed:@escaping (_ responceObject: IZNewMissedPushModel?)-> ()) {
        
        IZRestAPIInterestsCalls.updateNewMissedPushesCall({ (responceObject) in
            completed(responceObject)
            }, failed: { message  in
        })

    }
}
