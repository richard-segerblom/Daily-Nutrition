//
//  HomeRegularLayout.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-02.
//

import SwiftUI

struct HomeRegularLayout: View {
    @ObservedObject var consumedStorage: ConsumedStorageController
    @ObservedObject var foodStorage: FoodStorageController
    @ObservedObject var mealStorage: MealStorageController
    
    @State private var isFoodPresented = false
    @State private var isMealPresented = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(spacing: chartSpacing(geometry)) {
                    Group {
                        VitaminChart(nutrients: consumedStorage.nutritionToday[.vitamins], title: "VITAMINS",
                                 spacing: barSpacing(geometry), barWidth: barWidth(geometry), height: chartHeight(geometry))

                        MineralChart(nutrients: consumedStorage.nutritionToday[.minerals], title: "MINERALS", labelLength: 2,
                                 spacing: barSpacing(geometry), barWidth: barWidth(geometry), height: chartHeight(geometry))
                    }.padding(.top)
                }                

                HStack(spacing: energySpacing) {
                    TitleView(title: "ENERGY") { Energy(profile: consumedStorage.nutritionToday) }
                    TitleView(title: "FATS") { Fats(profile: consumedStorage.nutritionToday) }
                }.padding(.horizontal)

                Group {
                    HorizontalPager(items: consumedStorage.today, title: "CONSUMED TODAY", emptyText: "No food exists",
                                    actionType: .delete) { $0.delete() }
                    HorizontalPager(items: consumedStorage.latest, title: "RECENT", emptyText: "No recent items exists.",
                                    actionType: .eat) { $0.eat() }                        
                }.padding(.top)

                VStack(spacing: 0) {
                    HStack(spacing: buttonSpacing) {
                        DefaultButton(title: "MEALS", action: { isMealPresented = true })
                            .sheet(isPresented: $isMealPresented) { MealPicker(mealStorage: mealStorage, foodStorage: foodStorage) }
                        DefaultButton(title: "FOOD", action: { isFoodPresented = true })
                            .sheet(isPresented: $isFoodPresented) { FoodPicker(foodStorage: foodStorage) }
                    }
                    .frame(maxHeight: buttonMaxHeight(geometry))
                }.padding()
            }
        }
    }
    
    // MARK: - Drawing Constants
    private func chartSpacing(_ geometry: GeometryProxy) -> CGFloat { 0.08 * geometry.size.width }
    private func barSpacing(_ geometry: GeometryProxy) -> CGFloat { 0.01 * geometry.size.width }
    private func barWidth(_ geometry: GeometryProxy) -> CGFloat { 0.018 * geometry.size.width }
    private func chartHeight(_ geometry: GeometryProxy) -> CGFloat { abs((geometry.size.height / 6.5)) }
    private func buttonMaxHeight(_ geometry: GeometryProxy) -> CGFloat { 0.06 * geometry.size.height }
    private let buttonSpacing: CGFloat = 20
    private let energySpacing: CGFloat = 40
}

struct TitleView<Content: View>: View {
    var title: String
    var content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .padding(.top)
                .padding(.bottom, bottomPadding)
            content
        }
    }
    
    // MARK: - Drawing Constants
    private let bottomPadding: CGFloat = 5
}

struct HomeRegularLayout_Previews: PreviewProvider {
    static var previews: some View {
        HomeRegularLayout(consumedStorage: PreviewData.consumedStorage, foodStorage: PreviewData.foodStorage,
                          mealStorage: PreviewData.mealStorage)
    }
}
