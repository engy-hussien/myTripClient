//
//  SearchPlacesViewController.swift
//  MyTripClient
//
//  Created by Engy Hussein on 8/26/17.
//  Copyright © 2017 Engy Hussein. All rights reserved.
//

import UIKit
import GooglePlaces
import CoreLocation


class SearchPlacesViewController: BaseViewController{
    

    @IBOutlet weak var placesTableView: UITableView!
    @IBOutlet weak var searchTypeIcon: UIImageView!
    @IBOutlet weak var searchTypeTitle: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var headerView: UIView!
    
    var fetcher: GMSAutocompleteFetcher?
    weak var homeDelegate: HomeViewController?
    var result = ""
    var resultPlaces = [(title: String,address: String,id: String)]()
    var savedPlaces = [String]()
    var recentPlaces = [String]()
    var isDropOffView = false
    var currentLocation = CLLocation()
    var selectedPlace: GMSPlace?
    
    
    @IBAction func cancelSearchTouchUpInside(_ sender: UIButton) {
        searchTextField.text = ""
        resultPlaces.removeAll()
        placesTableView.reloadData()
    }
    
    @IBAction func searchTextChanged(_ sender: UITextField) {
        if searchTextField.hasText {
            self.showLoader()
            fetcher?.sourceTextHasChanged(searchTextField.text)
        } else {
            resultPlaces.removeAll()
            placesTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let filter = GMSAutocompleteFilter()
        let neBoundsCorner = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude,
                                                    longitude: currentLocation.coordinate.longitude)
        let swBoundsCorner = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude + 0.875725,
                                                    longitude: currentLocation.coordinate.longitude + 0.200349)
        let bounds = GMSCoordinateBounds(coordinate: neBoundsCorner,
                                         coordinate: swBoundsCorner)
        filter.type = .address
        fetcher = GMSAutocompleteFetcher(bounds: bounds, filter: filter)
        fetcher?.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resultPlaces.removeAll()
        savedPlaces.removeAll()
        recentPlaces.removeAll()
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2980392157, green: 0.7333333333, blue: 0.4823607843, alpha: 1)
        if isDropOffView {
            self.setupViewForDropOff()
        } else {
            self.setupViewForCurrentLocation()
        }
    }
    
     func setupViewForCurrentLocation() {
        searchTypeIcon.image = #imageLiteral(resourceName: "ic_yourlocation")
        searchTypeTitle.text = "Location"
     }
    
    func setupViewForDropOff() {
        searchTypeIcon.image = #imageLiteral(resourceName: "symbol")
        searchTypeTitle.text = "Drop off Location"
    }
    

}

extension SearchPlacesViewController: GMSAutocompleteFetcherDelegate , UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if resultPlaces.isEmpty {
          return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultPlaces.isEmpty {
            if section == 0 {
                return recentPlaces.count
            } else {
                return savedPlaces.count
            }
        } else {
            return resultPlaces.count
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! SearchPlacesHeaderTableViewCell
        if resultPlaces.isEmpty {
            if section == 0 {
                cell.headerTitle.text = "Recent Locations"
            } else {
                cell.headerTitle.text = "Saved Locations"
            }
        } else {
                cell.headerTitle.text = "Search Locations"
            }
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! SearchPlacesTableViewCell
        var itemName = ""
        var itemAddress = ""
        if resultPlaces.isEmpty {
            if indexPath.section == 0 {
                itemName = recentPlaces[indexPath.row]
            } else  {
                itemName = savedPlaces[indexPath.row]
            }
        }else {
            itemName = resultPlaces[indexPath.row].0
            itemAddress = resultPlaces[indexPath.row].1
            
        }
        cell.placeName.text = itemName
        cell.placeAddress.text = itemAddress
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if resultPlaces.isEmpty {
        }else {
            let placeID = resultPlaces[indexPath.row].id
            
            self.getPlaceByID(placeID: placeID)
        }
    }
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        var resultTitle = ""
        var resultAddress = ""
        var resultID = ""
        resultPlaces.removeAll()
        for prediction in predictions {
            resultTitle = prediction.attributedPrimaryText.string
            resultAddress = prediction.attributedFullText.string
            resultID = prediction.placeID!
            resultPlaces.append((resultTitle,resultAddress,resultID))
        }
        placesTableView.reloadData()
        self.dissmissLoader()

        
    }
    func didFailAutocompleteWithError(_ error: Error) {
        self.dissmissLoader()
        self.showAlertViewMsg(title: "Error", msg: error.localizedDescription)
    }
    
    func getPlaceByID(placeID id: String){
        let placesClient = GMSPlacesClient()
        showLoader()
        placesClient.lookUpPlaceID(id, callback: { [weak self] (place,error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place details for \(id)")
                return
            }
            self?.dissmissLoader()
            self?.selectedPlace = place
            self?.popToHome()

        })
    }
    
    func popToHome() {
        if isDropOffView {
            homeDelegate?.dropOffLocation = selectedPlace
        } else {
            homeDelegate?.currentLocationAddress = selectedPlace
        }
        homeDelegate?.theCollectionView.reloadData()
        homeDelegate?.drawPath()
       _ = self.navigationController?.popViewController(animated: true)
    }
}
