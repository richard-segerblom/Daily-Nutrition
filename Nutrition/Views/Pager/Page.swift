//
//  Page.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-24.
//

import SwiftUI

struct Page: View {
    let items: [ConsumedController]
    let rows = 3
    let columns = 3
    let actionType: HorizontalPager.ActionType
    let action: (ConsumedController) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top, spacing: 0) {
                if !items.isEmpty {
                    ForEach(0...columnCount(), id: \.self) { column in
                        VStack(spacing: 0) {
                            ForEach(0..<rowsInColumn(column), id: \.self) { row in
                                let itemIndex = index(for: column, row: row)
                                let item = items[itemIndex]
                                PageItem(food: item, actionType: actionType, action: action)
                                    .padding([.bottom, .trailing], padding)
                                    .id(row)
                                    .frame(width: width(geometry), height: height(geometry))
                            }
                        }
                    }
                }
            }
        }
    }
        
    // MARK: - Calculations
    func columnCount() -> Int { Int(CGFloat(items.count / rows).rounded(.up)) }
    
    func rowsInColumn(_ column: Int) -> Int { min(items.count - (column * rows), rows) }
    
    func index(for column: Int, row: Int) -> Int {
        var i = (column * columns) + row
        if i >= items.count { i = items.count - 1 }
        
        return i
    }
    
    // MARK: - Drawing Constants
    private let padding: CGFloat = 1
    private func width(_ geometry: GeometryProxy) -> CGFloat { max((geometry.size.width / CGFloat(columns)), 0) }
    private func height(_ geometry: GeometryProxy) -> CGFloat { max((geometry.size.height / CGFloat(rows)), 0) }
}

struct Page_Previews: PreviewProvider {
    static var previews: some View {
        Page(items: Array(repeating: PreviewData.consumedController, count: 15), actionType: .delete) { _ in }
            .previewLayout(PreviewLayout.fixed(width: 400, height: 200))
    }
}
