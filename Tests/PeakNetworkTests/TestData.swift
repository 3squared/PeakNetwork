//
//  TestEntity.swift
//  PeakNetwork
//
//  Created by Sam Oakley on 09/12/2016.
//  Copyright © 2016 3Squared. All rights reserved.
//

import Foundation
@testable import PeakNetwork

struct TestEntity: Codable {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

struct MyAPI: JSONWebAPI {
    let baseURL = URL("https://example.com/")
    let encoder: JSONEncoder = JSONEncoder()
    let decoder: JSONDecoder = JSONDecoder()
    let queryItems = ["token": "hello"].queryItems
    let headers = ["user-agent": "peaknetwork"]
}

extension MyAPI {
    
    func simple() -> Resource<TestEntity> {
        return resource(.get, path: "all")
    }
    
    func queryParams(_ params: [URLQueryItem]) -> Resource<TestEntity> {
        return resource(.get, path: "query", queryItems: params)
    }
    
    func complex(_ entity: TestEntity) -> Resource<Void> {
        return resource(.put,
                        path: "upload",
                        queryItems: ["search": "test"].queryItems,
                        headers: ["user-agent": "overridden", "device": "iphone"],
                        body: entity)
    }
    
    func data() -> Resource<Data> {
        return resource(.get,
                        path: "query")
    }
    
    func complexWithResponse(_ entity: TestEntity) -> Resource<TestEntity> {
        return resource(.put,
                        path: "upload",
                        queryItems: ["token": "overridden", "search": "test"].queryItems,
                        headers: ["user-agent": "overridden", "device": "iphone"],
                        body: entity)
    }
    
    func url(_ url: URL) -> Resource<Data> {
        return Resource<Data>(method: .get, url: url, headers: [:]) { data in
            return data!
        }
    }
}
