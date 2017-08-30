//
//  ServiceLayer.swift
//  MyTripClient
//
//  Created by Engy Hussein on 8/27/17.
//  Copyright © 2017 Engy Hussein. All rights reserved.
//

//
//  ServiceLayer.swift
//  Top Dentist
//
//  Created by sherif on 3/29/17.
//  Copyright © 2017 sherif khaled. All rights reserved.
//

import UIKit
import Alamofire

class ServiceLayer: NSObject {
    
    func PostRequest(requestUrl:String,requestParameters:[String:AnyObject],addTokenHeader:Bool,completion: @escaping (_ responseObj:AnyObject)->Void)  {
        
        if addTokenHeader == true {
            let UrlString = requestUrl
            let headers: HTTPHeaders = ["Authorization": ""]

            
            Alamofire.request(UrlString, method: .post, parameters: requestParameters, headers: headers).responseJSON { (response) in
                //                print(response.result.value)
                completion(response.result.value as AnyObject)
            }
            
        }else{
            let UrlString = requestUrl
            
            Alamofire.request(UrlString, method: .post, parameters: requestParameters).responseJSON { (response) in
                //                print(response.result.value)
                completion(response.result.value as AnyObject)
            }
        }
    }
    
    
    func GetRequest(requestUrl:String,requestParameters:String,addTokenHeader:Bool,completion: @escaping (_ responseObj:AnyObject)->Void)  {
        if addTokenHeader == true {
            let headers: HTTPHeaders = ["Authorization": ""]
            let UrlString = requestUrl + requestParameters
            
            Alamofire.request(UrlString, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                //                print(response.result.value)
                completion(response.result.value as AnyObject)
            }
            
        }else{
            
            let UrlString = requestUrl + requestParameters
            
            Alamofire.request(UrlString).responseJSON { (response) in
                print(response.result.value)
                completion(response.result.value as AnyObject)
            }
        }
    }
    
    
    
}

