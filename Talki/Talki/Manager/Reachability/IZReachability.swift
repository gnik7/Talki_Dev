//
//  IZReachability.swift
//  Talki
//
//  Created by Nikita Gil on 04.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
//import SystemConfiguration
import Alamofire

//class IZReachability {
//    
//    class func isConnectedToNetwork() -> Bool {
//        
//        
//        var zeroAddress = sockaddr_in()
//        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
//            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
//        }
//        var flags = SCNetworkReachabilityFlags()
//        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
//            return false
//        }
//        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
//        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
//        return (isReachable && !needsConnection)
//    }
//}

class IZReachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        if let status = NetworkReachabilityManager()?.isReachable {
            return status
        }
        return false
    }
}
