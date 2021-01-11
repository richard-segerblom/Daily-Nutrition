//
//  ConsumedRow.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-04.
//

import SwiftUI

struct ConsumedRow: View {
    let consumedController: ConsumedController
    
    var body: some View {
        Row(name: consumedController.name,
            calories: consumedController.caloriesText,
            icon: Image(systemName: "paperplane"))
    }
}

struct ConsumedRow_Previews: PreviewProvider {
    static var previews: some View {        
        ConsumedRow(consumedController: PreviewData.consumedController)
            .previewLayout(PreviewLayout.fixed(width: 300, height: 80))
            .padding()
    }
}
