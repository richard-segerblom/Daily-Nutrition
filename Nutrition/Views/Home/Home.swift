//
//  ContentView.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-27.
//

import SwiftUI
import CoreData

struct Home: View {
    let app: AppController
    @ObservedObject var userController: UserController
    
    @State private var isProfilePresented = false
    
    @Environment(\.horizontalSizeClass) var sizeClass    
        
    init(app: AppController) {
        self.app = app
        self.userController = app.user
        
        UINavigationBar.setTransparentBackground()
    }

    var body: some View {
        NavigationView {
            Group {
                if sizeClass == .compact {
                    HomeCompactLayout(consumedStorage: app.consumedStorage,
                                      foodStorage: app.foodStorage,
                                      mealStorage: app.mealStorage,
                                      userController: app.user)
                } else {
                    HomeRegularLayout(consumedStorage: app.consumedStorage,
                                      foodStorage: app.foodStorage,
                                      mealStorage: app.mealStorage)
                }
            }
            .overlay(registration())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar() {
                ToolbarItem(placement: .principal) { Text(Date(), style: .date).font(.title2) }
                ToolbarItem(placement: .navigationBarTrailing) { profileButton }
            }.foregroundColor(titleColor)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    @ViewBuilder
    func registration() -> some View {
        if !userController.isUserSetUp {
            Registration(userControl: userController)
        }
    }

    var profileButton: some View {
        Button(action: {
            isProfilePresented = true
        }) {
            Image(systemName: "person.crop.circle.fill")
        }
        .sheet(isPresented: $isProfilePresented) { Profile(user: userController) }
        .disabled(!userController.isUserSetUp)
    }
    
    // MARK: - Drawing Constants
    private let titleColor = Color("PrimaryTextColor")
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Home(app: PreviewData.appController)
    }
}
