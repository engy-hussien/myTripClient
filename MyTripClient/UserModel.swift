//
//  UserModel.swift
//  MyTripClient
//
//  Created by Engy Hussein on 8/28/17.
//  Copyright © 2017 Engy Hussein. All rights reserved.
//

import UIKit

class UserModel {
    
    var id = 0
    var name = ""
    var email =  ""
    var phoneNumber =  ""
    
    
    func mapping(map: [String: Any]) -> UserModel {
        id = map["id"] as! Int
        name = map["name"] as! String
        email = map["email"] as! String
        phoneNumber = map["phoneNumber"] as! String
        return self
    }
    

}
