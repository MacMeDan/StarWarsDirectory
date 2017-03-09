//
//  DirectoryTableViewController.swift
//  StarWarsDirectory
//
//  Created by P D Leonard on 3/8/17.
//  Copyright © 2017 MacMeDan. All rights reserved.
//

import UIKit

class DirectoryTableViewController: UITableViewController {
    let reuseIdentifier = "characterReuseIdentifier"
    var characters = [Character]()
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            //UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier) as CharacterTableViewCell
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
        let profile = ProfileVC(character: character)
        self.navigationController?.pushViewController(profile, animated: true)
    }
    
}
