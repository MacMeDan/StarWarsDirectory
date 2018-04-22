//
//  StyleManager.swift
//  StarWarsDirectory
//
//  Created by Dan Leonard on 4/18/18.
//  Copyright © 2018 MacMeDan. All rights reserved.
//

import UIKit

protocol StyleManagerProtocol {
    func configureStyles(theme: ThemeProtocol)
}

class StyleManager: StyleManagerProtocol {
    
    var theme: ThemeProtocol!
    
    func configureStyles(theme: ThemeProtocol) {
        self.theme = theme
        
        // Bar buttons
        do {
            let BarButtonAppearence = UIBarButtonItem.appearance()
            BarButtonAppearence.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: theme.secondary], for: .normal)
            BarButtonAppearence.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: theme.accent], for: .highlighted)
            
            BarButtonAppearence.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: theme.secondary.withAlphaComponent(0.2)], for: .disabled)
        }
        
        // Navigation bars
        do {
            let NavBarAppearence = UINavigationBar.appearance()
            NavBarAppearence.barTintColor = theme.secondary
            NavBarAppearence.tintColor = theme.secondary
            NavBarAppearence.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            NavBarAppearence.shadowImage = UIImage()
            NavBarAppearence.isTranslucent = true
            NavBarAppearence.titleTextAttributes = [
                NSAttributedStringKey.foregroundColor: theme.tertiary
            ]
        }

        // Text fields
        do {
            let textFieldAppearence = UITextField.appearance()
            textFieldAppearence.tintColor = theme.secondary
        }

        // Table view
        do {
            let tableViewAppearence = UITableView.appearance()
            tableViewAppearence.separatorColor = theme.nutralDark
        }
        
        do {
            let cell = UITableViewCell.appearance()
            cell.textLabel?.textColor = theme.nutral
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
            cell.detailTextLabel?.textColor = theme.nutralLight
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
        }
    }
}
