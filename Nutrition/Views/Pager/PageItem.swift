//
//  PageItem.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-24.
//

import SwiftUI

struct PageItem: View {
    let food: ConsumedController
    let actionType: HorizontalPager.ActionType
    let action: (ConsumedController) -> Void
    
    @State var isDetailPresented = false
    
    var body: some View {
        GeometryReader { geometry in
            Button(action: {
                isDetailPresented = true
            } , label: {
                HStack {
                    Image.icon(food)
                        .font(.system(size: iconSize))
                        .padding(iconPadding)
                    
                    VStack(alignment: HorizontalAlignment.leading) {
                        Text(food.name)
                        Text(food[.calories].intValueDetailText)
                            .font(.system(size: subTitleFontSize(geometry)))
                    }
                    
                    Spacer()
                }
                .font(.system(size: titleFontSize(geometry)))
                .position(x: x(geometry), y: y(geometry))
                .border(borderColor)                
            }).buttonStyle(RowStyle())
        }.sheet(isPresented: $isDetailPresented) {
            if actionType == .eat {
                ConsumedDetail(consumedController: food, buttonTitle: actionType.rawValue, action: action)
            } else {
                ScrollView {
                    Detail(profile: food)
                        .padding()
                }
            }
        }
        .contextMenu(ContextMenu(menuItems: {
            Button(action: { self.action(food) }, label: { menuLabel })
        }))
    }
    
    private var menuLabel: some View {
        switch actionType {
        case .delete: return Label(actionType.rawValue, systemImage: "trash.fill")
        default: return Label(actionType.rawValue, systemImage: "heart.fill")
        }
    }
    
    // MARK: - Drawing Constants
    private let borderColor = Color("PrimaryColor")
    private let iconPadding: CGFloat = 10
    private let iconSize: CGFloat = 24
    private func titleFontSize(_ geometry: GeometryProxy) -> CGFloat { 0.07 * geometry.size.width }
    private func subTitleFontSize(_ geometry: GeometryProxy) -> CGFloat { 0.04 * geometry.size.width }
    private func x(_ geometry: GeometryProxy) -> CGFloat { geometry.size.width / 2 }
    private func y(_ geometry: GeometryProxy) -> CGFloat { geometry.size.height / 2 }
}

struct PageItem_Previews: PreviewProvider {
    static var previews: some View {
        PageItem(food: PreviewData.consumedController, actionType: .delete) { _ in }
            .previewLayout(PreviewLayout.fixed(width: 300, height: 80))
    }
}
