//
//  initalScreen.swift
//  GalacticDirectory
//
//  Created by P D Leonard on 3/9/17.
//  Copyright © 2017 MacMeDan. All rights reserved.
//

import UIKit

import UIKit

class IntroViewController: UIViewController {
    
    @IBOutlet fileprivate var topContraint: NSLayoutConstraint!
    @IBOutlet weak var button: ProfileButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topContraint.isActive = false
    }
    
    @IBAction func setupYourProfileTapped(_ sender: ProfileButton) {
        sender.animateTouchUpInside {}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1) {
            self.topContraint.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
