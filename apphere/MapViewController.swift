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
        
        let url = URL(string: "mapbox://styles/apphere/cjds1dz312xl62so1erbtwmgm")
        let mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 40.336, longitude: -75.928), zoomLevel: 13.5, animated: false)
        view.addSubview(mapView)
        
    
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
