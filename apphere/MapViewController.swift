//
//  ApphereMapViewController.swift
//  apphere
//
//  Created by Derek Sheldon on 12/18/17.
//  Copyright © 2017 Derek Sheldon. All rights reserved.
//

import Mapbox
import Pulsator

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
        BeaconMonitor.shared.listeners.append(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (UIApplication.shared.delegate as! AppDelegate).shouldShowViewOnBeaconEvent = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (UIApplication.shared.delegate as! AppDelegate).shouldShowViewOnBeaconEvent = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func mapTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        let point = gestureRecognizer.location(in: mapView)
        
        let features = mapView.visibleFeatures(at: point, styleLayerIdentifiers: Set(["apphere-businesses"]))
        
        if let id = features.first?.id {
            BusinessDetailViewController.show(id: id, viewController: self)
        }
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        let view = MGLAnnotationView(annotation: annotation, reuseIdentifier: "business")
        view.layer.addSublayer(pulsator())
        return view
    }
    
    var mapView: MGLMapView!
    let styleUrl = URL(string: "mapbox://styles/apphere/cjds1dz312xl62so1erbtwmgm")!
    let centerLocation = CLLocationCoordinate2D(latitude: 40.336, longitude: -75.928)
    let zoomLevel = 13.5
    
    private func pulsator() -> Pulsator {
        let pulsator = Pulsator()
        pulsator.repeatCount       = 1
        pulsator.numPulse          = 1
        pulsator.radius            = 30.0
        pulsator.animationDuration = 1.0
        pulsator.backgroundColor   = UIColor.white.cgColor
        return pulsator
    }
}

extension MapViewController: BeaconMonitorListener {
    func entered(business: Business) {
        let features = mapView.visibleFeatures(in: view.bounds, styleLayerIdentifiers: Set(["apphere-businesses"]))
        
        if let feature = features.first(where: { $0.id == business.id} ) as? MGLPointFeature {
            mapView.addAnnotation(feature)
            
            if let view = mapView.view(for: feature), let pulsator = view.layer.sublayers?.first as? Pulsator {
                pulsator.start()
            }
        }
    }
    
    func exited(business: Business) {}
    func monitoringFailed(error: NSError) {}
}

extension MGLFeature {
    var id: Int {
        if let idString = attribute(forKey: "ID") as? String, let id = Int(idString) {
            return id
        }
        
        return -1
    }
}
