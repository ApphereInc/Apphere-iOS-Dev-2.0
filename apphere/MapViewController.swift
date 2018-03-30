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
        
        mapView = MGLMapView(frame: .zero, styleURL: styleUrl)
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        mapView.setCenter(centerLocation, zoomLevel: zoomLevel, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func mapTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        let point = gestureRecognizer.location(in: mapView)
        
        let features = mapView.visibleFeatures(at: point, styleLayerIdentifiers: Set(["apphere-businesses"]))
        
        if let feature = features.first, let idString = feature.attribute(forKey: "ID") as? String, let id = Int(idString) {
            BusinessDetailViewController.show(id: id, viewController: self)
        }
    }
    
    var mapView: MGLMapView!
    let styleUrl = URL(string: "mapbox://styles/apphere/cjds1dz312xl62so1erbtwmgm")!
    let centerLocation = CLLocationCoordinate2D(latitude: 40.336, longitude: -75.928)
    let zoomLevel = 13.5
}
