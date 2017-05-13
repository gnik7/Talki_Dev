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
    case success
    case failure
}

// Go to info.plist for switching DEV/LIVE
let base_url = NSDictionary(dictionary: Bundle.main.infoDictionary!).object(forKey: "API_URL") as? String
let socket_url = NSDictionary(dictionary: Bundle.main.infoDictionary!).object(forKey: "Socket_URL") as? String


struct IZRestAPIConstants {
    
    //Status Code
    static let statusCode0 = "0"
    static let statusCode1 = "1"

    
    
    //main
    static let suffix_version = "/api/"
    
    //Login
    static let suffix_register          = "register"
    static let suffix_login             = "login"
    static let suffix_fb                = "fb"
    static let suffix_forgot            = "forgot"
    static let suffix_delete_account    = "delete_account"
    
    
    //profile
    static let suffix_get_profile   = "get_profile"
    static let suffix_save_profile  = "save_profile"
    static let suffix_upload_avatar = "upload_avatar"
    static let suffix_upload_images = "upload_images"
    static let suffix_remove_images = "remove_images"
    
    //settings
    static let suffix_settings          = "settings"
    static let suffix_get_settings      = "get_settings"
    
    //interests
    static let suffix_interests     = "interests"
    static let suffix_add_interest  = "add_interest"
    static let suffix_set_interests = "set_interests"
    
    //location
    static let suffix_set_position  = "set_position"
    
    //push notification
    static let suffix_add_device     = "add_device"
    static let suffix_remove_device  = "remove_device"
    
    
    //matches
    static let suffix_get_user_match  = "get_user"
    static let suffix_accept_match    = "accept_match"
    static let suffix_decline_match   = "decline_match"
    static let suffix_match           = "match"
    static let suffix_matches         = "matches"
    static let suffix_remove_match    = "remove_match"
    static let suffix_block_user_match = "block_user"
    
    
    //chats
    static let suffix_last_messages_chat    = "last_messages"  // screen chats
    static let suffix_messages_chat         = "messages"       // screen chat whith 1 oponent
    static let suffix_get_user_status_chat  = "get_user_status"
    static let suffix_upload_image_chat     = "upload_image"
    static let suffix_remove_dialog_chat    = "remove_dialog"
    
    //news
    static let suffix_missed_new_pushes    = "check_new"
    
    static let constant_id = "12"
}
