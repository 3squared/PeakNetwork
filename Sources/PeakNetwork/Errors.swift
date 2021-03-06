//
//  Errors.swift
//  PeakNetwork
//
//  Created by Sam Oakley on 13/10/2016.
//  Copyright © 2016 3Squared. All rights reserved.
//

import Foundation


/// Used when an error occurs converting Data to JSON.
public enum SerializationError: Error {
    /// The response contained no data.
    case noData
}

/// Used when a server error occurs.
public enum ServerError: Error {
    case error(code: HTTPStatusCode, data: Data?, response: HTTPURLResponse)
    case unknownResponse
}
