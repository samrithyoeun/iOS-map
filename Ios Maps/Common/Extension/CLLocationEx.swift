//
//  CLLocation.swift
//  Ios Maps
//
//  Created by PM Academy 3 on 7/12/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation
import MapKit

extension CLLocation {
    func getCLLocationCoordinate2D() -> CLLocationCoordinate2D{
        return CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
    }
    
}
