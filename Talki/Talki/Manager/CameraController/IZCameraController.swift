//
//  IZCameraController.swift
//  Talki
//
//  Created by Nikita Gil on 04.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit
import MobileCoreServices

enum TypeButton {
    case profileTypeButton
    case additionalTypeButton
}

class IZCameraController: UIImagePickerController {
    
    var typeButton : TypeButton?
    var pathImage  : IndexPath?
    var isButtonActive = false
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.isButtonActive = false
        //UINavigationBar.appearance().translucent = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //UINavigationBar.appearance().translucent = false
        IZLoaderManager.sharedInstance.hideView()
    }
  
}
