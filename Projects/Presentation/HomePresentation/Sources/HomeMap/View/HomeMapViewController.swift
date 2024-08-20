//
//  HomeMapViewController.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 8/9/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import FlexLayout
import PinLayout
import MapKit

import BasePresentation

public final class HomeMapViewController: UIViewController {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        return mapView
    }()
    private let infoView = MapInfoView()
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    private var isSearched: Bool = false
    private var selectedAnnotation: MKAnnotation?
    
    // MARK: - Life cycle
    public static func create() -> HomeMapViewController {
        return HomeMapViewController()
    }
    
    private init() {
        super.init(nibName: nil, bundle: nil)
        locationManager.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        bindInfoView()
        setupLocationManager()
        setupLayout()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    private func checkLocationAuthorizationStatus() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Location access was restricted.")
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 5 // meters
    }
    
    private func searchForLocations(near coordinate: CLLocationCoordinate2D, query: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = query
        searchRequest.region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] response, error in
            if let error = error {
                print("🚨Error: \(error)")
                return
            }
            guard let self = self,
                  let response = response else { return }
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            for item in response.mapItems {
                let annotation = MKPointAnnotation()
                annotation.title = item.name
                annotation.subtitle = item.placemark.subtitle
                annotation.coordinate = item.placemark.coordinate
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    private func configureInfoView(_ annotation: MKPointAnnotation) {
        infoView.configure(
            title: annotation.title,
            subtitle: annotation.subtitle
        )
        UIView.animate(withDuration: 0.2) {
            self.setupSubviewLayout()
            self.infoView.flex.layout()
        }
    }
    
    private func removeInfoView() {
        UIView.animate(withDuration: 0.2) {
            self.setupSubviewLayout()
        }
    }
    
    private func findRoute(_ transportType: MKDirectionsTransportType) {
        guard let selectedAnnotation = selectedAnnotation else { return }
        mapView.removeOverlays(mapView.overlays)
        
        let destinationPlacemark = MKPlacemark(coordinate: selectedAnnotation.coordinate)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let request = MKDirections.Request()
        let currentLocation = MKMapItem.forCurrentLocation()
        request.source = currentLocation
        request.destination = destinationMapItem
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            guard let route = response?.routes.first else { return }
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
}

// MARK: - Binding
extension HomeMapViewController {
    private func bindInfoView() {
        infoView.walkButton.rx.tap
            .subscribe(onNext: {
                self.findRoute(.walking)
            })
            .disposed(by: disposeBag)
        
        infoView.vehicleButton.rx.tap
            .subscribe(onNext: {
                self.findRoute(.automobile)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - MKMapView Delegate
extension HomeMapViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "PlacePin"
        guard let annotation = annotation as? MKPointAnnotation else { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
//            // 오른쪽에 디스크로저 버튼 추가
//            let rightButton = UIButton(type: .detailDisclosure)
//            annotationView?.rightCalloutAccessoryView = rightButton
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? MKPointAnnotation else { return }
        selectedAnnotation = annotation
        configureInfoView(annotation)
    }
    
    public func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        selectedAnnotation = nil
        removeInfoView()
    }
    
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? MKPointAnnotation else { return }
        configureInfoView(annotation)
    }
    
    public func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 5.0
            return renderer
        }
        return .init()
    }
}

// MARK: - CLLocationManager Delegate
extension HomeMapViewController: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        guard isSearched == false else { return }
        isSearched = true
        mapView.setRegion(region, animated: true)
        searchForLocations(near: location.coordinate, query: "약국")
    }
}

// MARK: - Layout
extension HomeMapViewController {
    private func setupLayout() {
        view.addSubview(rootContainerView)
        rootContainerView.addSubview(mapView)
        rootContainerView.addSubview(infoView)
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all(view.safeAreaInsets)
        
        let mapViewHeight: Percent = selectedAnnotation == nil ? 100% : 60%
        let infoViewHeight: Percent = selectedAnnotation == nil ? 0% : 40%
        mapView.pin.left().top().right()
            .height(mapViewHeight)
        infoView.pin.left().right().bottom()
            .height(infoViewHeight)
    }
    
    private func updateSubviewLayout() {
        
    }
}
