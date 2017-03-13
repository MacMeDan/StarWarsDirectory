//
//  PersistantData.swift
//  StarWarsDirectory
//
//  Created by P D Leonard on 3/8/17.
//  Copyright © 2017 MacMeDan. All rights reserved.
//

import Foundation
import SQLite

struct PersistedData {
    
    static let PersistCharactersDidFinishNotification = "PersistCharactersDidFinishNotification"
    private static let CurrentVersion = 1
    // If the database is changed the version number needs to be updated and a updateDatabaseFromVersion(Int, toVersion: Int) method needs to be implimented.
    
    static let shared: PersistedData? = PersistedData()
    private let connection: Connection
    private let charicters = Table("charicters")
    private let firstName = Expression<String>("first_name")
    private let lastName = Expression<String?>("last_name")
    private let birthDate = Expression<String?>("birthdate")
    private let pictureURL = Expression<String?>("picture")
    private let affiliation = Expression<String?>("affiliation")
    private let forceSensitive = Expression<Bool?>("forceSensitive")

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
            try connection.run(charicters.create { tableBuilder in
                tableBuilder.column(firstName, primaryKey:true)
                tableBuilder.column(lastName)
                tableBuilder.column(birthDate)
                tableBuilder.column(pictureURL)
                tableBuilder.column(affiliation)
                tableBuilder.column(forceSensitive)
            })
            connection.userVersion = 1
        }
    }
    
    private static func dbPath() -> String? {
        if let appSupport = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first , (try? FileManager.default.createDirectory(atPath: appSupport, withIntermediateDirectories: true, attributes: nil)) != nil {
            return appSupport + "/Charicters.sqlite"
        }
        return nil
    }
    
    func persistJSONCharicters(charactersJSON: [String: Any]) throws {
        try connection.transaction {
            guard let individuals = charactersJSON["individuals"] as? [Dictionary<String, Any>] else {
                return assertionFailure("Could not parse JSON")
            }
            for characterJSON in individuals {
            let firstName      = characterJSON["firstName"] as? String ?? ""
            let lastName       = characterJSON["lastName"] as? String ?? ""
            let birthDate      = characterJSON["birthdate"] as? String ?? ""
            let forceSensitive = characterJSON["forceSensitive"] as? Bool ?? false
            let picture        = characterJSON["profilePicture"] as? String ?? ""
            let affiliation    = characterJSON["affiliation"] as? String ?? ""
                
            try self.connection.run(self.charicters.insert(or: OnConflict.replace, self.firstName <- firstName, self.lastName <- lastName, self.birthDate <- birthDate, self.affiliation <- affiliation, self.pictureURL <- picture, self.forceSensitive <- forceSensitive))
        }
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: PersistedData.PersistCharactersDidFinishNotification), object: nil)
        }
        
    }
    
    func charicterWith(firstName: String) -> Character? {
        if firstName == "" { return nil }
        let charicter = try? connection.pluck(charicters.filter(self.firstName == firstName))
        if let charicter1 = charicter {
            if let charicterRow2 = charicter1 {
                return charicterFromRow(row: charicterRow2)
            }
        }
        return nil
    }
    
    func charicterFromRow(row: Row) -> Character {
        return Character(firstName: row[firstName], lastName: row[lastName] ?? "", birthDate: row[birthDate] ?? "", forceSensitive: row[forceSensitive] ?? false, picture: row[pictureURL] ?? "", affiliation: row[affiliation] ?? "")
    }
    
    func allCharicters() -> [Character] {
        guard let query = (try? connection.prepare(charicters))?.flatMap({$0}) else {
            print("Failed to get order Characters query")
            return []
        }
        return Array(query).map { row in
            self.charicterFromRow(row: row)
        }
    }
    
    func deleteAllCharicters() {
        guard (try? connection.run(self.charicters.delete())) != nil else {
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
