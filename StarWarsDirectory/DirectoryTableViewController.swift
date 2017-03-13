//
//  DirectoryTableViewController.swift
//  StarWarsDirectory
//
//  Created by P D Leonard on 3/8/17.
//  Copyright © 2017 MacMeDan. All rights reserved.
//

import UIKit
import StarWars

class DirectoryTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let reuseIdentifier = "characterCellIdentifier"
    var characters = [Character]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        perpareNavigationBar()
        perpareTable()
        NotificationCenter.default.addObserver(self, selector: #selector(initialDataLoad), name: NSNotification.Name(rawValue: "PersistCharactersDidFinishNotification"), object: nil)
        reloadDataWith(characters: PersistedData.shared?.allCharicters())
    }
    
    func perpareTable() {
        title = "Character list"
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.removeLines()
        tableView.separatorColor = UIColor(string: "#1f1d22")
    }
    
    fileprivate func perpareNavigationBar() {
        navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController!.navigationBar.shadowImage = UIImage()
        navigationController!.navigationBar.isTranslucent = true
        navigationController!.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white
        ]
    }
    
    func initialDataLoad() {
        DispatchQueue.main.async {
            self.reloadDataWith(characters: PersistedData.shared?.allCharicters())
        }
    }
    
    func reloadDataWith(characters: [Character]?) {
        guard let characters = characters else {
            self.characters = []
            return
        }
        self.characters = characters
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? CharacterTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        let character = characters[indexPath.item]
        cell.mainLabel.text = character.firstName + " " + character.lastName
        cell.subLabel.text = character.affiliation
        let imageURL = URL(string: character.picture)
        
        cell.picture.setRemoteImage(defaultImage: UIImage(), imageURL: imageURL)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = characters[indexPath.item]
        performSegue(withIdentifier: "showProfileView", sender: character)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UINavigationController, let charicter = sender as? Character, let settings = destination.topViewController as? ProfileViewController {
            destination.transitioningDelegate = self
                settings.character = charicter
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
}

extension DirectoryTableViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return StarWarsGLAnimator()
    }
}

