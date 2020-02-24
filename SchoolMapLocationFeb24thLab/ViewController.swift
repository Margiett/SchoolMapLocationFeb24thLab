//
//  ViewController.swift
//  SchoolMapLocationFeb24thLab
//
//  Created by Margiett Gil on 2/24/20.
//  Copyright © 2020 Margiett Gil. All rights reserved.
//

import UIKit
import MapKit

//MARK: Remember to always add “NSLocationAlwaysAndWhenInUseUsageDescription” and “NSLocationWhenInUseUsageDescription” in the info.plist !!!! 

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private let locationSession = CoreLocationSession()
    private var isShowingNewAnnotations = false
    private var annotations = [MKPointAnnotation]()
    private var userTrackingButton: MKUserTrackingButton!
    
    
    private var schools = [School]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        
        userTrackingButton = MKUserTrackingButton(frame: CGRect(x: 20, y: 20, width: 40, height: 40))
        mapView.addSubview(userTrackingButton)
        userTrackingButton.mapView = mapView
        
        loadMapsView()
        loadSchools()
        makeAnnotations()
        mapView.delegate = self
    }
    
    private func loadSchools(){
        NYCSchoolsAPIClient.getSchools { [weak self] (result) in
            switch result {
            case .failure(let appError):
                print(appError)
            case .success(let schools):
                self?.schools = schools
                DispatchQueue.main.async {
                    self?.loadMapsView()
                }
            }
        }
    }
    
    private func makeAnnotations() -> [MKPointAnnotation]{
        var annotations = [MKPointAnnotation]()
        for school in schools {
            guard let latitude = Double(school.latitude), let longitude = Double(school.longitude) else {
                break 
            }
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = school.schoolName
            annotations.append(annotation)
        }
        isShowingNewAnnotations = true
        self.annotations = annotations
        return annotations
    }
    
    private func loadMapsView() {
        let annotations = makeAnnotations()
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)
    }


}

extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("\(view.annotation?.title) was selected")
        
        guard let annotation = view.annotation else { return }
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "SchoolLocationsAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as?  MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.glyphImage = UIImage(named: "school")
            annotationView?.glyphText = "Schools"
            annotationView?.markerTintColor = .systemBlue
        } else {
            annotationView?.annotation = annotation
        }
//
//        if let dequeView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
//            annotationView = dequeView
//        } else {
//            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView.canShowCallout = true
//        }
        return annotationView
    }
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        if isShowingNewAnnotations {
            mapView.showAnnotations(makeAnnotations(), animated: false)
        }
        isShowingNewAnnotations = false
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("calloutAccessoryControlTapped")
    }
}

