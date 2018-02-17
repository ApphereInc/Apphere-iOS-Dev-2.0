//
//  ApphereMapViewController.swift
//  apphere
//
//  Created by Derek Sheldon on 12/18/17.
//  Copyright © 2017 Derek Sheldon. All rights reserved.
//
import Mapbox

class MapViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "mapbox://styles/apphere/cjdr4qknl22qz2rqmlg3zvmdb")
        let mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 40.336, longitude: -75.928), zoomLevel: 13.1, animated: false)
        view.addSubview(mapView)
        
        
        let hello = MGLPointAnnotation()
        hello.coordinate = CLLocationCoordinate2D(latitude: 40.336, longitude: -75.928)
        hello.title = "Hello Reading"
        hello.subtitle = "It's automagical"
        
        // Add marker `hello` to the map.
        mapView.addAnnotation(hello)
    }
    
    // Use the default marker. See also: our view annotation or custom marker examples.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
        
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
