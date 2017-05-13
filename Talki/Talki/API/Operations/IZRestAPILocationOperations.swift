//
//  IZRestAPILocationOperations.swift
//  Talki
//
//  Created by Nikita Gil on 22.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import UIKit


class IZRestAPILocationOperations {

    //--------------------------------------------
    // MARK: - Current Location
    //--------------------------------------------
    

    class func currentPositionCall(_ latitude : Double,
                                 longtitude : Double ,
                                   completed:@escaping ( _ statusResponse: RestStatus)-> ()) {
        
        
        IZRestAPILocationCalls.currentPositionCall(latitude, longtitude: longtitude,
            completed: { (statusResponse) in
                
                completed(RestStatus.success)                
            }, failed: { (errorMessage) in
                
                if !errorMessage.isEmpty {
//                    let alert = IZAlertCustomWithOneButton.loadFromXib()
//                    alert?.showView(errorMessage)
                }
                completed( RestStatus.failure)
        })
    }
}
