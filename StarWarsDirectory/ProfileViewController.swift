//
//  SettingsViewController.swift
//  GalacticDirectory
//
//  Created by P D Leonard on 3/9/17.
//  Copyright © 2017 MacMeDan. All rights reserved.
//

import UIKit
import SnapKit

private let TableViewOffset: CGFloat = UIScreen.main.bounds.height < 600 ? 215 : 225
private let BeforeAppearOffset: CGFloat = 400
private let rowHight: CGFloat = 60
private var rows = [(String,String)]()

class ProfileViewController: UITableViewController {

    let reuseIdentifier = "ProfileCellIdentifier"
    var contact: Contact!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareData()
        prepareNavigationBar()
        prepareTable()
    }
    
    fileprivate func prepareNavigationBar() {
    navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController!.navigationBar.shadowImage = UIImage()
        navigationController!.navigationBar.isTranslucent = true
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "Close_icn"), style: .plain, target: self, action: #selector(dissmissView))
        navigationItem.leftBarButtonItem = button
        navigationItem.leftBarButtonItem?.tintColor = .white
    }

    func dissmissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func prepareTable() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        let imageURL = URL(string: contact.pictureURL)
        let hight = self.view.bounds.height - (rowHight * CGFloat(rows.count))
        
        if let picData = contact.picture {
            if let image = UIImage(data: picData) {
                self.tableView.tableHeaderView  = HeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: hight), image: image)
            }
        } else {
            self.tableView.tableHeaderView  = HeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: hight), imageURL: imageURL)
        }
        
        
        tableView.separatorColor = UIColor(string: "#1f1d22")
        tableView.removeLines()
        tableView.backgroundColor = .black
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        let row = rows[indexPath.row]
        cell.textLabel?.textColor = UIColor(string: "#4f4d51")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell.detailTextLabel?.textColor = UIColor(string: "#d0d0d1")
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.text = row.0
        cell.detailTextLabel?.text = row.1
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .black
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHight
    }
    
    func prepareData() {
        rows = []
        // Add all rows that are not optional
        rows.append(("Full Name", contact.firstName + " " + contact.lastName))
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .short
//        if let affiliation  = contact.affiliation { rows.append(("Affiliation", affiliation)) }
        if let birthDate    = contact.birthDate   { rows.append(("BirthDate", birthDate)) }
//                                                    rows.append(("Force Sensitive", contact.forceSensitive.description))
        if let phoneNumber  = contact.phoneNumber { rows.append(("PhoneNumber", phoneNumber.description))}
        if let zip          = contact.zip         { rows.append(("Zip", zip.description)) }
        tableView.reloadData()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerView = self.tableView.tableHeaderView as! HeaderView
        headerView.scrollViewDidScroll(scrollView: scrollView)
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}

