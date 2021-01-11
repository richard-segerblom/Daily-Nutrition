//
//  ConsumedDetail.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-22.
//

import SwiftUI

struct ConsumedDetail: View {
    let consumedController: ConsumedController
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Detail(profile: consumedController.nutritionProfile)
                DefaultButton(title: "DELETE", action: { /* TODO Implement delete consumed */ })
                .padding(.top, padding)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Text(consumedController.name))
        }.padding([.horizontal, .bottom])
    }
    
    // MARK: - Drawing Constants
    private let padding: CGFloat = 40
}

struct ConsumedDetail_Previews: PreviewProvider {
    static var previews: some View {
        ConsumedDetail(consumedController: PreviewData.consumedController)
    }
}
