//
//  FoodStorage.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-01.
//

import Foundation
import Combine

final class FoodStorageController: ObservableObject {
    @Published var foods: [FoodController] = []
    
    let persistenceController: PersistenceController
    let userController: UserController
    
    private var filter: FoodFilterOption = .all
    
    private var allFood: [FoodController] = []
    private var cancellable: AnyCancellable?
    
    init(persistenceController: PersistenceController, userController: UserController) {
        self.persistenceController = persistenceController
        self.userController = userController
            
        self.fetchFood()
        
        cancellable = self.userController.$user.sink { newUser in
            guard let user = newUser else { return }
            self.foods.forEach { $0.required = user.nutritionProfile }
        }
    }
    
    private func fetchFood() {
        allFood = CDFood.all(context: persistenceController.container.viewContext).map {
            FoodController(food: $0, required: userController.profile, persistenceController: persistenceController)
        }
            
        filter(filter)
    }
    
    func filter(_ filter: FoodFilterOption) {
        self.filter = filter
        
        switch filter {
        case .fruit:
            foods = allFood.filter { $0.category == .fruit }
        case .vegetables:
            foods = allFood.filter { $0.category == .vegetables }
        case .nuts:
            foods = allFood.filter { $0.category == .nuts }
        case .legumes:
            foods = allFood.filter { $0.category == .legumes }
        case .grains:
            foods = allFood.filter { $0.category == .grains }
        case .animal:
            foods = allFood.filter { $0.category == .animal }
        default:
            foods = allFood
        }
    }
}

enum FoodFilterOption {
    case all
    case fruit
    case vegetables
    case nuts
    case legumes
    case grains
    case animal
}
