//
//  Constants.swift
//  MyTripClient
//
//  Created by Engy Hussein on 8/19/17.
//  Copyright © 2017 Engy Hussein. All rights reserved.
//

import Foundation
import SideMenuController
import SwiftyUserDefaults

let sideMenuViewController = SideMenuController()

let kGoogleMapsAPI = "AIzaSyDkpStEKsvSO2hYDbc6N5UB9THrURZMVdc"
let kGooglePlacesAPI = "AIzaSyCy8_4tB1UXSbOpdpTB-vszJ7nEHFfcRCI"
let BaseURL = "http://13.74.173.24:8070"


enum CarType: Int {
    case economy = 0
    case business = 1
    case elite = 2
}

extension DefaultsKeys {
    static let kIsLoggedInUser = DefaultsKey<Bool>("isLoggedInUser")
}
