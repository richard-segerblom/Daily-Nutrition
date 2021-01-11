//
//  ConsumedList.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-15.
//

import SwiftUI

struct ConsumedToday: View {
    @ObservedObject var consumedStorageController: ConsumedStorageController
    @State private var editMode = EditMode.inactive
    
    init(consumedStorageController: ConsumedStorageController) {
        self.consumedStorageController = consumedStorageController
        
        UINavigationBar.setOpaqueBackground()
    }
    
    var body: some View {
        if consumedStorageController.today.isEmpty {
            Text("No food consumed today")
                .font(.title2)
        } else {
            NavigationView {
                List {
                    ForEach(consumedStorageController.today) { consumed in
                        NavigationLink(destination: ConsumedDetail(consumedController: consumed)) {
                            ConsumedRow(consumedController: consumed)
                                .contextMenu(ContextMenu(menuItems: {
                                    eatButton
                                    deleteButton
                                }))
                        }
                    }
                }
                .navigationTitle(Text("Consumed Today"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar() { ToolbarItem(placement: .navigationBarTrailing) { EditButton() } }
                .environment(\.editMode, $editMode)
            }
        }
    }
    
    var eatButton: some View { Button(action: { /* TODO Implement eat */ }, label: { Label("Eat", systemImage: "folder") }) }
    
    var deleteButton: some View { Button(action: { /* TODO Implement delete */ }, label: { Label("Delete", systemImage: "folder") }) }
}

struct ConsumedToday_Previews: PreviewProvider {
    static var previews: some View {
        ConsumedToday(consumedStorageController: PreviewData.consumedStorage)
    }
}

