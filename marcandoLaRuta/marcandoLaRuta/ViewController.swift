//
//  ViewController.swift
//  marcandoLaRuta
//
//  Created by Mael on 12/5/16.
//  Copyright © 2016 Mael T. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var typeMap: UISegmentedControl!
    
    private let manejador = CLLocationManager()
    
    
    
    private var initialPoint: CLLocation? = nil
    private var actualPoint: CLLocation? = nil
    private var distance: Double = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.distanceFilter = 50.0
        manejador.requestWhenInUseAuthorization()
        
        if manejador.location?.coordinate != nil {
            initialPoint = CLLocation(latitude: (manejador.location?.coordinate.latitude)!, longitude: (manejador.location?.coordinate.longitude)!)
            actualPoint = CLLocation(latitude: (manejador.location?.coordinate.latitude)!, longitude: (manejador.location?.coordinate.longitude)!)
            
            distance = 0.00
            
            var point = CLLocationCoordinate2D()
            point.latitude = (manejador.location?.coordinate.latitude)!
            point.longitude = (manejador.location?.coordinate.longitude)!
            
            let pin = MKPointAnnotation()
            pin.title = "Lon: \(round(point.latitude * 100) / 100), Lat: \(round(point.longitude * 100) / 100)"
            pin.subtitle = "Initial point"
            pin.coordinate = point
            map.addAnnotation(pin)
            
        }
        self.centerMap()
        self.addPin()
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse{
            manejador.startUpdatingLocation()
            map.showsUserLocation = true
        }else{
            manejador.stopUpdatingLocation()
            map.showsUserLocation = false
        }
    }
    
    func centerMap(){
        if manejador.location?.coordinate != nil {
            
            if initialPoint == nil {
                initialPoint = CLLocation(latitude: (manejador.location?.coordinate.latitude)!, longitude: (manejador.location?.coordinate.longitude)!)
                actualPoint = CLLocation(latitude: (manejador.location?.coordinate.latitude)!, longitude: (manejador.location?.coordinate.longitude)!)
                
                distance = 0.00
                
                var point = CLLocationCoordinate2D()
                point.latitude = (manejador.location?.coordinate.latitude)!
                point.longitude = (manejador.location?.coordinate.longitude)!
                
                let pin = MKPointAnnotation()
                pin.title = "Lon: \(round(point.latitude * 100) / 100), Lat: \(round(point.longitude * 100) / 100)"
                pin.subtitle = "Initial point"
                pin.coordinate = point
                map.addAnnotation(pin)
            }
            
            let center = CLLocationCoordinate2D(latitude: (manejador.location?.coordinate.latitude)!, longitude: (manejador.location?.coordinate.longitude)!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004))
            
            self.map.setRegion(region, animated: true)
        }
        
    }
    
    func addPin(){
        if manejador.location?.coordinate != nil {
            
            var point = CLLocationCoordinate2D()
            point.latitude = (manejador.location?.coordinate.latitude)!
            point.longitude = (manejador.location?.coordinate.longitude)!
            
            let dist = abs(round(Double((manejador.location?.distanceFromLocation(actualPoint!))!) * 100) / 100)
            
            if (dist > 1.0){
                distance += dist
                actualPoint = CLLocation(latitude: (manejador.location?.coordinate.latitude)!, longitude: (manejador.location?.coordinate.longitude)!)
                let pin = MKPointAnnotation()
                pin.title = "Lon: \(round(point.latitude * 100) / 100), Lat: \(round(point.longitude * 100) / 100)"
                pin.subtitle = "Distance: \(distance)m"
                pin.coordinate = point
                map.addAnnotation(pin)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.centerMap()
        self.addPin()
        
        
    }
    
    
    @IBAction func selectMap(sender: UISegmentedControl) {
        
        switch typeMap.selectedSegmentIndex
        {
        case 0:
            map.mapType = MKMapType.Standard
            view.backgroundColor = UIColor(red: 157/255.0, green: 221/255.0, blue: 233/255.0, alpha: 1.0)

        case 1:
            map.mapType = MKMapType.Satellite
            view.backgroundColor = UIColor(red: 153/255.0, green: 247/255.0, blue: 159/255.0, alpha: 1.0)

        case 2:
            map.mapType = MKMapType.Hybrid
            view.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 125/255.0, alpha: 0.7)

        default:
            break;
        }
    }
    
}


