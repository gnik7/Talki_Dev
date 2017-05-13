//
//  IZRestBaseApiCall.swift
//  Talki
//
//  Created by Nikita Gil on 8/22/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation

import Alamofire
import AlamofireObjectMapper



let downloadManager: Alamofire.SessionManager = {
    
    let serverTrustPolicies: [String: ServerTrustPolicy] = [
        "": .disableEvaluation
    ]
    
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = [
        "Content-Type": "application/json"]
    configuration.timeoutIntervalForResource = 60.0
    
    return Alamofire.SessionManager(
        configuration: configuration,
        serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
    )
}()


let defaultManager: Alamofire.SessionManager = {
    let serverTrustPolicies: [String: ServerTrustPolicy] = [
        "": .disableEvaluation
    ]
    
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = [
        "Content-Type": "application/json"]
    
    return Alamofire.SessionManager(
        configuration: configuration,
        serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
    )
}()



