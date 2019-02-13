//
//  JSONRecordingLogger.swift
//  PeakNetwork
//
//  Created by Luke Stringer on 01/10/2018.
//  Copyright © 2018 3Squared. All rights reserved.
//

import Foundation

public class RecordingLogger: Logger {
    
    fileprivate var idToURLRequestMap = [UUID: URLRequest]()
    
    let writer: WriteRecording
    
    public init(writer: WriteRecording = FileWriter()) {
        self.writer = writer
    }
    
    public func log(id: UUID, requestDate: Date, request: URLRequest) {
        idToURLRequestMap[id] = request
    }
    
    public func log(id: UUID, requestDate: Date, responseDate: Date, data: Data?, response: URLResponse?, error: Error?) {
        guard
            let urlRequest = idToURLRequestMap[id],
            let urlResponse = response as? HTTPURLResponse,
            let method = urlRequest.httpMethod,
            let url = urlRequest.url,
            let requestHeaders = urlRequest.allHTTPHeaderFields
            else { return }
        
        let requestBodyString = urlRequest.httpBody.flatMap { String(data: $0, encoding: String.Encoding.utf8) }
        let responseBodyString = data.flatMap { String(data: $0, encoding: String.Encoding.utf8) }
        
        let path = url.path
        
        let responseHeaders = urlResponse.allHeaderFields
            .compactMap { (key, value) -> Recording.Headers? in
                guard let stringKey = key as? String, let stringValue = value as? String else {
                    print("Cannot convert response headers to strings")
                    return nil
                }
                return [stringKey: stringValue]
                
            }
            .reduce(Recording.Headers()) { (current, next) -> Recording.Headers in
                return current.merging(next) { (first, _) in first }
        }
        
        let request = Recording.Request(headers: requestHeaders, body: requestBodyString)
        let response = Recording.Response(status: urlResponse.statusCode, headers: responseHeaders, body: responseBodyString)
        let times = Recording.Times(start: requestDate, end: responseDate)
        let recording = Recording(method: method, host: url.host, path: path, query: url.query, times: times, request: request, response: response)
        
        writer.write(recording, toFileNamed: "\(Int(requestDate.timeIntervalSince1970)).json" )
        
    }
}

public struct Recording: Codable {
    public struct Times: Codable {
        // Encode to ISO date strings
        let start: Date
        let end: Date
    }
    
    public typealias Headers = [String: String]
    
    public struct Request: Codable {
        let headers: Headers
        let body: String?
    }
    
    public struct Response: Codable {
        let status: Int
        let headers: Headers
        let body: String?
    }
    
    let method: String
    let host: String?
    let path: String
    let query: String?
    let times: Times
    
    let request: Request
    let response: Response
    
}

public protocol WriteRecording {
    func write(_ recording: Recording, toFileNamed filename: String)
}

public struct FileWriter: WriteRecording {
    public init() {}
    
    public func write(_ recording: Recording, toFileNamed filename: String) {
        guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Failed to get Documents Directory URL")
            return
        }
        
        let fileURL = documents.appendingPathComponent(filename)
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(recording)
            guard let string = String(data: data, encoding: String.Encoding.utf8) else {
                print("Failed to convert data to String")
                return
            }
            print(string)
            try string.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch {
            print("Failed to write JSON with error: \n \(error)")
        }
        
    }
}

