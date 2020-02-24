//
//  CoreLocationSession.swift
//  SchoolMapLocationFeb24thLab
//
//  Created by Margiett Gil on 2/24/20.
//  Copyright © 2020 Margiett Gil. All rights reserved.
//
import Foundation
import UIKit
import CoreLocation


class CoreLocationSession: NSObject {
    
    private var locationManger: CLLocationManager
    
    override init() {
        locationManger = CLLocationManager()
        super.init()
        locationManger.delegate = self
        locationManger.requestAlwaysAuthorization()
        locationManger.requestWhenInUseAuthorization()
        
        startSignificantLocationChanges()
        
        //startMonitoringRegion()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func startSignificantLocationChanges(){
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
          return
        }
        locationManger.startMonitoringSignificantLocationChanges()
        
    }
    
    

    
    public func convertCoordinateToPlacemark(coordinate: CLLocationCoordinate2D){
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            if let error = error {
                print("reverseGeocodeLocation error: \(error)")
            }
            if let firstPlacemark = placemark?.first{
                print("placemark info: \(firstPlacemark)")
                
            }
        }
    }
    
    public func convertPlacemarkToCoordinate(addressString: String, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> ()){
        
        CLGeocoder().geocodeAddressString(addressString) { (placemarks, error) in
            if let error = error {
                print("geocodeAddressString error: \(error)")
                completion(.failure(error))
            }
            if let firstPlacemark = placemarks?.first,
                let location = firstPlacemark.location {
                print("coordinate info: \(location.coordinate)")
                completion( .success(location.coordinate))
            }
        }
    }
    
    private func startMonitoringRegion(){
        
    
      
    }
    
}







extension CoreLocationSession: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations \(locations)")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error)")
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
        case .denied:
            print("denied")
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
        default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("didEnterRegion \(region)")
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("didExitRegion \(region)")
    }
}
