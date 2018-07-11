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
import SwiftyJSON

class GMSViewController: UIViewController {
    
    @IBOutlet weak var currentLocationButton: UIButton!
    
    static var marker = GMSMarker()
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 200
    let destination = CLLocation(latitude: 37.796950, longitude: -122.394996)
    var currentLocation: CLLocationCoordinate2D?
    var mapView: GMSMapView!
    var zoomLevel = 15.0
    var camera = GMSCameraPosition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGMS()
        setDirection()
    }
    
    @IBAction func currentLocationButtonClicked(_ sender: Any) {
        getCurrentLocation { (result) in
            switch result {
            case .success(let currentLocation) :
                print(currentLocation)
                let marker = GMSMarker(position: currentLocation)
                marker.title = "You are here"
                marker.map = self.mapView
                self.camera = GMSCameraPosition(target: currentLocation, zoom: 15, bearing: 60, viewingAngle: 90)
                self.mapView.animate(to: self.camera)
                self.mapView.selectedMarker = marker
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setDirection(){
        let source = CLLocation(latitude: 37.747608, longitude: -122.411985)
        let dest = CLLocation(latitude: 37.757645, longitude: -122.439963)
        self.drawPath(from: source, to: dest, in: self.mapView)
    }
    
    private func getCurrentLocation(callback: @escaping (Result<CLLocationCoordinate2D>) ->() ){
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            if let currentLocation = locationManager.location?.coordinate {
                callback(Result.success(currentLocation))
            } else {
                callback(Result.failure("cannot get current location"))
            }
        }
    }
    
    private func setupGMS(){
        locationManager.requestAuthorization()
        locationManager.distanceFilter = 50
        locationManager.delegate = self
        
        camera = GMSCameraPosition.camera(withLatitude: 11.576415, longitude: 104.923071, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), camera: camera)
        view.addSubview(mapView)
        view.addSubview(currentLocationButton)
        
    }
    
    private func drawPath(from startLocation: CLLocation, to endLocation: CLLocation, in mapView: GMSMapView) {
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        let endpoint = "origin=\(origin)&destination=\(destination)&mode=driving&key=\(Config.key)"
        APIRequest.get(endPoint: endpoint) { (json, code, error) in
            let json = JSON(json)
            print("JSON: \(json)")
            let routes = json["routes"].arrayValue
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 5
                polyline.strokeColor = UIColor.red
                polyline.map = mapView
                mapView.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: polyline.path!), withPadding: 10))
            }
        }
    }
    
}

extension GMSViewController: CLLocationManagerDelegate {
    
}
