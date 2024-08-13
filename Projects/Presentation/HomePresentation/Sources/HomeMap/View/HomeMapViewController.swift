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

public final class HomeMapViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let rootContainerView = UIView()
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        return mapView
    }()
    private let infoView = UIView()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    private var isSearched: Bool = false
    
    // MARK: - Life cycle
    public static func create(with reactor: HomeMapReactor) -> HomeMapViewController {
        let viewController = HomeMapViewController()
        viewController.reactor = reactor
        return viewController
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
    
    public func bind(reactor: HomeMapReactor) {
        bindAction(reactor)
        bindState(reactor)
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
    
    private func configureInfoView(_ item: MKMapItem) {
        
    }
    
    private func findRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let existingOverlays = mapView.overlays
        mapView.removeOverlays(existingOverlays)
        
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { [weak self] response, error in
            if let error = error {
                print("🚨Error: \(error)")
                return
            }
            guard let self = self,
                  let response = response else { return }
            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
        }
    }
}

// MARK: - Bind
extension HomeMapViewController {
    private func bindAction(_ reactor: HomeMapReactor) {
        
    }
    
    private func bindState(_ reactor: HomeMapReactor) {
        
    }
}

// MARK: - MKMapView Delegate
extension HomeMapViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "PlacePin"
        
        if annotation is MKPointAnnotation {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
//                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                annotationView?.image = UIImage(named: "pin_image") // 핀 이미지 설정
//                
//                // 제목 레이블 추가
//                let titleLabel = UILabel()
//                titleLabel.backgroundColor = UIColor.white.withAlphaComponent(0.8)
//                titleLabel.textColor = .black
//                titleLabel.textAlignment = .center
//                titleLabel.font = UIFont.systemFont(ofSize: 12)
//                
//                annotationView?.addSubview(titleLabel)
                
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.addSubview(infoView)
                infoView.backgroundColor = .orange.withAlphaComponent(0.5)
                
                // 오른쪽에 디스크로저 버튼 추가
                let rightButton = UIButton(type: .detailDisclosure)
                annotationView?.rightCalloutAccessoryView = rightButton
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
        
        return nil
    }
    
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? MKPointAnnotation {
            let sourceCoordinate = mapView.userLocation.coordinate
            let destinationCoordinate = annotation.coordinate
            findRoute(from: sourceCoordinate, to: destinationCoordinate)
        }
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
        
        rootContainerView.flex.define { rootView in
            rootView.addItem(mapView)
            rootView.addItem(infoView)
        }
    }
    
    private func setupSubviewLayout() {
        rootContainerView.pin.all(view.safeAreaInsets)
        rootContainerView.flex.layout()
    }
    
    private func updateSubviewLayout() {
        
    }
}
