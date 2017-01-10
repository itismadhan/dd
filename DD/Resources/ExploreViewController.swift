//
//  ViewController.swift
//  DD
//
//  Created by Madhan Padmanabhan on 1/7/17.
//  Copyright © 2017 madhan. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController, BusinessDelegate {
    @IBOutlet weak var tableView: BusinessTableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.performSegue(withIdentifier: DDSegueIdentifier.AddressViewControllerModalSegue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addressViewController = segue.destination as? AddressViewController {
            addressViewController.delegate = self
        }
    }
    
    //MARK: <BusinessDelegate>
    func updateBusinessList(businessList: Array<DDBusiness>) {
        self.tableView.businessList = businessList
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
}

