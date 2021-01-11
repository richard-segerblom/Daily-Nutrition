//
//  Service.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-27.
//

import Foundation
import Combine

final class Service {
    
    func searchFood(searchPhrase: String) -> AnyPublisher<SearchResult, Error> {
        let request = URLRequest(url: Endpoint.search(searchPhrase: searchPhrase).url)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: SearchResult.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
