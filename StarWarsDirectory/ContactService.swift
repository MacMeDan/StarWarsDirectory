//
//  ContactService.swift
//  StarWarsDirectory
//
//  Created by Dan Leonard on 4/18/18.
//  Copyright © 2018 MacMeDan. All rights reserved.
//

import Foundation
import Alamofire

protocol ContactServiceProtocol {
    
    /// Sync Contacts
    func sync()
    
}

class ContactService: ContactServiceProtocol {
    
    typealias Factory =  SessionManagerFactory
    let factory: Factory
    
    init(factory: Factory) {
        self.factory = factory
    }
    
    /// - Tag: REST
    func sync() {
        let request = Alamofire.request(EndpointProvider().directory)
        request.validate().responseJSON { response in
            switch response.result {
            case .success:
                guard let json = response.result.value as? [String: Any] else {
                    return assertionFailure("Unable to parse data")
                }
                do { try PersistedData.shared?.persistJSONContacts(contactsJSON: json)
                } catch let error {
                    Log.error(error, logs: [.services])
                }
                
            case .failure(let error):
                Log.error(error, message: "Failed to get Contacts", logs: [.services])
            }
        }
    }
    
}
