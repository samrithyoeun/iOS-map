//
//  SecondViewController.swift
//  Ios Maps
//
//  Created by PM Academy 3 on 7/11/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class GMSViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 200
    var mapView: GMSMapView!
    var zoomLevel = 15.0
    var camera = GMSCameraPosition()
    static var marker = GMSMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGMS()
    }
    
    @IBAction func currentLocationButtonClicked(_ sender: Any) {
        getCurrentLocation { (result) in
            switch result {
            case .success(let currentLocation) :
                print(currentLocation)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupGMS(){
        locationManager.requestAuthorization()
        locationManager.distanceFilter = 50
        locationManager.delegate = self
        
        camera = GMSCameraPosition.camera(withLatitude: 11.576415, longitude: 104.923071, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
    }
    
    private func getCurrentLocation( callback: @escaping (Result<CLLocationCoordinate2D>) ->() ){
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            if let currentLocation = locationManager.location?.coordinate {
                callback(Result.success(currentLocation))
            } else {
                callback(Result.failure("cannot get current location"))
            }
        }
    }
}

extension GMSViewController: CLLocationManagerDelegate {
    
}
