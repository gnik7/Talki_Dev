//
//  IZAlertViewManager.swift
//  Talki
//
//  Created by Nikita on 10/31/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

class IZAlertViewManager {
    
    static let sharedInstance = IZAlertViewManager()
    
    var alert : IZAlertView?
    var completion : (() -> ())?
    

    
    // MARK: - Functions for loader
//    func showView(text : String, action: (() -> ())?) {
//        
//        dispatch_async(dispatch_get_main_queue()) {
//            if UIApplication.sharedApplication().keyWindow != nil {
//                if self.alert == nil {
//                    self.alert = LoaderView.loadFromXib()
//                    self.alert?.loadView()
//                }
//                
//                self.alert?.showView()
//            }
//        }
//    }
//    
//    func hideView() {
//         self.alert?.hideView()
//    }
}
