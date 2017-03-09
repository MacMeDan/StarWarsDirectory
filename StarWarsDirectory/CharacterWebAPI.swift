//
//  characterWebAPI.swift
//  StarWarsDirectory
//
//  Created by P D Leonard on 3/8/17.
//  Copyright © 2017 MacMeDan. All rights reserved.
//

import Alamofire

func syncCharacters() {
    let request = Alamofire.request(API.directory)
    request.validate().responseJSON { response in
        switch response.result {
        case .success:
            guard let json = response.result.value as? [String: Any] else {
                return assertionFailure("Unable to parse data")
            }
            do { try PersistedData.shared?.persistJSONCharicters(charactersJSON: json)
            } catch let error {
                print("Failed to persist characters: \(error)")
            }
            
        case .failure(let error):
            print("Failed to get characters: \(error)")
        }
    }
}
