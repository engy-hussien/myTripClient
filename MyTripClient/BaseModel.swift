//
//  BaseModel.swift
//  MyTripClient
//
//  Created by Engy Hussein on 8/28/17.
//  Copyright © 2017 Engy Hussein. All rights reserved.
//

import UIKit
import ObjectMapper

class BaseModel: Mappable {
    
        var eCode : String = ""
        var eDesc : String = ""
        required init?(map: Map) {
            
        }
        
        init() {
            
        }

        public func mapping(map: Map) {
            eCode <- map["metas"]
            eDesc <- map["errors"]
        }
        

}
