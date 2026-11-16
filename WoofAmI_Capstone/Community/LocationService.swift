//
//  LocationService.swift
//  WoofAmI_Capstone
//
//  Created by Selina Cheah on 25/03/2024.
//
//reference: https://www.youtube.com/watch?v=YCmZayf7Zi4

import Foundation
import CoreLocation

class LocationService: NSObject {
    
    static let shared = LocationService()
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        return manager
    }()
    
    var locationUpdated: ((CLLocationCoordinate2D) -> Void)?
    
    override private init() {
        super.init()
        self.requestPermissionToAccessLocation()
    }
    
    func requestPermissionToAccessLocation() {
        switch locationManager.authorizationStatus{
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
}

// delegate
extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager) {
        switch manager.authorizationStatus{
        case .authorizedAlways:
            manager.startUpdatingLocation()
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            print("error with location authorization change")
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate{
            print(location)
            locationManager.stopUpdatingLocation()
            locationUpdated?(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
