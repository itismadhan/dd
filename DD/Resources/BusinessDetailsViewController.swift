//
//  BusinessDetailsViewController.swift
//  DD
//
//  Created by Madhan Padmanabhan on 1/9/17.
//  Copyright © 2017 madhan. All rights reserved.
//

import UIKit
import SVProgressHUD

class BusinessDetailsViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var headerImage:UIImage?

    var business:DDBusiness?
    var businessMenu:DDBusinessMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupHeaderView()
        
        SVProgressHUD.show()
        
        DDRestHelper.fetchBusinessMenu(business: self.business!) { (businessMenu) in
            if (businessMenu != nil) {
                self.businessMenu = businessMenu
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.flashScrollIndicators()
                }
            }
            
            SVProgressHUD.dismiss()
        }
    }
    
    //MARK: <UITableViewDataSource>
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.businessMenu != nil) {
           return (self.businessMenu?.categoryList.count)!
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = self.businessMenu?.categoryList[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Menu"
    }
    
    //MARK: Private
    private func setupHeaderView() {
        self.headerImageView.image = self.headerImage
        self.headerLabel.text = self.businessMenu?.status
        self.setupFavoriteButton()
    }
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
    }
    
    private func setupFavoriteButton() {
        self.favoriteButton.layer.cornerRadius = 2
        self.favoriteButton.layer.masksToBounds = true
        self.favoriteButton.layer.borderWidth  = 1
        self.favoriteButton.layer.borderColor = DDColor.Red.cgColor
    }
}
