//
//  CustomPin.swift
//  GuestlogixChallenge
//
//  Created by Luiz Fernando Aquino Dias on 24/04/19.
//  Copyright © 2019 Luiz Fernando Aquino Dias. All rights reserved.
//

import UIKit
import MapKit

class CustomPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle:String, pinSubTitle:String, location:CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
    }
}
