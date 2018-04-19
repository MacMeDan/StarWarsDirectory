//
//  UITableViewCell.swift
//  StarWarsDirectory
//
//  Created by Dan Leonard on 4/18/18.
//  Copyright © 2018 MacMeDan. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}
