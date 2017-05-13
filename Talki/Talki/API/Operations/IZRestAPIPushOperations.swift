//
//  IZRestAPIPushOperations.swift
//  Talki
//
//  Created by Nikita Gil on 7/25/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation

class IZRestAPIPushOperations {
    
    //--------------------------------------------
    // MARK: - Add Push Id
    //--------------------------------------------
    
    class func addPushIdOperation(_ responce :@escaping (_ message :String? ,_ restStatus: RestStatus)-> () ) {
        
        IZLoaderManager.sharedInstance.showView()
        
        IZRestAPIPushCalls.addPushIdCall( {(message, statusResponse) in
            
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
    // MARK: - Remove Push Id
    //--------------------------------------------
    
    class func removePushIdOperation(_ responce :@escaping (_ message :String? ,_ restStatus: RestStatus)-> () ) {
        
        IZLoaderManager.sharedInstance.showView()
        
        IZRestAPIPushCalls.removePushIdCall( {(message, statusResponse) in
            
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
