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
    
    override func viewDidLoad() {
        button.addTarget(self, action: #selector(presentList), for: .touchUpInside)
    }
    
    func presentList() {
        let charicterList = DirectoryTableViewController()
        let nav = UINavigationController(rootViewController: charicterList)
        self.present(nav, animated: true, completion: nil)
    }
    
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
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        destination.transitioningDelegate = self
        if let navigation = destination as? UINavigationController,
            let settings = navigation.topViewController as? MainSettingsViewController {
            settings.theme = .light
        }
    }
}

extension IntroViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //        return StarWarsUIDynamicAnimator()
        //        return StarWarsUIViewAnimator()
        return StarWarsGLAnimator()
    }
}

