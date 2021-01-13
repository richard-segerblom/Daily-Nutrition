//
//  MealStorageController.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-03.
//

import Foundation
import Combine

final class MealStorageController: ObservableObject {
    @Published var meals: [MealController] = []
    
    let persistenceController: PersistenceController
    let userController: UserController
    
    private var cancellable: AnyCancellable?
    
    init(persistenceController: PersistenceController, userController: UserController) {
        self.persistenceController = persistenceController
        self.userController = userController
        
        cancellable = self.userController.$user.sink { newUser in
            guard let user = newUser else { return }
            self.meals.forEach { $0.required = user.nutritionProfile }
        }
    }
    
    func deleteMeal(atOffsets offsets: IndexSet) {
        meals.remove(atOffsets: offsets)
    }
}
