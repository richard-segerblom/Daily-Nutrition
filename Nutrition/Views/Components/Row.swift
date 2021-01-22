//
//  Row.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-11.
//

import SwiftUI

struct Row<Destination: View>: View {
    let name: String
    let calories: String
    let icon: Image
    let destination: Destination
    
    @State var isSelected = false
    
    init(name: String, calories: String, icon: Image, @ViewBuilder destination: @escaping () -> Destination) {
        self.name = name
        self.calories = calories
        self.icon = icon
        self.destination = destination()
    }
    
    var body: some View {
        Button(action: { isSelected = true }, label: {
            HStack {
                icon
                    .font(.title2)
                    .padding(.trailing, padding)
                
                VStack(alignment: HorizontalAlignment.leading) {
                    Text(name)
                    Text(calories)
                        .scaledFont(size: caloriesFontSize)
                }
                .foregroundColor(textColor)
                .padding(.vertical, padding)
                
                Spacer()
                
                Image(systemName: "chevron.forward")
                    .foregroundColor(color)
                    .font(.system(size: disclosureSize, weight: .medium, design: .rounded))
                    .padding(.trailing)
            }
            .border(width: dividerThickness, edges: [.bottom], color: color)
            .padding(.leading)
        }).buttonStyle(RowStyle())
        
        NavigationLink(destination: destination, isActive: $isSelected) { }
    }
    
    // MARK: - Drawing Constants
    private let padding: CGFloat = 8
    private let caloriesFontSize: CGFloat = 12
    private let dividerThickness: CGFloat = 0.5
    private let disclosureSize: CGFloat = 14
    private let color = Color("RowDetailColor")
    private let textColor = Color("PrimaryTextColor")
}

struct RowStyle: ButtonStyle {    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label            
            .foregroundColor(configuration.isPressed ? Color("SecondaryTextColor") : Color("PrimaryColor"))
            .background(configuration.isPressed ? Color("PrimaryColor") : Color.clear)
            .contentShape(Rectangle())
    }
}

struct Row_Previews: PreviewProvider {
    static var previews: some View {
        Row(name: "Apple", calories: "124 kcal", icon: Image(systemName: "paperplane")) { }
            .previewLayout(PreviewLayout.fixed(width: 300, height: 80))
            .padding()
    }
}
