//
//  Charicter.swift
//  StarWarsDirectory
//
//  Created by P D Leonard on 3/8/17.
//  Copyright © 2017 MacMeDan. All rights reserved.
//

struct Character {
    let firstName: String
    let lastName: String
    let birthDate: String
    let picture: String
    let forceSensitive: Bool
    let affiliation: String
    
    init(firstName: String, lastName: String, birthDate: String, forceSensitive: Bool,picture:String, affiliation: String ) {
        self.firstName      = firstName
        self.lastName       = lastName
        self.birthDate      = birthDate
        self.forceSensitive = forceSensitive
        self.picture        = picture
        self.affiliation    = affiliation
    }
}
