//
//  RestAPIProfileOperations.swift
//  Talki
//
//  Created by Nikita Gil on 19.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import UIKit

class IZRestAPIProfileOperations {

    //--------------------------------------------
    // MARK: - Get Profile
    //--------------------------------------------

    class func profileGetOperation(_ responce  :@escaping (_ responceObject :IZUserModel?, _ restStatus: RestStatus)-> () ) {
        
        //IZLoaderManager.sharedInstance.showView()
        
        IZRestAPIProfileCalls.profileGetCall({ (responceObject, statusResponse) in
            
            //IZLoaderManager.sharedInstance.hideView()
            
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
    // MARK: - Save Profile
    //--------------------------------------------
    
    class func saveProfileOperation(_ name : String,
                                    gender : String,
                                    age : String,
        responce  :@escaping (_ restStatus: RestStatus)-> () ) {
        
        IZLoaderManager.sharedInstance.showView()
        
        IZRestAPIProfileCalls.saveProfileCall(name, gender: gender.lowercased(), age: age, completed: { (statusResponse) in
            
            IZLoaderManager.sharedInstance.hideView()
            responce(.success)
            
            }, failed: { (errorMessage) in
                if !errorMessage.isEmpty {
                    IZAlertCustomManager.sharedInstance.showView(errorMessage, text2: "")
                }
                IZLoaderManager.sharedInstance.hideView()
                responce(.failure)
        })
    }
    
    //--------------------------------------------
    // MARK: - Upload Profile Image
    //--------------------------------------------
    
    class func uploadProfileImageOperation(_ image : UIImage,
                                    responce  :@escaping (_ profileUrl: String? ,_ restStatus: RestStatus)-> () ) {
        
        IZLoaderManager.sharedInstance.showView()
        
        IZRestAPIProfileCalls.uploadProfileImageCall(image, completed: { (url,statusResponse) in
            
            IZLoaderManager.sharedInstance.hideView()
            responce(url, .success)
            
            }, failed: { (errorMessage) in
                if !errorMessage.isEmpty {
                    IZAlertCustomManager.sharedInstance.showView(errorMessage, text2: "")
                }
                IZLoaderManager.sharedInstance.hideView()
                responce(nil, .failure)
        })
    }
    
    //--------------------------------------------
    // MARK: - Upload Images in Collection
    //--------------------------------------------
    
    class func uploadImagesOperation(_ images : UIImage,
                                           responce  :@escaping (_ responceObject :IZUserModel?, _ restStatus: RestStatus)-> () ) {
        IZLoaderManager.sharedInstance.showView()
        
        IZRestAPIProfileCalls.uploadImagesCall(images, completed: { (responceObject, statusResponse) in
            
            IZLoaderManager.sharedInstance.hideView()
            responce(responceObject,statusResponse)
            
            }, failed: { (errorMessage) in
                if !errorMessage.isEmpty {
                    IZAlertCustomManager.sharedInstance.showView(errorMessage, text2: "")
                }
                IZLoaderManager.sharedInstance.hideView()
                responce(nil, .failure)
        })
    }

    
    //--------------------------------------------
    // MARK: - Delete Images in Collection
    //--------------------------------------------
    
    class func deleteImagesOperation(_ images : [String],
                                     responce  :@escaping (_ responceObject :IZUserModel?, _ restStatus: RestStatus)-> () ) {      
        
        IZLoaderManager.sharedInstance.showView()
        
        IZRestAPIProfileCalls.deleteImagesCall(images, completed: { (responceObject, statusResponse) in
            
            IZLoaderManager.sharedInstance.hideView()
            responce(responceObject,statusResponse)
            
            }, failed: { (errorMessage) in
                if !errorMessage.isEmpty {
                    IZAlertCustomManager.sharedInstance.showView(errorMessage, text2: "")
                }
                IZLoaderManager.sharedInstance.hideView()
                responce(nil,.failure)
        })
    }



}

