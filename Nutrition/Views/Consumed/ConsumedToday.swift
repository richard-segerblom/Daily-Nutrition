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
                ScrollView {
                    VStack {
                        ForEach(consumedStorageController.today) { consumed in
                            Row(name: consumed.name, calories: consumed.caloriesText, icon: Image.icon(consumed)) {
                                ConsumedDetail(consumedController: consumed, buttonTitle: "DELETE", action: { _ in /* TODO Implement delete */ })
                            }.contextMenu(ContextMenu(menuItems: {                                
                                Button(action: { /* TODO Implement delete */ }, label: { Label("Delete", systemImage: "trash.fill") })
                            }))
                        }.onDelete { _ in /* TODO Implement delete */  }
                    }
                    Spacer()
                }
                .navigationTitle(Text("Consumed Today"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar() { ToolbarItem(placement: .navigationBarTrailing) { EditButton() } }
                .environment(\.editMode, $editMode)
            }
        }
    }
}

struct ConsumedToday_Previews: PreviewProvider {
    static var previews: some View {
        ConsumedToday(consumedStorageController: PreviewData.consumedStorage)
    }
}

