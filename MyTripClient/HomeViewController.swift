//
//  HomeViewController.swift
//  MyTripClient
//
//  Created by Engy Hussein on 8/19/17.
//  Copyright © 2017 Engy Hussein. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces


protocol HomeViewProtocol {
    func updateTripPrice(forType type: CarType)
}

class HomeViewController: BaseViewController, HomeViewProtocol {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var theCollectionView: UICollectionView!
    @IBOutlet weak var estimateView: UIView!
    @IBOutlet weak var estimatePriceLabel: UILabel!
    
    var locationManager: CLLocationManager? = nil
    var currentLocation = CLLocation()
    var currentLocationAddress:GMSPlace?
    var dropOffLocation: GMSPlace?
    var locationMarker: GMSMarker?
    var encodedPolyline = ""
    var polyline = GMSPolyline()
    var animationPolyline = GMSPolyline()
    var routePath = GMSPath()
    var animationPath = GMSMutablePath()
    var i: UInt = 0
    var timer = Timer()
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = 50
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        mapView.delegate = self
        self.theCollectionView.isScrollEnabled = false
        self.navigationController?.addSideMenuButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.estimateView.isHidden = true
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.barStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.timer.invalidate()
    }
    
    func getAddress(withLocation location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { [weak self] (addresses, error) in
            if error != nil {
                return
            }
            if (addresses?.count)! > 0 {
                let address = addresses?[0]
                //                self?.currentLocationAddress = (address?.locality)!
                self?.theCollectionView.reloadData()
                print(address?.locality ?? "tox")
            }
        })
    }
    // UpdteLocationCoordinate
    func updateLocationoordinates(coordinates:CLLocationCoordinate2D) {
        if locationMarker == nil
        {
            locationMarker = GMSMarker()
            locationMarker?.position = coordinates
            locationMarker?.icon = #imageLiteral(resourceName: "pin_location")
            locationMarker?.map = mapView
            locationMarker?.appearAnimation = .none
        }
        else
        {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.3)
            locationMarker?.position =  coordinates
            currentLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
            CATransaction.commit()
        }
        let loc = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        self.getAddress(withLocation: loc)
    }
    
    func drawPath() {
        self.mapView.clear()
        self.theCollectionView.isScrollEnabled = true
        if currentLocationAddress != nil && dropOffLocation != nil {
            GetGoogleDirectionsService.getDirectionsBetweenLocations(fromLocation: currentLocationAddress!, toDestination: dropOffLocation!, withCompletion: {[weak self] (startLocation,endLocation,wayPoints,route,error) -> Void in
//                self?.timer = Timer.scheduledTimer(timeInterval: 0.005, target: self!, selector: #selector(self?.animatePolylinePath), userInfo: nil, repeats: true)

                let originCoord = CLLocationCoordinate2DMake((startLocation?["lat"])! , (startLocation?["lng"])! )
                let destinationCoord = CLLocationCoordinate2DMake((endLocation?["lat"])! , (endLocation?["lng"])! )
                
                let originMarker = GMSMarker(position: originCoord)
                originMarker.map = self?.mapView
                originMarker.icon = #imageLiteral(resourceName: "pin_location")
                
                let destinationMarker = GMSMarker(position: destinationCoord)
                destinationMarker.map = self?.mapView
                destinationMarker.icon = #imageLiteral(resourceName: "ic_dropoff_location")
                
                self?.routePath = GMSPath(fromEncodedPath: route!)!
                self?.polyline = GMSPolyline(path: self?.routePath)
                self?.polyline.map = self?.mapView
                self?.polyline.strokeColor = #colorLiteral(red: 0.007843137255, green: 0.7803921569, blue: 0.6352941176, alpha: 1)
                self?.polyline.strokeWidth = 8.0
                let camera = GMSCameraPosition.camera(withTarget: originCoord, zoom: 18.0)
                self?.mapView.animate(to: camera)
                self?.theCollectionView.reloadData()

            })
        } else {
            self.theCollectionView.isScrollEnabled = false
            mapView.reloadInputViews()
        }
    }

    func navigateToSearchScreenForLocation() {
        let searchVC = storyboard?.instantiateViewController(withIdentifier: "searchPlaceVC") as! SearchPlacesViewController
        searchVC.isDropOffView = false
        searchVC.currentLocation = self.currentLocation
        searchVC.homeDelegate = self
        self.navigationController?.pushViewController(searchVC, animated: true)
        
    }
    func navigateToSearchScreenForDropOff () {
        let searchVC = storyboard?.instantiateViewController(withIdentifier: "searchPlaceVC") as! SearchPlacesViewController
        searchVC.isDropOffView = true
        searchVC.currentLocation = self.currentLocation
        searchVC.homeDelegate = self
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func nextBtnTouchUpInside() {
        if currentLocationAddress != nil && dropOffLocation != nil {
            self.scrollToNextCell()
        }
    }
    
    func updateTripPrice(forType type: CarType) {
        switch type {
        case .economy:
            self.estimatePriceLabel.text = "15 - 20 EGP"
        case .business:
            self.estimatePriceLabel.text = "22 - 28 EGP"
        case .elite:
            self.estimatePriceLabel.text = "30 - 36 EGP"
        default:
            break
        }
    }

}

