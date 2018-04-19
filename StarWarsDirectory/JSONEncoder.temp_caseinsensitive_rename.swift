//
//  JsonEncoder.swift
//  StarWarsDirectory
//
//  Created by Dan Leonard on 4/18/18.
//  Copyright © 2018 MacMeDan. All rights reserved.
//

import Foundation

extension JSONEncoder {
    enum Error: Swift.Error {
        case failedToEncodeValueAsJSONParameters(Encodable)
    }
    
    /// Encodes the given top-level value and returns its JSON representation as `Parameters`.
    ///
    /// - parameter value: The value to encode.
    /// - returns: A new `Parameters` value containing the encoded JSON data.
    /// - throws: `EncodingError.invalidValue` if a non-comforming floating-point value is encountered during encoding, and the encoding strategy is `.throw`.
    /// - throws: An error if any value throws an error during encoding.
    func encodeToJSONParameters<T>(_ value: T, options: JSONSerialization.ReadingOptions = .allowFragments) throws -> Parameters where T : Encodable {
        let data = try encode(value)
        guard let jsonParameters = try JSONSerialization.jsonObject(with: data, options: options) as? Parameters else {
            throw Error.failedToEncodeValueAsJSONParameters(value)
        }
        return jsonParameters
}
