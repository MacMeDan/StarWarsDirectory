//
//  API.swift
//  StarWarsDirectory
//
//  Created by P D Leonard on 3/8/17.
//  Copyright © 2017 MacMeDan. All rights reserved.
//
// This is a little over engineered but allows for more endpoints to all
//  be in a single place with a simple interface that handles errors.

import Alamofire
let baseURL = "https://edge.ldscdn.org/mobile/interview/"
enum APIError: Error {
    case invalidURL
}

enum API: URLConvertible {
    case directory
    internal func asURL() throws -> URL {
        switch self {
        case .directory:
            return try getURL(path:"directory")
        }
    }
    
    
    private func getURL(path: String) throws -> URL {
        guard let url = URL(string: baseURL + path) else {
            throw APIError.invalidURL
        }
        return url
    }
}
