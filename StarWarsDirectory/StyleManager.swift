//
//  StyleManager.swift
//  StarWarsDirectory
//
//  Created by Dan Leonard on 4/18/18.
//  Copyright © 2018 MacMeDan. All rights reserved.
//

import UIKit

protocol StyleManagerProtocol {
    func configureStyles()
}

class StyleManager: StyleManagerProtocol {
    func configureStyles() {
        
        // TODO: update to user this.
        
        // Bar buttons
//        do {
//            let proxy = UIBarButtonItem.appearance()
//            proxy.setTitleTextAttributes([NSAttributedStringKey.font: Font.appFont(ofSize: 17, style: .book),
//                                          NSAttributedStringKey.foregroundColor: Color.white], for: .normal)
//
//            proxy.setTitleTextAttributes([NSAttributedStringKey.font: Font.appFont(ofSize: 17, style: .book),
//                                          NSAttributedStringKey.foregroundColor: Color.highlighted(Color.white)], for: .highlighted)
//
//            proxy.setTitleTextAttributes([NSAttributedStringKey.font: Font.appFont(ofSize: 17, style: .book),
//                                          NSAttributedStringKey.foregroundColor: Color.white.withAlphaComponent(0.2)], for: .disabled)
//        }
        
        // Segmented control
//        do {
//            let proxy = UISegmentedControl.appearance()
//            proxy.tintColor = Color.primary
//            proxy.setTitleTextAttributes([NSAttributedStringKey.font: Font.appFont(ofSize: 13, style: .book)], for: .normal)
//        }
//
//        // Table view section headers
//        do {
//            let proxy = UITableViewHeaderFooterView.appearance()
//            proxy.textLabel?.font = Font.appFont(ofSize: 12, style: .book)
//            proxy.textLabel?.textColor = Color.SearchBar.placeholder
//        }

        
        // Navigation bars
        do {
            let proxy = UINavigationBar.appearance()
            
            proxy.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            proxy.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            proxy.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            proxy.shadowImage = UIImage()
            proxy.isTranslucent = true
            proxy.titleTextAttributes = [
                NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            ]
        }
//
//        // Text fields
//        do {
//            let proxy = UITextField.appearance()
//            proxy.tintColor = Color.secondary
//        }
//
//        // Table view
//        do {
//            let proxy = UITableView.appearance()
//            proxy.separatorColor = Color.lightTrim
//        }
    }
}
