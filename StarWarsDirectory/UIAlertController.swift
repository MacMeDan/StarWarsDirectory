//
//  UIAlertController.swift
//  StarWarsDirectory
//
//  Created by Dan Leonard on 4/21/18.
//  Copyright © 2018 MacMeDan. All rights reserved.
//

import UIKit

extension UIAlertController {
    /// - Tag: AlertController
    func presentOnTop() {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(self, animated: true, completion: nil)
        }
    }
}
