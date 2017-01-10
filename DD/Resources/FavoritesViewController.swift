//
//  FavoritesViewController.swift
//  DD
//
//  Created by Madhan Padmanabhan on 1/7/17.
//  Copyright © 2017 madhan. All rights reserved.
//

import UIKit
import SVProgressHUD

class FavoritesViewController: UIViewController {
    @IBOutlet weak var tableView: BusinessTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.businessList = DDBusiness.loadFavorites()
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addressViewController = segue.destination as? AddressViewController {
            let nav:UINavigationController = self.tabBarController?.viewControllers?.first as! UINavigationController
            addressViewController.delegate = nav.viewControllers.first as! ExploreViewController
        }
    }
    
    //MARK: Private
    private func setupTableView() {
        let cellNib = UINib(nibName: BusinessTableViewCell.reuseIdentifier(), bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: BusinessTableViewCell.reuseIdentifier())
        self.tableView.dataSource = self.tableView
        self.tableView.delegate = self.tableView
        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.navVC = self.navigationController
    }
    
    private func setupNavigationBar() {
        let titleDict: Dictionary<String, Any> = [NSForegroundColorAttributeName: DDColor.Red]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
    }
}
