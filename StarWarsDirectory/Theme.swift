//
//  Style.swift
//  StarWarsDirectory
//
//  Created by Dan Leonard on 4/18/18.
//  Copyright © 2018 MacMeDan. All rights reserved.
//

import Foundation
import UIKit

protocol ThemeProtocol {
    var primary: UIColor { get }
    var secondary: UIColor { get }
    var tertiary: UIColor { get }
    var accent: UIColor { get }
    var contrast: UIColor { get }
    var nutralLight: UIColor { get }
    var nutral: UIColor { get }
    var nutralDark: UIColor { get }
}

struct Theme: ThemeProtocol {
    
    var primary: UIColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
    
    var secondary: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    var tertiary: UIColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    
    var accent: UIColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    
    var contrast: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) ///Black
    
    var nutralLight: UIColor = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8196078431, alpha: 1)
    
    var nutral: UIColor = #colorLiteral(red: 0.3098039216, green: 0.3019607843, blue: 0.3176470588, alpha: 1)
    
    var nutralDark: UIColor = #colorLiteral(red: 0.1215686275, green: 0.1137254902, blue: 0.1333333333, alpha: 1)

}
