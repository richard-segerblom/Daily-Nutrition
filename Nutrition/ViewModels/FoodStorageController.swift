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
    
    func foodProfiles(food: Food) -> FoodController {
        return FoodController(food: food, required: userController.profile, persistenceController: persistenceController)
    }

    // TODO - Should check for change notification and fetch then
    func fetchFood() {
        let foods = CDFood.all(context: persistenceController.container.viewContext).map {
            FoodController(food: $0, required: userController.profile, persistenceController: persistenceController)
        }
            
        self.foods = foods
    }
}
