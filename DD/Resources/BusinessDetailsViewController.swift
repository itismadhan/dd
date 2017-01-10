//
//  BusinessDetailsViewController.swift
//  DD
//
//  Created by Madhan Padmanabhan on 1/9/17.
//  Copyright © 2017 madhan. All rights reserved.
//

import UIKit
import SVProgressHUD

enum FavoriteButtonState:Int {
    case addToFavorites = 0
    case favorited = 1
}

class BusinessDetailsViewController: UIViewController, UITableViewDataSource {
    static let kAddToFavoritesString = "Add to Favorites"
    static let kFavoritedString = "Favorited"
    
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
        
        if (self.business?.isFavorite())! {
                self.updateFavoriteButton(state: .favorited)
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
        self.navigationItem.title = self.business?.name
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
    
    private func updateFavoriteButton(state:FavoriteButtonState) {
        if state == .favorited {
            self.favoriteButton.backgroundColor = DDColor.Red
            self.favoriteButton.setTitle(BusinessDetailsViewController.kFavoritedString, for: .normal)
            self.favoriteButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            self.favoriteButton.backgroundColor = UIColor.white
            self.favoriteButton.setTitle(BusinessDetailsViewController.kAddToFavoritesString, for: .normal)
            self.favoriteButton.setTitleColor(DDColor.Red, for: .normal)
        }
    }
    
    //MARK: IBAction
    
    @IBAction func onFavoriteButtonTap(_ sender: UIButton) {
        //TODO - Change condition
        if sender.titleLabel?.text == BusinessDetailsViewController.kAddToFavoritesString {
            self.updateFavoriteButton(state: .favorited)
            DDBusiness.saveFavorite(business: self.business!)
        } else {
            self.updateFavoriteButton(state: .addToFavorites)
            DDBusiness.deleteFavorite(business: self.business!)
        }
    }
}
