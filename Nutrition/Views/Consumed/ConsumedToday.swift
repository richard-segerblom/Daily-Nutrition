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
        NavigationView {
            content
            .navigationTitle(Text("Consumed Today"))
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                if let consumed = toDelete { consumed.delete() }
            }
        }
    }
        

    @ViewBuilder
    var content: some View {
        if consumedStorageController.today.isEmpty {
            Text("No food consumed today")
                .font(.system(size: fontSize))
                .foregroundColor(textColor)
        } else {
            List(consumedStorageController.today) { consumed in
            NavigationLink(
                destination: ConsumedDetail(consumedController: consumed, buttonTitle: "DELETE", action: { deleteTapped($0) }),
                label: { Row(name: consumed.name, calories: consumed.caloriesText, icon: Image.icon(consumed))
                    .contextMenu(ContextMenu {
                        Button(action: { deleteTapped(consumed) }, label: { Label("Delete", systemImage: "trash.fill") })
                    })                    
                })
            }
        }
    }
    
    func deleteTapped(_ consumed: ConsumedController) {
        toDelete = consumed
        presentationMode.wrappedValue.dismiss()
    }
    
    // MARK: - Drawing Constants
    private let fontSize: CGFloat = 18
    private let textColor = Color("PrimaryTextColor")
}

struct ConsumedToday_Previews: PreviewProvider {
    static var previews: some View {
        ConsumedToday(consumedStorageController: PreviewData.consumedStorage)
    }
}
