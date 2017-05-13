//
//  IZFacebookRegister.swift
//  Talki
//
//  Created by Nikita Gil on 30.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class IZFacebookRegister {
    
    class func actionSignInFacebook(_ controller: UIViewController, response: @escaping (_ userModel: IZUserModel?) -> ()){
        
        let manager = FBSDKLoginManager()
    
        manager.logOut()
        manager.logIn(withReadPermissions: ["public_profile", "email", "user_birthday"], from: controller, handler: { (result, error) -> Void in
            
            if FBSDKAccessToken.current() != nil {
                
                //FBSDKLoginManager().loginBehavior = FBSDKLoginBehaviorWeb
                
                FBSDKGraphRequest(graphPath: "me?fields=picture.type(large),email,name,first_name,last_name,about,birthday,education,gender,hometown,location,work", parameters: nil).start(completionHandler: { (request, data, error) -> Void in
                    
                    if (error) != nil {
                        print("Process error");
                    } else if (result?.isCancelled)! {
                        print("Cancelled");
                    } else {
                        print("Logged in");
                    }
                   print(FBSDKAccessToken.current().tokenString ?? "Error")
                   IZUserDefaults.recordFBTokenInUserDefault(FBSDKAccessToken.current().tokenString)
                      response(nil)
                })
              }
            })
    }
}
