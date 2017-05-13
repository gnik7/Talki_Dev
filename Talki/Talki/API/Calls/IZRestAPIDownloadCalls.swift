//
//  IZRestAPIDownloadCalls.swift
//  Talki
//
//  Created by Nikita Gil on 06.08.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON
import ObjectMapper


class IZRestAPIDownloadCalls {

    //--------------------------------------------
    // MARK: - Download
    //--------------------------------------------
    

    class func httpGet(_ request: URLRequest!, callback: @escaping (Data?, String?) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            if error != nil {
                callback(nil , error!.localizedDescription)
            } else {
                let result = NSData(data: data!) as Data
                callback(result as Data, nil)
            }
        })
        task.resume()
    }

}
