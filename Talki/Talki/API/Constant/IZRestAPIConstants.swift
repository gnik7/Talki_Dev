//
//  RestAPIConstants.swift
//  Talki
//
//  Created by Nikita Gil on 18.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation


/**
 Rest Status
 - Success: result success
 - Failure: result failure
 */
enum RestStatus {
    case Success
    case Failure
}

// Go to info.plist for switching DEV/LIVE
let base_url = NSDictionary(dictionary: NSBundle.mainBundle().infoDictionary!).objectForKey("API_URL") as? String



struct RestAPIConstants {
    
    //Status Code
    static let statusCode0 = "0"
    static let statusCode1 = "1"

    
    
    //main
    static let suffix_version = "/api/"
    
    //Login
    static let suffix_register      = "register"
    static let suffix_login         = "login"
    static let suffix_fb            = "fb"
    static let suffix_forgot        = "forgot"
    
    static let suffix_get_profile   = "get_profile"
    
    

    static let constant_id = "12"
}