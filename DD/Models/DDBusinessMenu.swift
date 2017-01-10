//
//  DDBusinessMenu.swift
//  DD
//
//  Created by Madhan Padmanabhan on 1/9/17.
//  Copyright © 2017 madhan. All rights reserved.
//

import Foundation

class DDBusinessMenu: NSObject {
    var categoryList:[DDBusinessMenuCategory] = []
    var status:String = ""
    
    init(dictionary:Dictionary<String, Any>) {
        let categoriesList = dictionary["menu_categories"] as! Array<Dictionary<String, Any>>
        for category in categoriesList {
            self.categoryList.append(DDBusinessMenuCategory(dictionary: category))
        }
        
        self.status = dictionary["status"] as! String
    }
}
