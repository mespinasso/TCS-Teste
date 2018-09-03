//
//  FundViewController.swift
//  TCS-Teste
//
//  Created by Matheus Coelho Espinasso on 02/09/18.
//  Copyright © 2018 Matheus Coelho Espinasso. All rights reserved.
//

import UIKit

class FundViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var fundTableView: UITableView!
    
    var activityIndicator = UIActivityIndicatorView()
    var dataSource: Fund?
    let sections: [FundInfoSection] = [FundInfoSection.general, FundInfoSection.info, FundInfoSection.downInfo]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareActivityIndicator()
        
        fundTableView.delegate = self
        fundTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFund()
    }
    
    // MARK: - Setting up
    
    func prepareActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black
        
        let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraint)
    }
    
    // MARK: - Fetching data
    
    func loadFund() {
        activityIndicator.startAnimating()
        
        Fund.fetchFromServer { (fund) in
            DispatchQueue.main.async {
                self.dataSource = fund
                
                self.fundTableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].rawValue
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let fund = dataSource {
            switch sections[section] {
            case .general:
                return 3
                
            case .info:
                return fund.info.count
                
            case .downInfo:
                return fund.downInfo.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let fund = dataSource {
            var cell: UITableViewCell
            
            switch sections[indexPath.section] {
            case .general:
                cell = tableView.dequeueReusableCell(withIdentifier: "subtitleCell", for: indexPath)
                
                switch indexPath.row {
                case 0:
                    cell.textLabel?.text = fund.fundName
                    cell.detailTextLabel?.text = "Fundo"
                    break
                case 1:
                    cell.textLabel?.text = fund.definition
                    cell.detailTextLabel?.text = "Objetivo"
                case 2:
                    cell.textLabel?.text = "\(fund.risk) de 5"
                    cell.detailTextLabel?.text = "Grau de Risco"
                default:
                    break
                }
                
                return cell
                
            case.info:
                cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
                
                cell.textLabel?.text = fund.info[indexPath.row].name
                cell.detailTextLabel?.text = fund.info[indexPath.row].data
                
                return cell
                
            case.downInfo:
                
                cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
                
                cell.textLabel?.text = fund.downInfo[indexPath.row].name
                cell.detailTextLabel?.text = fund.downInfo[indexPath.row].data
                
                return cell
                
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "subtitleCell", for: indexPath)
        cell.textLabel?.text = "Text"
        cell.detailTextLabel?.text = "Detail"
        
        return tableView.dequeueReusableCell(withIdentifier: "subtitleCell", for: indexPath)
    }
}
