//
//  BusinessTableView.swift
//  DD
//
//  Created by Madhan Padmanabhan on 1/9/17.
//  Copyright © 2017 madhan. All rights reserved.
//

import UIKit

class BusinessTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var businessList:Array<DDBusiness> = []
    var navVC:UINavigationController?
    
    //MARK: <UITableViewDataSource>
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businessList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BusinessTableViewCell = tableView.dequeueReusableCell(withIdentifier: BusinessTableViewCell.reuseIdentifier(), for: indexPath) as! BusinessTableViewCell
        cell.setup(business: self.businessList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let businessDetailsVC:BusinessDetailsViewController = BusinessDetailsViewController()
        let cell:BusinessTableViewCell = tableView.cellForRow(at: indexPath) as! BusinessTableViewCell
        
        tableView.deselectRow(at: indexPath, animated: false)
        businessDetailsVC.business = self.businessList[indexPath.row]
        businessDetailsVC.headerImage = cell.businessImageView.image
        self.navVC?.pushViewController(businessDetailsVC, animated: true)
    }
    
}
