//
//  EndpointProvider.swift
//  StarWarsDirectory
//
//  Created by Dan Leonard on 4/18/18.
//  Copyright © 2018 MacMeDan. All rights reserved.
//

import Foundation

class EndpointProvider {
    
    var baseURL: URL {
        guard let baseURL = URL(string: "https://edge.ldscdn.org") else {
            assertionFailure("Could not retrive baseURL")
            return URL(string: "")!
        }
        return baseURL
            .appendingPathComponent("moblile")
            .appendingPathComponent("interview")
    }
    
    var directory: URL {
        return baseURL
            .appendingPathComponent("directory")
    }
    
}
