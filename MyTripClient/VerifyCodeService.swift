//
//  VerifyCodeService.swift
//  MyTripClient
//
//  Created by Engy Hussein on 8/28/17.
//  Copyright © 2017 Engy Hussein. All rights reserved.
//

import UIKit

class VerifyCodeService: NSObject {
    
    class func requestCodeVarification(withNumber number: String, withCode code: String, withCompletion: @escaping(_ response: String,_ error: String)-> Void) {
        let parameters = ["PhoneNumber": number,
                          "ConfirmationCode": code]
        let url = BaseURL + "/api/signups/confirm"
        ServiceLayer().PostRequest(requestUrl: url, requestParameters: parameters as [String : AnyObject], addTokenHeader: false, completion: { (result) -> Void in
            if let data = result["model"]  as? [[String : Any]] {
                withCompletion("success", "")

            }
            else {
                withCompletion("", "error")
            }
        })
    }


}
