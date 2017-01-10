//
//  DDRestHelper.swift
//  DD
//
//  Created by Madhan Padmanabhan on 1/9/17.
//  Copyright © 2017 madhan. All rights reserved.
//

import Foundation
import Alamofire

class DDRestHelper {
    static let kBaseURLString:String = "https://api.doordash.com/"
    static let kV1APIURLString:String = kBaseURLString + "v1/"
    static let kV2APIURLString:String = kBaseURLString + "v2/"
    static let kLatitudeKeyString:String = "lat"
    static let kLongitudeKeyString:String = "lng"
    
    static func fetchBusinesses(parameters:Parameters, completionHandler:@escaping ([DDBusiness]) -> ()) {
        DispatchQueue.global(qos: .background).async {
            Alamofire.request(kV1APIURLString + "store_search", method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                var businessList:Array<DDBusiness> = []

                guard response.result.isSuccess else {
                    print("Error while fetching businesses: \(response.result.error)")
                    completionHandler(businessList)
                    return
                }
                
                guard let value = response.result.value as? Array<Dictionary<String, Any>> else {
                    print("Malformed data received")
                    completionHandler(businessList)
                    return
                }

                for dict in value {
                    let business = DDBusiness(dictionary: dict)
                    businessList.append(business)
                }
                
                completionHandler(businessList)
            }
        }
    }
    
    static func fetchBusinessMenu(business:DDBusiness, completionHandler:@escaping (DDBusinessMenu?) -> ()) {
        DispatchQueue.global(qos: .background).async {
            let URLString = kV2APIURLString + "restaurant/" + business.id + "/menu/"

            Alamofire.request(URLString, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                var businessMenu:DDBusinessMenu?
                
                guard response.result.isSuccess else {
                    print("Error while fetching businesses: \(response.result.error)")
                    completionHandler(nil)
                    return
                }
                
                guard let value = response.result.value as? Array<Dictionary<String, Any>> else {
                    print("Malformed data received")
                    completionHandler(nil)
                    return
                }
                
                for dict in value {
                    businessMenu = DDBusinessMenu(dictionary: dict)
                }
                
                completionHandler(businessMenu)
            }
        }
    }

}
