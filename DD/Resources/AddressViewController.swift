//
//  AddressViewController.swift
//  DD
//
//  Created by Madhan Padmanabhan on 1/7/17.
//  Copyright © 2017 madhan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddressViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let pin = MKPointAnnotation()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            
            self.mapView.showsUserLocation = true
        }
    }
    
    //MARK: <CLLocationManagerDelegate>
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        manager.stopUpdatingLocation()
        self.updateAddress(location: location)
        self.mapView.setRegion(region, animated: true)
        self.pin.coordinate = location.coordinate
        self.mapView.addAnnotation(self.pin)
    }
    
    func updateAddress(location:CLLocation) {
        DispatchQueue.global(qos: .background).async {

        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks:[CLPlacemark]?, error:Error?) -> Void in
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks![0]
                DispatchQueue.main.async {
                    self.addressLabel.text = self.streetAddress(placemark: pm)
                }
            } else {
                print("Problem with the data received from geocoder")
            }
        })
        }
    }
    
    func streetAddress(placemark: CLPlacemark) -> String {
        let street = placemark.addressDictionary?["Street"] as? String ?? ""
        return street
    }
}
