//
//  Formater.swift
//  StarWarsDirectory
//
//  Created by Dan Leonard on 4/21/18.
//  Copyright © 2018 MacMeDan. All rights reserved.
//

import Foundation

struct Format {

    private init() {}
    
    // PhoneNumber
    struct PhoneNumber {
        
        private init() {}
        
        static func phoneNumberString(for phoneNumber: String) -> String {
            return PhoneNumberFormatter().string(from: phoneNumber)
        }
        
    }
}
