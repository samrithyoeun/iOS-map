//
//  Extension.swift
//  Ios Maps
//
//  Created by PM Academy 3 on 7/11/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation
import MapKit

extension CLLocationManager {
   
    func requestAuthorization(){
        requestAlwaysAuthorization()
        requestWhenInUseAuthorization()
    }
    
    func updateLocation(){
        desiredAccuracy = kCLLocationAccuracyBest
        startUpdatingLocation()
    }
    
    func getDirection(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, callback: @escaping (Result<MKDirectionsResponse>) ->() ) {
        
        let sourcePlaceMark = MKPlacemark(coordinate: source)
        let destinationPlaceMark = MKPlacemark(coordinate: destination)
        
        let sourceItem = MKMapItem(placemark: sourcePlaceMark)
        let destinationItem = MKMapItem(placemark: destinationPlaceMark)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceItem
        directionRequest.destination = destinationItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    callback(Result.failure(error.localizedDescription))
                }
                return
            }
            callback(Result.success(response))
        }
    }
    
    static func zoomTo(location: CLLocationCoordinate2D, in mapview: MKMapView)
    {
        let viewRegion = MKCoordinateRegionMakeWithDistance(location, 200, 200)
        mapview.setRegion(viewRegion, animated: true)
    }
}
