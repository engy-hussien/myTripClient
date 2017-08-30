//
//  GetGoogleDirectionsService.swift
//  MyTripClient
//
//  Created by Engy Hussein on 8/27/17.
//  Copyright © 2017 Engy Hussein. All rights reserved.
//

import UIKit
import GooglePlaces
import Alamofire

class GetGoogleDirectionsService: NSObject {
    
    
    class func getDirectionsBetweenLocations(fromLocation from: GMSPlace, toDestination to: GMSPlace ,withCompletion: @escaping(_ startLocation: [String: Double]?,_ endLocation: [String: Double]?,_ wayPoints: [String]?, _ polypoints: String?,_ error: String)-> Void) {
        var fromAddress = ""
        var toAddress = ""
        let wayPoints = ["\(from.coordinate.latitude),\(from.coordinate.longitude)","\(to.coordinate.latitude),\(to.coordinate.longitude)"]
        for comp in from.addressComponents! {
            if comp != from.addressComponents?.last {
                fromAddress += comp.name + ","
            } else {
                fromAddress += comp.name
            }
        }
        for comp in to.addressComponents! {
            if comp != to.addressComponents?.last {
                toAddress += comp.name + ","
            } else {
                toAddress += comp.name
            }
        }
        let urlStr:String = "https://maps.googleapis.com/maps/api/directions/json?origin=\(fromAddress)&destination=\(toAddress)&waypoints=optimize:true|via:\(from.coordinate.latitude),\(from.coordinate.longitude)|via:\(to.coordinate.latitude),\(to.coordinate.longitude)&mode=driving&key=\(kGoogleMapsAPI)"
        let encodedStr = urlStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        Alamofire.request(encodedStr!).responseJSON { response in
            switch response.result {
            case .success:
                var route = ""
                var startLoction = [String: Double]()
                var endLoction = [String: Double]()
                if let jsonObject = response.result.value as? [String: Any]{
                    if let routes = jsonObject["routes"] as? [[String: Any]]  {
                        if !routes.isEmpty {
                        if let legs = routes[0]["legs"] as? [[String: Any]] {
                            if !legs.isEmpty {
                                if let startLoc = legs[0] ["start_location"] as? [String: Double] {
                                    startLoction = startLoc
                                }
                            if let endLoc = legs[legs.count-1]["end_location"] as? [String: Double] {
                                endLoction = endLoc
                            }
                            }
                        }
                        if let polyPoint = routes[0]["overview_polyline"] as? [String: String] {
                            if let poly = polyPoint["points"] {
                                route = poly
                            }
                        }
                    }
                    }
                }
                withCompletion(startLoction,endLoction,wayPoints,route,"")
            case .failure:
                withCompletion(nil,nil,nil,nil,"Error")
                print(#imageLiteral(resourceName: "error"))
                
            }
        }
        
    }
    
    
}
