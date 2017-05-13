//
//  IZRestAPILocationCalls.swift
//  Talki
//
//  Created by Nikita Gil on 22.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON
import ObjectMapper


class IZRestAPILocationCalls {
    
    //--------------------------------------------
    // MARK: - Current Location
    //--------------------------------------------
    
    class func currentPositionCall(_ latitude : Double,
                                 longtitude : Double ,
                                 completed:@escaping (_ statusResponse: RestStatus)-> (),
                                 failed:@escaping (String) -> ()) {
        
        let url = base_url! + IZRestAPIConstants.suffix_version + IZRestAPIConstants.suffix_set_position
        
        print(IZHelper.URL(url))
        
        let params: [String: Any] = [
            "id": IZRestAPIConstants.constant_id,
            "params": [ "lon":longtitude,  "lat":latitude]
        ]
        guard let token = IZUserDefaults.getTokenToUserDefault() as String? else {
            completed(RestStatus.failure)
            return
        }
        
        let header : [String: String] = ["Authorization" : token]
        
        defaultManager.request(IZHelper.URL(url), method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default , headers: header).validate().responseJSON { (responseData) in
            
            switch responseData.result {
            case .success:
                
                print(responseData.result)
                
                let swiftyJsonVar = JSON(responseData.result.value!)
                let status = swiftyJsonVar["result"]["status"]
                
                if status.rawString()! == IZRestAPIConstants.statusCode1 {
                    //
                    completed(RestStatus.success)
                    
                } else {
                    let errorMessage = IZErrorConverter.messageMapperError(responseData.value as AnyObject)
                    failed(errorMessage)
                }
                
            case .failure(let error):
                let errorMessage = IZErrorConverter.failureError(error as NSError)
                failed(errorMessage)
            }
        }
    }
}
