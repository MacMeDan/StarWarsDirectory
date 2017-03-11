//
//  SettingsViewController.swift
//  StarWarsDirectory
//
//  Created by P D Leonard on 3/9/17.
//  Copyright © 2017 MacMeDan. All rights reserved.
//

import UIKit
import SnapKit

private let TableViewOffset: CGFloat = UIScreen.main.bounds.height < 600 ? 215 : 225
private let BeforeAppearOffset: CGFloat = 400

class SettingsViewController: UITableViewController {
    //fileprivate var backgroundHolder: UIView = UIView()
    //fileprivate var backgroundImageView: UIImageView = UIImageView()
    
    var character: Character! 
    
    convenience init(character: Character) {
        self.init(nibName: nil, bundle: nil)
        self.character = character
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTable()
        tableView.separatorColor = UIColor(string: "#1f1d22")
        tableView.removeLines()
        tableView.backgroundColor = .black
    }
    
    func prepareTable() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        let imageURL = URL(string: character.picture)
        let hight = self.view.bounds.height - 60 * 4
        self.tableView.tableHeaderView  = HeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: hight), imageURL: imageURL)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.textColor = UIColor(string: "#4f4d51")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell.detailTextLabel?.textColor = UIColor(string: "#d0d0d1")
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.text = getTextForTextLabel(indexPath: indexPath)
        cell.detailTextLabel?.text = getTextForDetailLable(indexPath: indexPath).capitalized
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .black
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func getTextForTextLabel(indexPath: IndexPath) -> String {
        switch indexPath.item {
        case 0:
            return "Full Name"
        case 1:
            return "Affiliation"
        case 2:
            return "Birthdate"
        case 3:
            return "Force Sensitive"
        default:
            return ""
        }
    }
    
    func getTextForDetailLable(indexPath: IndexPath) -> String  {
        switch indexPath.item {
        case 0:
            return character.firstName + " " + character.lastName
        case 1:
            return character.affiliation
        case 2:
            return character.birthDate
        case 3:
            return character.forceSensitive.description
        default:
            return ""
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerView = self.tableView.tableHeaderView as! HeaderView
        headerView.scrollViewDidScroll(scrollView: scrollView)
    }
    
}
