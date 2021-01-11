//
//  SearchController.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-29.
//

import Foundation
import Combine

final class SearchController: ObservableObject {
    @Published var result: [FoodController] = []
    
    let service: Service
    let required: NutritionProfile
    let persistenceController: PersistenceController
    
    private var cancellable: AnyCancellable!
    
    init(required: NutritionProfile, persistenceController: PersistenceController, service: Service = Service()) {
        self.required = required
        self.persistenceController = persistenceController
        self.service = service
    }
    
    func searchFood(searchPhrase: String = "Apple") {
        // TODO show loader
        cancellable = service.searchFood(searchPhrase: searchPhrase)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    // TODO show error message
                    print("Error: \(error.localizedDescription)")
                case .finished: break
                }
            }) { searchResult in
                self.result = searchResult.foods.map { FoodController(food: $0, required: self.required, persistenceController: self.persistenceController) }
            }
    }
}
