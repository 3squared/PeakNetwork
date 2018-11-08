//
//  JSONRecordingLogger.swift
//  PeakNetwork
//
//  Created by Luke Stringer on 01/10/2018.
//  Copyright © 2018 3Squared. All rights reserved.
//

import Foundation

public class RecordingJSONLogger: Logger {
    fileprivate var idToRequestURL = [UUID: URL]()
    
    let fileWriter: WriteFile
    
    public init(fileWriter: WriteFile = FileWriter()) {
        self.fileWriter = fileWriter
    }
    
    public func log(id: UUID, requestDate: Date, request: URLRequest) {
        guard let url = request.url else { return }
        idToRequestURL[id] = url
    }
    
    public func log(id: UUID, requestDate: Date, responseDate: Date, data: Data?, response: URLResponse?, error: Error?) {
        guard
            let requestURL = idToRequestURL[id],
            let host = requestURL.host
            else { return }
        
        let toWrite = fileContents(from: data, response: response)
        
        let queryAppend = requestURL.query.flatMap { "-" + $0 } ?? ""
        
        let filename = (host + "-" + requestURL.path + queryAppend + ".txt")
            .replacingOccurrences(of: "/", with: "-")
            .replacingOccurrences(of: "&", with: "-")
        
        fileWriter.write(toWrite, toFileNamed: filename)
    }
    
    private func fileContents(from data: Data?, response: URLResponse?) -> String {
        
        if let rawData = data,
            let json = try? JSONSerialization.jsonObject(with: rawData, options: .allowFragments),
//             TODO: Check json is Array of Dictionary
            let prettyJSONData = try? JSONSerialization.data(withJSONObject: json, options: [.sortedKeys, .prettyPrinted]),
            let jsonString = String(data: prettyJSONData, encoding: String.Encoding.utf8) {
            return jsonString
        }
        else if let httpResponse = response as? HTTPURLResponse  {
            return "Returned with HTTP Status Code \(httpResponse.statusCode)"
        }
        return "Unknown Response"
    }
}

public protocol WriteFile {
    func write(_ string: String, toFileNamed filename: String)
}

public struct FileWriter: WriteFile {
    public init() {
        // DO nothing
    }
    
    public func write(_ string: String, toFileNamed filename: String) {
        if let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = documents.appendingPathComponent(filename)
            
            do {
                try string.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {
                print("Failed to write JSON with error: \n \(error)")
            }
        }
        else {
            print("Failed to get Documents Directory URL")
        }
    }
}
