//
//  BaseService.swift
//  StarWarsDirectory
//
//  Created by Dan Leonard on 4/18/18.
//  Copyright © 2018 MacMeDan. All rights reserved.
//

import Alamofire

protocol BaseServiceProtocol {
    /// Session manager.
    var sessionManager: SessionManager { get }

}

class BaseService: BaseServiceProtocol {
    typealias BaseFactory = SessionManagerFactory 
    
    let sessionManager: SessionManager
    
    init(factory: BaseFactory) {
        sessionManager = factory.makeSessionManager()
    }
}

struct WrappedObjects<T: Decodable>: Decodable {
    let objects: [T]
}
