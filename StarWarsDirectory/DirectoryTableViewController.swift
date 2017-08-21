//
//  DirectoryTableViewController.swift
//  GalacticDirectory
//
//  Created by P D Leonard on 7/8/17.
//  Copyright © 2017 MacMeDan. All rights reserved.
//

import UIKit
import StarWars

class DirectoryTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let reuseIdentifier = "cell"
    var Contacts = [Contact]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        perpareNavigationBar()
        perpareTable()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: "newEntry"), object: nil)
        loadData()
    }
    
    fileprivate func perpareTable() {
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.removeLines()
        tableView.separatorColor = UIColor(string: "#1f1d22")
    }
    
    fileprivate func perpareNavigationBar() {
        navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController!.navigationBar.shadowImage = UIImage()
        navigationController!.navigationBar.isTranslucent = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContact))
        addButton.tintColor = UIColor.white
        let item: UINavigationItem = UINavigationItem(title: "Contact list")
            item.rightBarButtonItem = addButton
        navigationController!.navigationBar.setItems([item], animated: false)
        navigationController!.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white
        ]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Keeps the stars form colliding
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 0.0
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1, animations: {
            self.view.alpha = 1.0
        })
    }

    
    internal func addContact() {
        navigationController?.pushViewController(AddContactViewController(), animated: true)
    }
    
    internal func loadData() {
        DispatchQueue.main.async {
            self.reloadDataWith(Contacts: PersistedData.shared?.allContacts())
        }
    }

    fileprivate func reloadDataWith(Contacts: [Contact]?) {
        guard let Contacts = Contacts else {
            self.Contacts = []
            return
        }
        self.Contacts = Contacts
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        let contact = Contacts[indexPath.item]
        cell.mainLabel.text = contact.firstName + " " + contact.lastName
        cell.subLabel.text = contact.zip?.description ?? ""
        if let pictureData = contact.picture {
            cell.picture.image = UIImage(data: pictureData)
        } else {
            cell.picture.setRemoteImage(defaultImage: UIImage(), imageURL: URL(string:  contact.pictureURL), completion: { data in
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
        let Contact = Contacts[indexPath.item]
        performSegue(withIdentifier: "showProfileView", sender: Contact)
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
// MARK: Dizolve Animation
extension DirectoryTableViewController {
    override func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? { return StarWarsGLAnimator() }
}

