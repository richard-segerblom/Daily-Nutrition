//
//  ConsumedDetail.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-22.
//

import SwiftUI

struct ConsumedDetail: View {
    let consumedController: ConsumedController
    let buttonTitle: String
    let action: (ConsumedController) -> Void
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Detail(profile: consumedController.nutritionProfile)
                DefaultButton(title: buttonTitle, action: { /* TODO Implement delete consumed */ })
                    .padding([.top, .bottom])
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Text(consumedController.name))
        }.padding(.horizontal)
    }
}

struct ConsumedDetail_Previews: PreviewProvider {
    static var previews: some View {
        ConsumedDetail(consumedController: PreviewData.consumedController, buttonTitle: "DELETE") { _ in }
    }
}
