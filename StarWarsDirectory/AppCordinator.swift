//
//  AppCordinator.swift
//  StarWarsDirectory
//
//  Created by Dan Leonard on 4/18/18.
//  Copyright © 2018 MacMeDan. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: NSObject {
    
    private var application: UIApplication?
    var window: UIWindow?
    
    static let shared = AppCoordinator()
    var dependencyContainer: DependencyContainer!

    /// - Tag: Logs
    private func enableLogging() {
        // Just comment out logs that you don't want enabled. Don't delete lines.
        Log.enable(logs: [
            .models,
            .persistence,
            .network,
            .services,
            .viewModels,
            .views,
            ], includeMetaData: true)
    }
    
    private override init() {
        super.init()
    }
    
    func application(_ application: UIApplication, didLaunchWith launchOptions: [UIApplicationLaunchOptionsKey: Any]?, dependencyContainer: DependencyContainer) -> Bool {
        enableLogging()
        self.application = application
        self.dependencyContainer = dependencyContainer
        //TODO: Move to more appropriate place
        let contactService = dependencyContainer.makeContactService()
        contactService.sync()
        configureStyles()
        return true
    }
    
}

// MARK: - Private Methods
/// NOTE: Wrapped in a private Extensiton which allows you to omit the `private` keyword before each method while maintaining only the file can access the methods.

private extension AppCoordinator {
    
    func configureStyles() {
        let styleManager = dependencyContainer.makeStyleManager()
        styleManager.configureStyles(theme: Theme())
    }
    
}
