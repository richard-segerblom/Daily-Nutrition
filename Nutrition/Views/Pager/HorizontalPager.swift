//
//  HorizontalPager.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-25.
//

import SwiftUI

struct HorizontalPager: View {
    let items: [FoodController]
    let title: String
    let emptyText: String
    let columns: Int
    let rows: Int
    
    @State private var pageIndex: Int = 0
    
    init(items: [FoodController], title: String = "", emptyText: String = "", columns: Int = 3, rows: Int = 3) {
        self.items = items
        self.title = title
        self.emptyText = emptyText
        self.columns = columns
        self.rows = rows
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
            GeometryReader { geometry in
                if items.isEmpty {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color.clear)
                            .border(borderColor)
                        Text(emptyText)
                            .foregroundColor(textColor)                        
                    }.padding(.horizontal)
                } else {
                    TabView(selection: $pageIndex.animation()) {
                        ForEach((0..<pages), id: \.self) {
                            Page(items: pageItems(for: $0))
                                .tag($0)
                                .padding(padding)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(height: geometry.size.height)
                    .padding(.bottom)
                }
            }
            
            PageIndex(numberOfPages: pages, currentIndex: pageIndex)
                .padding(.vertical, pageIndexPadding)
        }
        .onAppear(perform: { UIScrollView.appearance().alwaysBounceVertical = false })
        .onDisappear() { UIScrollView.appearance().alwaysBounceVertical = true }
    }
    
    // MARK: - Calculations
    var itemsPerPage: Int { columns * rows }
    
    var pages: Int { Int(CGFloat(CGFloat(items.count) / CGFloat(itemsPerPage)).rounded(.up)) }
    
    func pageItems(for index: Int) -> [FoodController] {
        let start = index * itemsPerPage
        var end = start + itemsPerPage
        if end > items.count { end = items.count }
        
        return Array(items[start..<end])
    }
    
    // MARK: - Drawing Constants
    private let borderColor = Color.accentColor
    private let textColor = Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    private let padding: CGFloat = 6
    private let pageIndexPadding: CGFloat = 5
}

struct HorizontalPager_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalPager(items:Array(repeating: PreviewData.foodController, count: 18), title: "RECENT")
            .previewLayout(PreviewLayout.fixed(width: 400, height: 200))
            .padding()
    }
}
