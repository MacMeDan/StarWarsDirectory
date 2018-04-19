//
//  VersionProvider.swift
//  StarWarsDirectory
//
//  Created by Dan Leonard on 4/18/18.
//  Copyright © 2018 MacMeDan. All rights reserved.
//

protocol VersionProviderProtocol {
    /// `"releaseVersionNumber (buildVersionNumber) buildDescriptor"`
    /// Example: `1.1.0 (35)`
    /// - note: `buildDescriptor` is optional if it exists
    var versionString: String { get }
    
    /// The version number (`CFBundleShortVersionString`):
    /// Example: `1.1.0`
    var releaseVersionNumber: String { get }
    
    /// The build number (`CFBundleVersion`):
    /// Example: `35`
    var buildVersionNumber: String { get }
    
    /// Custom build descriptor set by `BuildDescriptor` in Info.plist
    var buildDescriptor: String? { get }
}

class VersionProvider: VersionProviderProtocol {
    
    enum Error: Swift.Error {
        case missingKey(String)
        
        var localizedDescription: String {
            switch self {
            case .missingKey(let key):
                return "Missing key: \(key)"
            }
        }
    }
    
    private let info: [String: Any]
    
    init(info: [String: Any]) {
        self.info = info
    }
    
    var versionString: String {
        if let buildDescriptor = buildDescriptor {
            return "\(releaseVersionNumber) (\(buildVersionNumber)) \(buildDescriptor)"
        } else {
            return "\(releaseVersionNumber) (\(buildVersionNumber))"
        }
    }
    
    var releaseVersionNumber: String {
        do {
            return try infoValue(forKey: "CFBundleShortVersionString")
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    var buildVersionNumber: String {
        do {
            return try infoValue(forKey: "CFBundleVersion")
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    var buildDescriptor: String? {
        return try? infoValue(forKey: "BuildDescriptor")
    }
    
    private func infoValue(forKey key: String) throws -> String {
        guard let value = info[key] as? String else {
            throw Error.missingKey(key)
        }
        return value
    }
}
