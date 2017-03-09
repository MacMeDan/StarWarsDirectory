//
//  SettingsViewController.swift
//  StarWarsDirectory
//
//  Created by P D Leonard on 3/9/17.
//  Copyright © 2017 MacMeDan. All rights reserved.
//

import UIKit

private let TableViewOffset: CGFloat = UIScreen.main.bounds.height < 600 ? 215 : 225
private let BeforeAppearOffset: CGFloat = 400

class ProfileVC: UITableViewController {
    
    var themeChanged: ((_ darkside: Bool, _ center: CGPoint) -> Void)?
    
    @IBOutlet fileprivate var backgroundHolder: UIView!
    
    @IBOutlet fileprivate weak var backgroundImageView: UIImageView!
    
    @IBOutlet fileprivate weak var backgroundHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet fileprivate weak var backgroundWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet fileprivate weak var darkSideSwitch: UISwitch!
    
    @IBOutlet fileprivate weak var radioInactiveImageView: UIImageView!
    @IBOutlet fileprivate weak var radioActiveImageView: UIImageView!
    
    @IBOutlet fileprivate var cellTitleLabels: [UILabel]!
    @IBOutlet fileprivate var cellSubtitleLabels: [UILabel]!
    
    @IBOutlet fileprivate weak var usernameLabel: UILabel!
    
    @IBAction fileprivate func darkSideChanged(_ sender: AnyObject) {
        let center = self.tableView.convert(darkSideSwitch.center, from: darkSideSwitch.superview)
        self.themeChanged?(darkSideSwitch.isOn, center)
    }
    
    var charicter: Character!
    
    convenience init(character: Character) {
        self.init(nibName: nil, bundle: nil)
        self.charicter = character
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.contentInset = UIEdgeInsets(top: TableViewOffset, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -BeforeAppearOffset)
        
        UIView.animate(withDuration: 0.5) {
            self.tableView.contentOffset = CGPoint(x: 0, y: -TableViewOffset)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageURL = URL(string: charicter.picture)
        backgroundImageView.setRemoteImage(defaultImage: UIImage(), imageURL: imageURL)
        tableView.separatorColor = SettingsTheme.dark.separatorColor
        backgroundHolder.backgroundColor = SettingsTheme.dark.backgroundColor
        for label in cellTitleLabels { label.textColor = SettingsTheme.dark.cellTitleColor }
        for label in cellSubtitleLabels { label.textColor = SettingsTheme.dark.cellSubtitleColor }
        radioInactiveImageView.image = SettingsTheme.dark.radioInactiveImage
        radioActiveImageView.image = SettingsTheme.dark.radioActiveImage
        usernameLabel.text = charicter.firstName + " " + charicter.lastName
        tableView.reloadData()
        tableView.backgroundView = backgroundHolder
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor =  SettingsTheme.dark.backgroundColor
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        backgroundHeightConstraint.constant = max(navigationController!.navigationBar.bounds.height + scrollView.contentInset.top - scrollView.contentOffset.y, 0)
        backgroundWidthConstraint.constant = navigationController!.navigationBar.bounds.height - scrollView.contentInset.top - scrollView.contentOffset.y * 0.8
    }
}
