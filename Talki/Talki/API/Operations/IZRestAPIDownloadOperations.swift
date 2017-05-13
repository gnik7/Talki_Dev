//
//  IZRestAPIDownloadOperations.swift
//  Talki
//
//  Created by Nikita Gil on 06.08.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

class IZRestAPIDownloadOperations {
    
    //--------------------------------------------
    // MARK: - Download image
    //--------------------------------------------
    
    class func downloadImageOperations(_ url : String,
                            responceObject :@escaping (_ responceObject : UIImage?)-> ()) {
        
        let requestData = URLRequest(url: URL(string: url)!)
        
        IZRestAPIDownloadCalls.httpGet(requestData){
            (data, error) -> Void in
            if error != nil {
                print(error ?? "Error")
                IZAlertCustomManager.sharedInstance.showView(error ?? "Error", text2: "")
                responceObject(nil)
            } else {
                let image = UIImage(data: data!)
                responceObject(image)
            }
        }
    }

}

