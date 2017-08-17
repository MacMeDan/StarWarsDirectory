//
//  PersistantData.swift
//  StarWarsDirectory
//
//  Created by P D Leonard on 7/8/17.
//  Copyright © 2017 MacMeDan. All rights reserved.
//

import Foundation
import SQLite

struct PersistedData {
    
    static let PersistContactsDidFinishNotification = "PersistContactsDidFinishNotification"
    private static let CurrentVersion = 1
    // If the database is changed the version number needs to be updated and a updateDatabaseFromVersion(Int, toVersion: Int) method needs to be implimented.
    
    static let shared: PersistedData? = PersistedData()
    private let connection: Connection
    private let contacts        = Table("contacts")
    private let firstName       = Expression<String>("first_name")
    private let lastName        = Expression<String?>("last_name")
    private let birthDate       = Expression<String?>("birthdate")
    private let pictureURL      = Expression<String?>("pictureURL")
    private let picture         = Expression<Data?>("picture")
    private let affiliation     = Expression<String?>("affiliation")
    private let forceSensitive  = Expression<Bool?>("forceSensitive")
    private let phoneNumber     = Expression<Int?>("phoneNumber")
    private let zip             = Expression<Int?>("zip")

    init?() {
        guard let dbPath = PersistedData.dbPath() else {
            print("Failed to get a valid database path.")
            return nil
        }
        do {
            connection = try Connection(dbPath)
            try updateDatabaseFromVersion(fromVersion: connection.userVersion , toVersion: PersistedData.CurrentVersion)
        } catch let error {
            print("Failed to create database connection to \(dbPath): \(error)")
            return nil
        }
    }
    
    private func updateDatabaseFromVersion(fromVersion: Int, toVersion: Int) throws {
        if fromVersion < 1 {
            try connection.run(contacts.create { tableBuilder in
                tableBuilder.column(firstName, primaryKey:true)
                tableBuilder.column(lastName)
                tableBuilder.column(birthDate)
                tableBuilder.column(pictureURL)
                tableBuilder.column(picture)
                tableBuilder.column(affiliation)
                tableBuilder.column(forceSensitive)
                tableBuilder.column(zip)
                tableBuilder.column(phoneNumber)
            })
            connection.userVersion = 1
        }
    }
    
    private static func dbPath() -> String? {
        if let appSupport = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first , (try? FileManager.default.createDirectory(atPath: appSupport, withIntermediateDirectories: true, attributes: nil)) != nil {
            return appSupport + "/contacts.sqlite"
        }
        return nil
    }
    
    func persistJSONContacts(contactsJSON: [String: Any]) throws {
        try connection.transaction {
            guard let individuals = contactsJSON["individuals"] as? [Dictionary<String, Any>] else {
                return assertionFailure("Could not parse JSON")
            }
            for ContactJSON in individuals {
                let firstName      = ContactJSON["firstName"] as? String ?? ""
                let lastName       = ContactJSON["lastName"] as? String ?? ""
                let birthDate      = ContactJSON["birthdate"] as? String
                let forceSensitive = ContactJSON["forceSensitive"] as? Bool ?? false
                let pictureURL     = ContactJSON["profilePicture"] as? String
                let picture        = ContactJSON["picture"] as? Data
                let affiliation    = ContactJSON["affiliation"] as? String
                let zip            = ContactJSON["zip"] as? Int
                let phoneNumber    = ContactJSON["PhoneNumber"] as? Int
                
                
            try self.connection.run(self.contacts.insert(or: OnConflict.replace, self.firstName <- firstName, self.lastName <- lastName, self.birthDate <- birthDate, self.affiliation <- affiliation, self.pictureURL <- pictureURL, self.picture <- picture, self.forceSensitive <- forceSensitive, self.zip <- zip, self.phoneNumber <- phoneNumber))
        }
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: PersistedData.PersistContactsDidFinishNotification), object: nil)
        }
        
    }
    
    func add(contact: Contact) throws {
        try connection.transaction {
            try self.connection.run(self.contacts.insert(or: OnConflict.replace, self.firstName <- contact.firstName, self.lastName <- contact.lastName, self.birthDate <- contact.birthDate, self.affiliation <- contact.affiliation, self.pictureURL <- contact.pictureURL, self.picture <- contact.picture, self.forceSensitive <- contact.forceSensitive, self.zip <- contact.zip, self.phoneNumber <- contact.phoneNumber))
        }
    }
    
    func contactWith(firstName: String) -> Contact? {
        if firstName == "" { return nil }
        let contact = try? connection.pluck(contacts.filter(self.firstName == firstName))
        if let contact1 = contact {
            if let contactRow2 = contact1 {
                return contactFromRow(row: contactRow2)
            }
        }
        return nil
    }
    
    func contactFromRow(row: Row) -> Contact {
        return Contact(firstName: row[firstName], lastName: row[lastName] ?? "", birthDate: row[birthDate],  forceSensitive: row[forceSensitive] ?? false, pictureURL: row[pictureURL] ?? "", picture: row[picture], affiliation: row[affiliation], zip: row[zip], phoneNumber: row[phoneNumber])
    }
    
    func updatePictureFor(contact: Contact, with data: Data) {
        try? connection.transaction {
        try self.connection.run(self.contacts.insert(or: OnConflict.replace, self.firstName <- contact.firstName, self.lastName <- contact.lastName, self.birthDate <- contact.birthDate, self.affiliation <- contact.affiliation, self.pictureURL <- contact.pictureURL, self.picture <- data, self.forceSensitive <- contact.forceSensitive, self.zip <- contact.zip, self.phoneNumber <- contact.phoneNumber))
        }
    }
    
    func allContacts() -> [Contact] {
        guard let query = (try? connection.prepare(contacts))?.flatMap({$0}) else {
            print("Failed to get order Contacts query")
            return []
        }
        return Array(query).map { row in
            self.contactFromRow(row: row)
        }
    }
    
    func deleteAllCharicters() {
        guard (try? connection.run(self.contacts.delete())) != nil else {
            assertionFailure("Failed to delete all related Charicters patients")
            return
        }
    }
}

fileprivate extension Connection {
    
    var userVersion: Int {
        get {
            return try! Int(scalar("PRAGMA user_version") as? Int64 ?? 0)
        }
        set {
            if (try? run("PRAGMA user_version = \(newValue)")) == nil {
                print("Failed to set user version to \(newValue)")
            }
        }
    }
    
}
