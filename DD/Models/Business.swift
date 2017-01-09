//
//  Business.swift
//  DD
//
//  Created by Madhan Padmanabhan on 1/9/17.
//  Copyright © 2017 madhan. All rights reserved.
//

import Foundation


class Business: NSObject {
    static let minutesString:String = "min"

    var deliveryFee:String
    var deliveryStatus:String
    var name:String
    var type:String
    var id:String
    
    init(dictionary:Dictionary<String, Any>) {
        let tags = dictionary["tags"] as! Array<String>
        let business = dictionary["business"] as! Dictionary<String, Any>
        let fee = dictionary["delivery_fee"] as! Double
        let id = business["id"] as! Int
        
        self.id = String(id)
        self.name = business["name"] as! String
        self.type = tags[0]
        self.deliveryFee = fee > 0 ? "$" + String(fee/100.0) : "Free"
        self.deliveryStatus = dictionary["status"] as! String
    }
    
}
