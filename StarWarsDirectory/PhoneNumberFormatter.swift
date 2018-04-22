//
//  PhoneNumberFormatter.swift
//  StarWarsDirectory
//
//  Created by Dan Leonard on 4/21/18.
//  Copyright © 2018 MacMeDan. All rights reserved.
//

import Foundation

// PhoneNumber
class PhoneNumberFormatter: Formatter {
    
    func string(from stringToFormat: String) -> String {
        // Force unwrapping because the below code gurantees that we'll have a value
        // because we're passing in a String object.
        return self.string(for: stringToFormat)!
    }
    
    override func string(for obj: Any?) -> String? {
        
        // The object must be a string
        guard let string = obj as? String else {
            return nil
        }
        
        // Remove the international prefix and any non-digit characters from the string
        guard let sanitized = string
            .components(separatedBy: "+")
            .last?
            .replacingCharacters(in: CharacterSet.decimalDigits.inverted, with: "")
            else {
                return string
        }
        var s = sanitized
        
        let start = s.startIndex
        
        switch s.count {
        case 4...7:
            s.insert("-", at: s.index(start, offsetBy: 3))
            return s
        case 7...11:
            if s.count == 11 {
                s = String(s.dropFirst())
            }
            s.insert("(", at: start)
            s.insert(")", at: s.index(start, offsetBy: 4))
            s.insert(" ", at: s.index(start, offsetBy: 5))
            s.insert("-", at: s.index(start, offsetBy: 9))
            return s
        default:
            return s
        }
    }
}

fileprivate extension String {
    func replacingCharacters(in characterSet: CharacterSet, with replacement: String) -> String {
        return components(separatedBy: characterSet).joined(separator: replacement)
    }
}
