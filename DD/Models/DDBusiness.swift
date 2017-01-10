//
//  Business.swift
//  DD
//
//  Created by Madhan Padmanabhan on 1/9/17.
//  Copyright © 2017 madhan. All rights reserved.
//

import Foundation


class DDBusiness: NSObject, NSCoding {
    static let minutesString:String = "min"

    var deliveryFee:String
    var deliveryStatus:String
    var name:String
    var type:String
    var id:String
    var coverImageURL:URL?
    
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
        self.coverImageURL = URL(string: dictionary["cover_img_url"] as! String)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.deliveryFee = aDecoder.decodeObject(forKey: "deliveryFee") as! String
        self.deliveryStatus = aDecoder.decodeObject(forKey: "deliveryStatus") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.type = aDecoder.decodeObject(forKey: "type") as! String
        self.coverImageURL = aDecoder.decodeObject(forKey: "coverImageURL") as? URL
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.deliveryFee, forKey: "deliveryFee")
        aCoder.encode(self.deliveryStatus, forKey: "deliveryStatus")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.type, forKey: "type")
        aCoder.encode(self.coverImageURL, forKey: "coverImageURL")
    }
    
    public func isFavorite() -> Bool {
        var favorites:Dictionary<String, Data> = DDBusiness.loadUserDefaults()
        
        if (favorites[self.id] != nil) {
            return true
        }
        
        return false
    }
    
    static func deleteFavorite(business:DDBusiness) {
        var favorites:Dictionary<String, Data> = self.loadUserDefaults()
        favorites.removeValue(forKey: business.id)
        UserDefaults.standard.set(favorites, forKey:"favorites")

        DispatchQueue.global(qos: .background).async {
            UserDefaults.standard.synchronize()
        }
    }
    
    static func saveFavorite(business:DDBusiness) {
        var favorites = self.loadUserDefaults()
        favorites[business.id] = NSKeyedArchiver.archivedData(withRootObject: business)
        UserDefaults.standard.set(favorites, forKey:"favorites")

        DispatchQueue.global(qos: .background).async {
            UserDefaults.standard.synchronize()
        }
    }
    
    static func loadFavorites() -> Array<DDBusiness> {
        var favoritesList:[DDBusiness] = []
        let favorites = self.loadUserDefaults()

        for item in favorites.values {
            let favorite:DDBusiness = NSKeyedUnarchiver.unarchiveObject(with: item) as! DDBusiness
            favoritesList.append(favorite)
        }
        
        return favoritesList
    }
    
    static func loadUserDefaults() -> Dictionary<String, Data> {
        let defaults = UserDefaults.standard
        var favorites:Dictionary<String, Data> = [:]
        
        if defaults.dictionary(forKey: "favorites") != nil {
            favorites = defaults.dictionary(forKey: "favorites") as! Dictionary<String, Data>
        }
        
        return favorites
    }
}
