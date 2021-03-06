//
//  HomeCompactLayout.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-02.
//

import SwiftUI

struct HomeCompactLayout: View {
    @ObservedObject var consumedStorage: ConsumedStorageController
    @ObservedObject var foodStorage: FoodStorageController
    @ObservedObject var mealStorage: MealStorageController
    @ObservedObject var userController: UserController
    
    @State private var isConsumedPresented = false
    @State private var isFoodPresented = false
    @State private var isMealPresented = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: verticalSpacing(geometry)) {
                VitaminChart(nutrients: consumedStorage.nutritionToday[.vitamins], title: "VITAMINS",
                         spacing: barSpacing(geometry), barWidth: barWidth(geometry), height: chartHeight(geometry))

                MineralChart(nutrients: consumedStorage.nutritionToday[.minerals], title: "MINERALS", labelLength: 2,
                         spacing: barSpacing(geometry), barWidth: barWidth(geometry), height: chartHeight(geometry))
            
                FlipCard(consumedStorage: consumedStorage)
                
                Spacer()

                HStack(spacing: buttonSpacing) {
                    DefaultButton(title: "MEALS", action: { isMealPresented = true })
                        .sheet(isPresented: $isMealPresented) { MealPicker(mealStorage: mealStorage, foodStorage: foodStorage) }
                    DefaultButton(title: "FOOD", action: { isFoodPresented = true })
                        .sheet(isPresented: $isFoodPresented) { FoodPicker(foodStorage: foodStorage) }
                }
                .frame(maxHeight: buttonMaxHeight(geometry))
            }
            .toolbar() {
                ToolbarItem(placement: .navigationBarLeading) { consumedButton }
            }.foregroundColor(Color.accentColor)
            .padding([.horizontal, .bottom])
        }
    }
    
    var consumedButton: some View {
        Button(action: {
            isConsumedPresented = true
        }) {
            Image(systemName: "clock.fill")
        }
        .sheet(isPresented: $isConsumedPresented) { ConsumedToday(consumedStorageController: consumedStorage) }
        .disabled(!userController.isUserSetUp)
    }
    
    // MARK: - Drawing Constants
    private func verticalSpacing(_ geometry: GeometryProxy) -> CGFloat { 0.02 * geometry.size.height }
    private func barSpacing(_ geometry: GeometryProxy) -> CGFloat { 0.022 * geometry.size.width }
    private func barWidth(_ geometry: GeometryProxy) -> CGFloat { 0.03 * geometry.size.width }
    private func chartHeight(_ geometry: GeometryProxy) -> CGFloat { abs((geometry.size.height / 6)) }
    private func buttonMaxHeight(_ geometry: GeometryProxy) -> CGFloat { 0.09 * geometry.size.height }
    private let buttonSpacing: CGFloat = 20
}

struct FlipCard: View {
    @ObservedObject var consumedStorage: ConsumedStorageController
    
    @State private var isFaceUp = true
    
    var body: some View {
        ZStack {
            Energy(profile: consumedStorage.nutritionToday)
                .animation(nil)
                .opacity(isFaceUp ? 1 : 0)
            Fats(profile: consumedStorage.nutritionToday)
                .rotation3DEffect(Angle.degrees(180), axis: (1,0,0))
                .animation(nil)
                .opacity(isFaceUp ? 0 : 1)
        }
        .frame(maxHeight: maxHeight)
        .rotation3DEffect(Angle.degrees(isFaceUp ? 0 : 180), axis: (1,0,0))
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
        .animation(Animation.easeIn(duration: animationSpeed))
    }
    
    // MARK: - Drawing Constants
    private let maxHeight: CGFloat = 200
    private let animationSpeed: Double = 0.2
}

struct HomeCompactLayout_Previews: PreviewProvider {
    static var previews: some View {
        HomeCompactLayout(consumedStorage: PreviewData.consumedStorage, foodStorage: PreviewData.foodStorage,
                          mealStorage: PreviewData.mealStorage, userController: PreviewData.userController)
    }
}
