//
//  CommunityViewController.swift
//  WoofAmI_Capstone
//
//  Created by Selina Cheah on 25/03/2024.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class CommunityViewController: UIViewController, MKMapViewDelegate{
    
    var mapView: MKMapView!
    var segmentedControl: UISegmentedControl!
    
    var postcode: String? {
        didSet {
            geocodePostcode()
        }
    }
    
    
    private func setupSegmentedControl(){
        segmentedControl = UISegmentedControl(items: ["Vet Nearby", "Animal Shelters"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        //customise
        segmentedControl.backgroundColor = .white
        segmentedControl.selectedSegmentTintColor = .orangeLight
        segmentedControl.isOpaque = true
        segmentedControl.overrideUserInterfaceStyle = .light
        
        let font = UIFont.systemFont(ofSize: 16)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        
        view.addSubview(segmentedControl)
    
        //constraints
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl){
        clearAnnotations()
        geocodePostcode()
    }
    
    private func clearAnnotations(){
        mapView.removeAnnotations(mapView.annotations)
    }
    
    private func getUserLocation(){
        LocationService.shared.locationUpdated = { [weak self] location in
                print("Current location: \(location)")
            self?.fetchPlaces(location: location)
        }
    }
    
    private func setupMapView(){
        mapView = MKMapView(frame: view.bounds)
        mapView.delegate = self
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        
        view.bringSubviewToFront(segmentedControl)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .white
        setupSegmentedControl()
        setupMapView()
        
        getUserLocation()
        
    }
    
    // adapted from https://stackoverflow.com/questions/38475284/how-to-get-co-ordinates-from-addresswith-postcode-swift-ios
    private func geocodePostcode(){
        guard let postcode = postcode else { return }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(postcode){[weak self] (placemarks, error) in
            guard let strongSelf = self, let location = placemarks?.first?.location else {
                print("Geocoding failed for postcode: \(postcode) with error: \(String(describing: error))")
                return
            }
            print("Geocoded Location: \(location.coordinate)")
            strongSelf.fetchPlaces(location: location.coordinate)
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        if let annotation = view.annotation{
            let placemark = MKPlacemark(coordinate: annotation.coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = annotation.title ?? "Location"
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
    
    //customise annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? MKPointAnnotation {
            let identifier = "Location"
            var view: MKMarkerAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView{
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            
            return view
        }
        return nil
    }
    
    private func fetchPlaces(location: CLLocationCoordinate2D){
        let searchSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let searchRegion = MKCoordinateRegion(center: location, span: searchSpan)
        print("Searching for places near: \(location)")
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.region = searchRegion
        searchRequest.resultTypes = .pointOfInterest
        
        //filter for vets and shelters
        if segmentedControl.selectedSegmentIndex == 0 {
            searchRequest.naturalLanguageQuery = "veterinary"
        } else {
            searchRequest.naturalLanguageQuery = "animal shelter"
        }
        
        let search = MKLocalSearch(request: searchRequest)
        
        search.start{ [weak self] response, error in
            guard let self = self, let response = response else {
                print("Search failed with error: \(String(describing: error))")
                return
            }
            
            //clear previous annotation
            self.clearAnnotations()
            
            let items = response.mapItems
            
            var annotations: [MKPointAnnotation] = []
            
            for item in items {
                let annotation = MKPointAnnotation()
                annotation.title = item.name
                annotation.coordinate = item.placemark.coordinate
                annotations.append(annotation)
            }
            
            DispatchQueue.main.async{
                self.mapView.addAnnotations(annotations)
                if !annotations.isEmpty{
                    self.mapView.showAnnotations(annotations, animated: true)
                } else {
                    self.mapView.setRegion(searchRegion, animated: true)
                    print("No results found")
                }
                
            }
            
            
        }
    }
}
