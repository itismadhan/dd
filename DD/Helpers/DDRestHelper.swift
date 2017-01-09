//
//  DDRestHelper.swift
//  DD
//
//  Created by Madhan Padmanabhan on 1/9/17.
//  Copyright © 2017 madhan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DDRestHelper {
    static let baseURLString:String = "https://api.doordash.com/"
    static let v1APIURLString:String = baseURLString + "v1/"
    static let v2APIURLString:String = baseURLString + "v2/"
    
    static func fetchBusinesses(parameters:Parameters, completionHandler:@escaping ([Business]) -> ()) {
        DispatchQueue.global(qos: .background).async {
            Alamofire.request(v1APIURLString + "store_search", method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                var businessList:Array<Business> = []

                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(response.result.error)")
                    completionHandler(businessList)
                    return
                }
                
                guard let value = response.result.value as? Array<Dictionary<String, Any>> else {
                    print("Malformed data received from fetchAllRooms service")
                    completionHandler(businessList)
                    return
                }

                for dict in value {
                    let business = Business(dictionary: dict)
                    businessList.append(business)
                }
                
                completionHandler(businessList)
            }
        }
    }
}