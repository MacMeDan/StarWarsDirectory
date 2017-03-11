//
//  DirectoryTableViewController.swift
//  StarWarsDirectory
//
//  Created by P D Leonard on 3/8/17.
//  Copyright © 2017 MacMeDan. All rights reserved.
//

import UIKit
import StarWars

class DirectoryTableViewController: UITableViewController {
    let reuseIdentifier = "characterReuseIdentifier"
    var characters = [Character]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Character list"
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.removeLines()
        NotificationCenter.default.addObserver(self, selector: #selector(initialDataLoad), name: NSNotification.Name(rawValue: "PersistCharactersDidFinishNotification"), object: nil)
        reloadDataWith(characters: PersistedData.shared?.allCharicters())
    }
    
    func initialDataLoad() {
        DispatchQueue.main.async {
            self.reloadDataWith(characters: PersistedData.shared?.allCharicters())
        }
    }
    
    @IBAction func setupYourProfileTapped(_ sender: ProfileButton) {
        sender.animateTouchUpInside {
            self.performSegue(withIdentifier: "presentSettings", sender: sender)
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? CharacterTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = UIColor(string: "#f8f8f8")
        let character = characters[indexPath.item]
        cell.mainLabel.text = character.firstName + " " + character.lastName
        cell.subLabel.text = character.affiliation
        let imageURL = URL(string: character.picture)
        
        cell.picture.setRemoteImage(defaultImage: UIImage(), imageURL: imageURL)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = characters[indexPath.item]
        let settingsView = SettingsViewController(character: character)
        self.present(settingsView, animated: true, completion: nil)
    }
}

extension DirectoryTableViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return StarWarsGLAnimator()
    }
}

