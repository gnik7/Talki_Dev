//
//  ChatAnnotation.swift
//  Talki
//
//  Created by Nikita on 11/21/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit
import MapKit

class IZChatAnnotation: NSObject, MKAnnotation {
    
    //let imageName: String
    let name: String
    let coordinate: CLLocationCoordinate2D
    
    init(name: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.coordinate = coordinate
        
        super.init()
    }
    
}
