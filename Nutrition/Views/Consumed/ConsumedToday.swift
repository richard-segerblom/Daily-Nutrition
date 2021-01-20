//
//  ConsumedList.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-15.
//

import SwiftUI

struct ConsumedToday: View {
    @ObservedObject var consumedStorageController: ConsumedStorageController

    @State private var toDelete: ConsumedController?

    @Environment(\.presentationMode) var presentationMode
    
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
                                ConsumedDetail(consumedController: consumed, buttonTitle: "DELETE",
                                               action: { deleteTapped($0) })
                            }
                            .contextMenu(ContextMenu(menuItems: {
                                Button(action: { deleteTapped(consumed) },
                                       label: { Label("Delete", systemImage: "trash.fill") })
                            }))
                        }
                    }
                    Spacer()
                }
                .navigationTitle(Text("Consumed Today"))
                .navigationBarTitleDisplayMode(.inline)
                .onDisappear {
                    if let consumed = toDelete { consumed.delete() }
                }
            }
        }
    }
    
    func deleteTapped(_ consumed: ConsumedController) {
        toDelete = consumed
        presentationMode.wrappedValue.dismiss()
    }
}

struct ConsumedToday_Previews: PreviewProvider {
    static var previews: some View {
        ConsumedToday(consumedStorageController: PreviewData.consumedStorage)
    }
}
