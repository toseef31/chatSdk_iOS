//
//  locationVC.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 27/05/2022.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
import SwiftUI

struct locationModel {
    var locImage:UIImage?
    var location: CLLocationCoordinate2D?
}

protocol addLocationDelegate {
    func addLocation(locImage:UIImage, location: CLLocationCoordinate2D)
}

class LocationVC: UIViewController{
    
    var delegate: addLocationDelegate?
    
    var navBarView: UIView?
    var mapView: UIView?
    var currentLocationView: CurrentLocationView?
    var nearByTitle: UILabel?
    var tblNearLocation: UITableView?
    
    
    var locationLabel1: UILabel?
    var locationLabel2: UILabel?
    var locationImage: UIImageView?
    var backImage: UIImageView?
    var titleName: UILabel?
    
    
    var placesClient = GMSPlacesClient.shared()
    var likeHoodList: GMSPlaceLikelihoodList?
    var googleMap = GMSMapView()
    let locationManager = CLLocationManager()
    var currentLocation : GMSAddress?
    var updateLoactionClosure: ((CLLocationCoordinate2D,UIImage) -> Void)?
    var loadAddress = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addTapGesture()
        currentLocationView?.isHidden = true
        Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { (tim) in
            self.currentLocationView?.isHidden = false
        }
        checkLocationPermission()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        googleMap = GMSMapView (frame: self.mapView!.bounds)
        googleMap.settings.compassButton = true
        googleMap.isMyLocationEnabled = true
        googleMap.settings.myLocationButton = true
        googleMap.settings.compassButton = true
        googleMap.delegate = self
        mapView!.addSubview(self.googleMap)
        
    }
    
    func initializedControls(){
        view.backgroundColor = .white
        configureTableView()
        navBarView = {
            let view = UIView(backgroundColor: AppColors.primaryColor)
            
            let title = UILabel(title: "Location", fontColor: AppColors.secondaryColor, alignment: .center, font: UIFont.font(.Poppins, type: .Regular, size: 14))
            
            let btnBack = MoozyActionButton(image: UIImage(systemName: "arrow.backward"), foregroundColor: AppColors.secondaryColor, backgroundColor: UIColor.clear,imageSize: backButtonSize) {
                print("Back")
                self.dismiss(animated: true, completion: nil)
            }
            
            view.addMultipleSubViews(views: title, btnBack)
            
            btnBack.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 8, bottom: 14, right: 0), size: backButtonSize)
            
            title.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
            title.verticalCenterWith(withView: btnBack)
            
            return view
        }()
        
        mapView = UIView(backgroundColor: .white)
        
        currentLocationView = CurrentLocationView(font: UIFont.font(.Poppins, type: .Regular, size: 12))
        
        nearByTitle = UILabel(title: "Nearby places", fontColor: .black, alignment: .left, font: UIFont.font(.Poppins, type: .Regular, size: 14))
    }
    
    func configureUI(){
        initializedControls()
        
        view.addMultipleSubViews(views: navBarView!, mapView!, currentLocationView!, nearByTitle!, tblNearLocation!)
        
        navBarView?.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        navBarView?.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12).isActive = true
        
        mapView?.anchor(top: navBarView?.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: view.frame.height/2.3))
        
        currentLocationView?.anchor(top: mapView?.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        currentLocationView?.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10).isActive = true
        
        nearByTitle?.anchor(top: currentLocationView?.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 0))
        
        tblNearLocation?.anchor(top: nearByTitle?.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    //MARK: --Configure TableView--
    func configureTableView(){
        tblNearLocation = UITableView()
        tblNearLocation?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tblNearLocation?.delegate = self
        tblNearLocation?.dataSource = self
        tblNearLocation?.backgroundColor = .clear
        tblNearLocation?.separatorStyle = .none
        tblNearLocation?.keyboardDismissMode = .onDrag
        tblNearLocation?.showsVerticalScrollIndicator = false
        tblNearLocation?.allowsMultipleSelectionDuringEditing = true
    }
    
    func addTapGesture(){
        currentLocationView?.addTapGesture(tagId: 0, action: { [self] _ in
            print("Share Current Location")
            if currentLocation != nil{
                googleMap.settings.myLocationButton = false
                googleMap.settings.compassButton = false
                let img = getLocationImage()!
                let location = currentLocation?.coordinate
                shareLocation(locImage: img, location: location!)
            }
        })
    }
    
    func checkLocationPermission(){
        if CLLocationManager.locationServicesEnabled() {
            
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func shareLocation(locImage:UIImage, location: CLLocationCoordinate2D){
        print(location.latitude)
        print(location.longitude)
//        self.pop(animated: true)
////        self.dismiss(animated: true, completion: nil)
//        DispatchQueue.main.asyncAfter(deadline: .now()+1.0, execute: {
//            let location = locationModel(locImage: locImage, location: location)
//
//            NotificationCenter.default.post(name: .selectLocation, object: nil, userInfo: ["location": location])
//
////            NotificationCenter.default.post(name: .selectLocation, object: nil, userInfo: ["select": location ])
//        })
        self.dismiss(animated: true){
            self.pop(animated: true)
            let locations = locationModel(locImage: locImage, location: location)
            
            self.delegate?.addLocation(locImage: locImage, location: location)
            
          //  NotificationCenter.default.post(name: .selectLocation, object: nil, userInfo: ["location": locations ])
           // self.updateLoactionClosure?(location, locImage ?? #imageLiteral(resourceName: "UserEdit"))
        }
    }
    
    func getLocationImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(mapView!.frame.size, false, UIScreen.main.scale)
        mapView?.drawHierarchy(in: mapView!.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (image != nil) {
            return image!
        }
        return UIImage()
    }
}

extension LocationVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(likeHoodList)
        print(likeHoodList?.likelihoods.count ?? 0)
        
        
        if likeHoodList != nil {
            if likeHoodList?.likelihoods.count ?? 0 > 0{
                return likeHoodList?.likelihoods.count ?? 0
            }else{
                return 0
            }
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = self.likeHoodList?.likelihoods[indexPath.row].place.name ?? "Location"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        googleMap.settings.myLocationButton = false
        googleMap.settings.compassButton = false
        let img = getLocationImage()!
        let location = self.likeHoodList?.likelihoods[indexPath.row].place.coordinate
        
        print(location?.latitude)
        print(location?.latitude)
        
        shareLocation(locImage: img, location: location!)
    }
}


extension LocationVC:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else { return }
        locationManager.requestLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom: 15);
        self.googleMap.camera = camera
        self.googleMap.isMyLocationEnabled = true
        
        let marker = GMSMarker(position: center)
        marker.map = self.googleMap
        marker.title = "Current Location"
        locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension LocationVC:GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocode(coordinate: position.target)
    }
    
    func reverseGeocode(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard
                let address = response?.firstResult(),
                let lines = address.lines
                    //        print(lines.joined(separator: "\n"))
            else {
                return
            }
            self.currentLocation = address
            self.nearbyPlaces()
            
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension LocationVC {
    
    func nearbyPlaces() {
        
        //        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
        //
        //            if let error = error {
        //                print("Pick Place error: \(error.localizedDescription)")
        //                return
        //            }
        //
        ////            if let placeLikelihoodList = placeLikelihoodList {
        ////                self.likeHoodList = placeLikelihoodList
        ////                if self.likeHoodList != nil{
        ////                    self.tblNearLocation?.reloadData()
        ////                }
        ////            }
        //        })
        
        let placeFields: GMSPlaceField = [.name, .formattedAddress]
        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: placeFields) { [weak self] (placeLikelihoods, error) in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                print("Current place error: \(error?.localizedDescription ?? "")")
                return
            }
            
            guard let place = placeLikelihoods?.first?.place else {
                
                print("No current place")
                print("--")
                return
            }
            
            print(place.name)
            print(place.formattedAddress)
        }
    }
}
