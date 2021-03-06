//
//  HorizontalPager.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-25.
//

import SwiftUI

struct HorizontalPager: View {
    let items: [ConsumedController]
    let title: String
    let emptyText: String
    let columns: Int
    let rows: Int
    let actionType: ActionType
    let action: (ConsumedController) -> Void
    
    @State private var pageIndex: Int = 0
    
    init(items: [ConsumedController], title: String, emptyText: String, actionType: ActionType,
         columns: Int = 3, rows: Int = 3, action: @escaping (ConsumedController) -> Void) {
        self.items = items
        self.title = title
        self.emptyText = emptyText
        self.actionType = actionType
        self.columns = columns
        self.rows = rows
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.system(size: fontSize))
            GeometryReader { geometry in
                ZStack {
                    Rectangle()
                        .foregroundColor(Color.clear)
                        .border(borderColor)
                    if items.isEmpty {
                        Text(emptyText)
                            .font(.system(size: fontSize))
                            .foregroundColor(textColor)
                    } else {
                        TabView(selection: $pageIndex.animation()) {
                            ForEach((0..<pages), id: \.self) {
                                Page(items: pageItems(for: $0), actionType: actionType, action: action)
                                    .tag($0)
                                    .padding(padding)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .frame(height: geometry.size.height)
                    }
                }.padding(.horizontal)
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
    
    func pageItems(for index: Int) -> [ConsumedController] {
        let start = index * itemsPerPage
        var end = start + itemsPerPage
        if end > items.count { end = items.count }
        
        return Array(items[start..<end])
    }
    
    enum ActionType: String {
        case delete = "DELETE"
        case eat = "EAT"
    }
    
    // MARK: - Drawing Constants
    private let borderColor = Color("PrimaryColor")
    private let textColor = Color("PrimaryTextColor")
    private let padding: CGFloat = 6
    private let pageIndexPadding: CGFloat = 5
    private let fontSize: CGFloat = 14
}

struct HorizontalPager_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalPager(items:Array(repeating: PreviewData.consumedController, count: 18), title: "RECENT",
                        emptyText: "Some text", actionType: .delete) { _ in }
            .previewLayout(PreviewLayout.fixed(width: 400, height: 200))
            .padding()
    }
}
