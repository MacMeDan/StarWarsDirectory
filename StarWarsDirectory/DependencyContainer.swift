//
//  DependencyContainer.swift
//  StarWarsDirectory
//
//  Created by Dan Leonard on 4/18/18.
//  Copyright © 2018 MacMeDan. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class DependencyContainer {
    /// - Tag: DependencyInjection
    // MARK: Providers
    static var infoDictionary = Bundle.main.infoDictionary!
    
    lazy var versionProvider: VersionProviderProtocol = VersionProvider(info: DependencyContainer.infoDictionary)

    // MARK: Services
    lazy var contatcService = ContactService(factory: self)
    
    lazy var sessionManager = SessionManager(configuration: .default)

}

// MARK: - Factories -

// MARK: View Controllers
protocol ViewControllerFactory {
    func create<T: UIViewController>(from storyboardName: String, _ identifier: String?) -> T
}

extension DependencyContainer: ViewControllerFactory {
    
    func create<T>(from storyboardName: String, _ identifier: String? = nil) -> T where T: UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let viewController: UIViewController?
        
        if let identifier = identifier {
            viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        } else {
            viewController = storyboard.instantiateInitialViewController()
        }
        
        guard let result = viewController as? T else {
            fatalError("Unable to create {\(T.self)} from storyboard {\(storyboardName)} with identifier {\(identifier ?? "None")}")
        }
        return result
    }
    
}

// MARK: - Services -

// MARK: SessionManager

protocol SessionManagerFactory: class {
    func makeSessionManager() -> SessionManager
}

extension DependencyContainer: SessionManagerFactory {
    func makeSessionManager() -> SessionManager {
        return sessionManager
    }
}

protocol ServiceFactory: class {
    func makeContactService() -> ContactServiceProtocol
}

extension DependencyContainer: ServiceFactory {
    func makeContactService() -> ContactServiceProtocol {
        return contatcService
    }
}

// MARK: - Providers -

// MARK: VersionProvider

protocol VersionProviderFactory: class {
    func makeVersionProvider() -> VersionProviderProtocol
}

extension DependencyContainer: VersionProviderFactory {
    func makeVersionProvider() -> VersionProviderProtocol {
        return versionProvider
    }
}

protocol StyleManagerFactory: class {
    func makeStyleManager() -> StyleManagerProtocol
}

extension DependencyContainer: StyleManagerFactory {
    func makeStyleManager() -> StyleManagerProtocol {
        return StyleManager()
    }
}
