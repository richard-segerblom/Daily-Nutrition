//
//  Endpoint.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-27.
//

import Foundation

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
}

extension Endpoint {
    static let apiKey = "kehuI6IOE7PWZvG1Vz2BfTzjdLZfVB4TCdaDKbMq"
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.nal.usda.gov"
        components.path = "/fdc/v1/foods/" + path
                        
        var items = [URLQueryItem(name: "api_key", value: Endpoint.apiKey)]
        items.append(contentsOf: queryItems)
        components.queryItems = items
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        
        return url
    }
}

extension Endpoint {
    static func search(searchPhrase: String) -> Self {
        return Endpoint(path: "search", queryItems: [URLQueryItem(name: "query", value: searchPhrase)])
    }        
}