extension HomeViewController: CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, GMSMapViewDelegate, UIScrollViewDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
            locationManager?.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 15.0)
        let locationMarkerImg = UIImageView(image: #imageLiteral(resourceName: "pin_location"))
        let loc = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        locationMarker = GMSMarker()
        locationMarker?.iconView = locationMarkerImg
        locationMarker?.map = mapView
        mapView.selectedMarker = locationMarker
        self.mapView.animate(toLocation: loc)
        self.mapView.camera = camera
        self.mapView.animate(to: camera)
        self.getAddress(withLocation: location!)
        locationManager?.stopUpdatingLocation()
    }
    
  
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        var loc = CLLocation()
        if position != currentLocation {
            loc = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
            updateLocationoordinates(coordinates: loc.coordinate)
        }
    }
    
    

    func animatePolylinePath() {
        if (self.i < self.routePath.count()) {
            self.animationPath.add(self.routePath.coordinate(at: self.i))
            self.animationPolyline.path = self.animationPath
            self.animationPolyline.strokeColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
            self.animationPolyline.strokeWidth = 8.0
            self.animationPolyline.map = self.mapView
            self.i += 1
        }
        else {
            self.i = 0
            self.animationPath = GMSMutablePath()
            self.animationPolyline.map = nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "locationCell", for: indexPath) as! SelectLocationsViewCell
            cell.prepareCell()
            cell.setLocation(withLocation: (currentLocationAddress?.name) ?? "Where are you")
            cell.setDestination(withDestination: (dropOffLocation?.name) ?? "Where to go")
            cell.locationBtn.addTarget(self, action: #selector(HomeViewController.navigateToSearchScreenForLocation), for: .touchUpInside)
            cell.destinationBtn.addTarget(self, action: #selector(HomeViewController.navigateToSearchScreenForDropOff), for: .touchUpInside)
            cell.nextBtn.addTarget(self, action: #selector(HomeViewController.nextBtnTouchUpInside), for: .touchUpInside)
            cell.tag = 0
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carTypeCell", for: indexPath) as! SelectCarViewCell
            cell.delegate = self
            cell.setupCell()
            for btn in cell.carsTypesBtns! {
                btn.addTarget(cell, action: #selector(SelectCarViewCell.selectCarType(withSender:)), for: .touchUpInside)
            }
            cell.tag = 1
            return cell
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        var visibleRect = CGRect()
        
        visibleRect.origin = self.theCollectionView.contentOffset
        visibleRect.size = self.theCollectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        let visibleIndexPath: NSIndexPath = self.theCollectionView.indexPathForItem(at: visiblePoint)! as NSIndexPath
        
        if visibleIndexPath.item == 0 {
            self.estimateView.isHidden = true
        } else {
            self.estimateView.isHidden = false
        }
    }
    
    func scrollToNextCell(){
        
        let cellSize = CGSize(width: 327.0, height: 229.0)
        
        let contentOffset = theCollectionView.contentOffset;
        
        theCollectionView.scrollRectToVisible(CGRect(x: 347.0, y: 69.0, width: cellSize.width, height: cellSize.height), animated: true);
        
        
    }


}
