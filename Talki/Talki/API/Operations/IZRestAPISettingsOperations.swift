//
//  IZRestAPISettingsOperations.swift
//  Talki
//
//  Created by Nikita Gil on 21.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation

class IZRestAPISettingsOperations {

    
    //--------------------------------------------
    // MARK: - Settings
    //--------------------------------------------
    class func settingsOperation( _ notificationNewMatch        :Bool,
                                  notificationMissedMatch     :Bool,
                                  notificationUpdatedInterest :Bool,
                                  notificationNewMessage      :Bool,
                                  notificationPromotion       :Bool,
                                  matchRadius                 :Int,
                                  matchAgeMin                 :Int,
                                  matchAgeMax                 :Int,
                                  matchGender                 :String,
                                  responce :@escaping (_ message : String?, _ restStatus: RestStatus)-> () ) {
        
        IZLoaderManager.sharedInstance.showView()
        
        IZRestAPISettingsCalls.settingsCall(notificationNewMatch,
                                            notificationMissedMatch: notificationMissedMatch,
                                            notificationUpdatedInterest: notificationUpdatedInterest,
                                            notificationNewMessage: notificationNewMessage,
                                            notificationPromotion: notificationPromotion,
                                            matchRadius: matchRadius,
                                            matchAgeMin: matchAgeMin,
                                            matchAgeMax: matchAgeMax,
                                            matchGender: matchGender,
            completed: { (message, statusResponse) in
                
                IZLoaderManager.sharedInstance.hideView()
                responce(message,statusResponse)
                
            }, failed:  { (errorMessage) in
                if !errorMessage.isEmpty {
                    IZAlertCustomManager.sharedInstance.showView(errorMessage, text2: "")
                }
                IZLoaderManager.sharedInstance.hideView()
                responce(nil,.failure)
        })
        
    }

    
    //--------------------------------------------
    // MARK: - Get Settings
    //--------------------------------------------
    
    class func userGetSettingsOperation(_ responce:@escaping (_ responceObject: IZSettingsModel?, _ statusResponse: RestStatus)-> ()) {
        
        IZLoaderManager.sharedInstance.showView()
        IZRestAPISettingsCalls.userGetSettingsCall({ (responceObject, statusResponse) in
            
            IZLoaderManager.sharedInstance.hideView()
            responce(responceObject, RestStatus.success)
            
            }, failed: { (errorMessage) in
                if !errorMessage.isEmpty {
                    IZAlertCustomManager.sharedInstance.showView(errorMessage, text2: "")
                }
                IZLoaderManager.sharedInstance.hideView()
                responce(nil,RestStatus.failure)
 
        })
        
    }

}
