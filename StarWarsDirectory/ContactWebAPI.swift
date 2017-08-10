//
//  ContactWebAPI.swift
//  StarWarsDirectory
//
//  Created by P D Leonard on 7/8/17.
//  Copyright © 2017 MacMeDan. All rights reserved.
//

import Alamofire

func syncContacts() {
    let request = Alamofire.request(API.directory)
    request.validate().responseJSON { response in
        switch response.result {
        case .success:
            guard let json = response.result.value as? [String: Any] else {
                return assertionFailure("Unable to parse data")
            }
            do { try PersistedData.shared?.persistJSONContacts(contactsJSON: json)
            } catch let error {
                print("Failed to persist Contacts: \(error)")
            }
            
        case .failure(let error):
            print("Failed to get Contacts: \(error)")
        }
    }
}
