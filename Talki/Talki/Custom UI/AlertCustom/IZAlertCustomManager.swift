//
//  IZAlertCustomManager.swift
//  Talki
//
//  Created by Nikita Gil on 31.10.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

class IZAlertCustomManager {
    
    // MARK: - SINGLETON
    static let sharedInstance = IZAlertCustomManager()    
    var alert : IZAlertCustom?
    
    // MARK: - Functions for loader
    func showView(_ text1 : String, text2 : String) {
        
        DispatchQueue.main.async {
            if UIApplication.shared.keyWindow != nil {
                if self.alert == nil {
                    self.alert = IZAlertCustom.loadFromXib()
                    self.alert?.loadView()
                }
                
                self.alert?.updateData(text1, text2: text2)
                self.alert?.showView()
            }
        }
    }
    
    func hideView() {
        self.alert?.hideView()
    }
}

