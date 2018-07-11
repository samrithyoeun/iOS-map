//
//  FirstViewController.swift
//  Ios Maps
//
//  Created by PM Academy 3 on 7/11/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit
import MapKit

class MapKitViewController: UIViewController {
    
    @IBOutlet weak var mapKitView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpMapKit()
        locationManager.requestAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            setUpDirection()
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
    
}

extension MapKitViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .red
        renderer.lineWidth = 5
        return renderer
    }
    
}
