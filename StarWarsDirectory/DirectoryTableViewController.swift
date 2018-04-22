//
//  DirectoryTableViewController.swift
//  StarWarsDirectory
//
//  Created by P D Leonard on 7/8/17.
//  Copyright © 2017 MacMeDan. All rights reserved.
//

import UIKit
import StarWars

class DirectoryTableViewController: UIViewController {
    
    var contacts = [Contact]() {
        didSet {
            tableView.reloadData()
        }
    }

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTable()
        
        perpareNavigationBar()
        perpareTable()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: "PersistContactsDidFinishNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: "newEntry"), object: nil)
        loadData()
    }
    
    func prepareTable() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func perpareTable() {
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.reuseIdentifier)
        tableView.removeLines()
    }
    
    private func perpareNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContact))
        let item: UINavigationItem = UINavigationItem(title: "Contact list")
            item.rightBarButtonItem = addButton
        navigationController!.navigationBar.setItems([item], animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Keeps the stars form colliding
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 0.0
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1, animations: {
            self.view.alpha = 1.0
        })
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UINavigationController, let charicter = sender as? Contact, let settings = destination.topViewController as? ProfileViewController {
            destination.transitioningDelegate = self
                settings.contact = charicter
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}

private extension  DirectoryTableViewController {
   @objc func addContact() {
        navigationController?.pushViewController(AddContactViewController(), animated: true)
    }
    
    @objc func loadData() {
        DispatchQueue.main.async {
            self.reloadDataWith(contacts: PersistedData.shared?.allContacts())
        }
    }
    
    func reloadDataWith(contacts: [Contact]?) {
        guard let contacts = contacts else {
            self.contacts = []
            return
        }
        self.contacts = contacts.sorted(by: { $0.firstName < $1.firstName })
    }
}

extension DirectoryTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.reuseIdentifier) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        let contact = contacts[indexPath.item]
        cell.mainLabel.text = contact.firstName + " " + contact.lastName
        cell.subLabel.text = contact.affiliation ?? contact.zip
        if let pictureData = contact.picture {
            cell.picture.image = UIImage(data: pictureData)
        } else {
            cell.picture.setRemoteImage(defaultImage: #imageLiteral(resourceName: "BlankAvatar"), imageURL: URL(string:  contact.pictureURL), completion: { data in
                if let data = data {
                    PersistedData.shared?.updatePictureFor(contact: contact, with: data)
                }
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = contacts[indexPath.item]
        performSegue(withIdentifier: "showProfileView", sender: contact)
    }
}

// MARK: Dizolve Animation
/// - Tag: DizolveAnimation
extension DirectoryTableViewController: UIViewControllerTransitioningDelegate {
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return StarWarsGLAnimator()
    }

    
}

