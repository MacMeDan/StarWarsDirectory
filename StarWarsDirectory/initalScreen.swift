//
//  initalScreen.swift
//  StarWarsDirectory
//
//  Created by P D Leonard on 3/9/17.
//  Copyright © 2017 MacMeDan. All rights reserved.
//

import UIKit

import UIKit
import StarWars

class IntroViewController: UIViewController {
    
    @IBOutlet fileprivate var topContraint: NSLayoutConstraint!
    @IBOutlet weak var button: ProfileButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topContraint.isActive = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1) {
            self.topContraint.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    
    
}

//extension IntroViewController: UIViewControllerTransitioningDelegate {
//    
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        //        return StarWarsUIDynamicAnimator()
//        //        return StarWarsUIViewAnimator()
//        return StarWarsGLAnimator()
//    }
//}

