//
//  BusinessTableViewCell.swift
//  DD
//
//  Created by Madhan Padmanabhan on 1/9/17.
//  Copyright © 2017 madhan. All rights reserved.
//

import UIKit
import Alamofire

class BusinessTableViewCell: UITableViewCell {
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessTagLabel: UILabel!
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    @IBOutlet weak var deliveryStatusLabel: UILabel!
    
    //MARK: Utility
    public func setup(business:DDBusiness) {
        self.businessNameLabel.text = business.name
        self.businessTagLabel.text = business.type
        self.deliveryFeeLabel.text = business.deliveryFee + " Delivery"
        self.deliveryStatusLabel.text = business.deliveryStatus
        
        if (business.coverImageURL != nil) {            
            DispatchQueue.global(qos: .background).async {
                Alamofire.request(business.coverImageURL!).responseData { response in
                    guard response.result.isSuccess else {
                        print("Error while fetching images: \(response.result.error)")
                        return
                    }
                    
                    if let data = response.result.value {
                        self.setBusinessImage(image: UIImage(data: data)!, business: business)
                    }
                }
            }
        }
    }
    
    //MARK: Private
    private func setBusinessImage(image:UIImage, business:DDBusiness) {
        if business.name == self.businessNameLabel.text {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: {
                    self.businessImageView?.image = image
                })
            }
        }
    }
    
    //MARK: Static
    class func reuseIdentifier() -> String {
        return String(describing: BusinessTableViewCell.self)
    }
}
