//
//  Contact.swift
//  StarWarsDirectory
//
//  Created by P D Leonard on 7/8/17.
//  Copyright © 2017 MacMeDan. All rights reserved.
//
import Foundation

struct Contact {
    let firstName:      String
    let lastName:       String
    let birthDate:      String?
    let pictureURL:     String
    let picture:        Data?
    let forceSensitive: Bool
    let affiliation:    String?
    let phoneNumber:    String?
    let zip:            String?
    
    init(firstName: String, lastName: String, birthDate: String?, forceSensitive: Bool = false, pictureURL: String, picture: Data? = nil, affiliation: String? = nil, zip: String?, phoneNumber: String?) {
        self.firstName      = firstName
        self.lastName       = lastName
        self.birthDate      = birthDate
        self.forceSensitive = forceSensitive
        self.pictureURL     = pictureURL
        self.affiliation    = affiliation
        self.zip            = zip
        self.phoneNumber    = phoneNumber
        self.picture        = picture
    }
}
