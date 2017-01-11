//
//  Business.swift
//  DD
//
//  Created by Madhan Padmanabhan on 1/9/17.
//  Copyright © 2017 madhan. All rights reserved.
//
import Foundation

enum DDBusinessKey:String {
    case deliveryFee = "deliveryFee"
    case deliveryStatus = "deliveryStatus"
    case name = "name"
    case type = "type"
    case id = "id"
    case coverImageURL = "coverImageURL"
}

class DDBusiness: NSObject, NSCoding {
    static let minutesString:String = "min"
    static let favoritesUserDefaultsKeyString:String = "favorites"

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
        let id = dictionary["id"] as! Int
        
        self.id = String(id)
        self.name = business["name"] as! String
        self.type = tags[0]
        self.deliveryFee = fee > 0 ? "$" + String(fee/100.0) : "Free"
        self.deliveryStatus = dictionary["status"] as! String
        self.coverImageURL = URL(string: dictionary["cover_img_url"] as! String)
    }
    
    //MARK: NSCoding
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: DDBusinessKey.id.rawValue) as! String
        self.deliveryFee = aDecoder.decodeObject(forKey: DDBusinessKey.deliveryFee.rawValue) as! String
        self.deliveryStatus = aDecoder.decodeObject(forKey: DDBusinessKey.deliveryStatus.rawValue) as! String
        self.name = aDecoder.decodeObject(forKey: DDBusinessKey.name.rawValue) as! String
        self.type = aDecoder.decodeObject(forKey: DDBusinessKey.type.rawValue) as! String
        self.coverImageURL = aDecoder.decodeObject(forKey: DDBusinessKey.coverImageURL.rawValue) as? URL
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: DDBusinessKey.id.rawValue)
        aCoder.encode(self.deliveryFee, forKey: DDBusinessKey.deliveryFee.rawValue)
        aCoder.encode(self.deliveryStatus, forKey: DDBusinessKey.deliveryStatus.rawValue)
        aCoder.encode(self.name, forKey: DDBusinessKey.name.rawValue)
        aCoder.encode(self.type, forKey: DDBusinessKey.type.rawValue)
        aCoder.encode(self.coverImageURL, forKey: DDBusinessKey.coverImageURL.rawValue)
    }
    
    //MARK:Utility
    public func isFavorite() -> Bool {
        var favorites:Dictionary<String, Data> = DDBusiness.loadUserDefaults()
        
        if (favorites[self.id] != nil) {
            return true
        }
        
        return false
    }
    
    //MARK:Static
    static func deleteFavorite(business:DDBusiness) {
        var favorites:Dictionary<String, Data> = self.loadUserDefaults()
        favorites.removeValue(forKey: business.id)
        UserDefaults.standard.set(favorites, forKey:favoritesUserDefaultsKeyString)

        DispatchQueue.global(qos: .background).async {
            UserDefaults.standard.synchronize()
        }
    }
    
    static func saveFavorite(business:DDBusiness) {
        var favorites = self.loadUserDefaults()
        favorites[business.id] = NSKeyedArchiver.archivedData(withRootObject: business)
        UserDefaults.standard.set(favorites, forKey:favoritesUserDefaultsKeyString)

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
        
        if defaults.dictionary(forKey: favoritesUserDefaultsKeyString) != nil {
            favorites = defaults.dictionary(forKey: favoritesUserDefaultsKeyString) as! Dictionary<String, Data>
        }
        
        return favorites
    }
}
