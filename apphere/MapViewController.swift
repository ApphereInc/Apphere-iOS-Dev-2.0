//
//  ApphereMapViewController.swift
//  apphere
//
//  Created by Derek Sheldon on 12/18/17.
//  Copyright © 2017 Derek Sheldon. All rights reserved.
//
import Mapbox

class MapViewController: UIViewController, MGLMapViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MGLMapView(frame: .zero, styleURL: styleUrl)
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        mapView.setCenter(readingPennsylvaniaLocation, zoomLevel: zoomLevel, animated: false)
        
        let annotations = BusinessDirectory.businesses.map { business -> MGLPointAnnotation in
            let annotation = MGLPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: business.location.0, longitude: business.location.1)
            return annotation
        }
        
        mapView.addAnnotations(annotations)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let styleUrl = URL(string: "mapbox://styles/apphere/cjds1dz312xl62so1erbtwmgm")!
    let readingPennsylvaniaLocation = CLLocationCoordinate2D(latitude: 40.336, longitude: -75.928)
    let zoomLevel = 13.5
}
