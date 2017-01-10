//
//  DDBusinessMenuCategory.swift
//  DD
//
//  Created by Madhan Padmanabhan on 1/9/17.
//  Copyright © 2017 madhan. All rights reserved.
//

import UIKit

class DDBusinessMenuCategory: NSObject {
    var title:String?
    var subTitle:String?
    
    init(dictionary:Dictionary<String, Any>) {
        self.title = dictionary["title"] as? String
        self.subTitle = dictionary["subtitle"] as? String
    }
}
