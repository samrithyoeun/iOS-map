//
//  FirstViewController.swift
//  Ios Maps
//
//  Created by PM Academy 3 on 7/11/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import Polyline

class MapKitViewController: UIViewController {
    
    @IBOutlet weak var mapKitView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpMapKit()
        locationManager.requestAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            let bayonMarket = CLLocation(latitude: 11.570886, longitude: 104.916407)
            let phnomPenhAirport = CLLocation(latitude: 11.552773, longitude: 104.844473)
            setDrivingDirection(from: bayonMarket, to: phnomPenhAirport, in: mapKitView)
        }
    }
    
    @IBAction func currentLocationButtonTapped(_ sender: UIButton) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.updateLocation()
            let currentLocation = locationManager.location?.coordinate
            if let currentLocation = currentLocation {
                CLLocationManager.zoomTo(location: currentLocation, in: mapKitView)
            } else {
                print("cannot get current location")
            }
        }
        
    }
    
    private func setUpMapKit(){
        mapKitView.delegate = self
        mapKitView.showsScale = true
        mapKitView.showsPointsOfInterest = true
        mapKitView.showsUserLocation = true
        locationManager.requestAuthorization()
    }
    
    private func setUpDirection(){
        let sourceLocation = CLLocationCoordinate2DMake(37.747608, -122.411985)
        let destinationLoacation = CLLocationCoordinate2DMake(37.757645, -122.439963)
        
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.coordinate = sourceLocation
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.coordinate = destinationLoacation
        
        mapKitView.addAnnotation(sourceAnnotation)
        mapKitView.addAnnotation(destinationAnnotation)
        
        locationManager.getDirection(from: sourceLocation, to: destinationLoacation) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let response):
                print("sucess")
                let route = response.routes[0]
                self.mapKitView.add(route.polyline, level: .aboveLabels)
                let rect = route.polyline.boundingMapRect
                self.mapKitView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            }
        }
    }
    
    private func setDrivingDirection(from startLocation: CLLocation, to endLocation: CLLocation, in mapView: MKMapView) {
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
                let polyline = Polyline(encodedPolyline: points!)
                let decodedLocations: [CLLocationCoordinate2D]? = polyline.coordinates
                let mkPolyline = MKPolyline(coordinates: decodedLocations!, count: (decodedLocations?.count)!)
                self.mapKitView.add(mkPolyline, level: .aboveLabels)
                
                let sourceAnnotation = MKPointAnnotation()
                sourceAnnotation.coordinate = startLocation.getCLLocationCoordinate2D()
                
                let destinationAnnotation = MKPointAnnotation()
                destinationAnnotation.coordinate = endLocation.getCLLocationCoordinate2D()
                
                mapView.addAnnotation(sourceAnnotation)
                mapView.addAnnotation(destinationAnnotation)
                let rect = mkPolyline.boundingMapRect
                self.mapKitView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            }
        }
    }
    
}

extension MapKitViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .red
        renderer.lineWidth = 5
        return renderer
    }
    
}
