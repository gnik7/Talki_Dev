//
//  IZLoaderManager.swift
//  ShakerApp
//
//  Created by Nikita Gil on 21.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

class IZLoaderManager {
    
    static let sharedInstance = IZLoaderManager()
    
    var loader : IZLoaderView?
    
    
    // MARK: - Functions for loader
    func showView() {
        
        DispatchQueue.main.async {
            if UIApplication.shared.keyWindow != nil {
                if self.loader == nil {
                    self.loader = IZLoaderView.loadFromXib()
                    self.loader?.loadView()
                }
                
                self.loader?.showView()
            }
        }
    }
    
    func hideView() {
        
        DispatchQueue.main.async {
            self.loader?.hideView()
        }
    }

    
}
