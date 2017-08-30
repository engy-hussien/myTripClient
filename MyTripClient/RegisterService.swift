//
//  RegisterService.swift
//  MyTripClient
//
//  Created by Engy Hussein on 8/28/17.
//  Copyright © 2017 Engy Hussein. All rights reserved.
//

import UIKit

class RegisterService: NSObject {
    
   class func requestRegisterUser(withName name: String, withEmail email: String, withMobileNumber mobileNumber: String, withCompletion: @escaping(_ response: UserModel?,_ error: String)-> Void) {
        let parameters = ["Name": name,
                          "Email": email,
                          "PhoneNumber": mobileNumber]
        let url = BaseURL + "/api/signups/"
        ServiceLayer().PostRequest(requestUrl: url, requestParameters: parameters as [String : AnyObject], addTokenHeader: false, completion: { (result) -> Void in
            if let data = result["model"]  as? [[String : Any]] {
            let object = UserModel().mapping(map: data[0])
                    withCompletion(object, "")
                }
                else {
                withCompletion(nil, "error")
            }
        })
    }

}
