//
//  ViewController.swift
//  DD
//
//  Created by Madhan Padmanabhan on 1/7/17.
//  Copyright © 2017 madhan. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController, UITableViewDataSource, BusinessDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var businessList:Array<DDBusiness> = []

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
    
    //MARK: <UITableViewDataSource>
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businessList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BusinessTableViewCell = tableView.dequeueReusableCell(withIdentifier: BusinessTableViewCell.reuseIdentifier(), for: indexPath) as! BusinessTableViewCell
        
        cell.setup(business: self.businessList[indexPath.row])
    
        return cell
    }
    
    //MARK: <BusinessDelegate>
    func updateBusinessList(businessList: Array<DDBusiness>) {
        self.businessList = businessList
        self.tableView.reloadData()
    }
    
    //MARK: Private
    private func setupTableView() {
        let cellNib = UINib(nibName: BusinessTableViewCell.reuseIdentifier(), bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: BusinessTableViewCell.reuseIdentifier())
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        self.tableView.rowHeight = 100
    }
}

