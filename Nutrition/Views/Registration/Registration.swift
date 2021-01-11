//
//  GenderView.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-05.
//

import SwiftUI

struct Registration: View {
    @ObservedObject var userControl: UserController
    
    @State private var isGenderPresented = true
    @State private var selectedGender: Gender = .unknown
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .frame(maxWidth: rectangleWidth(geometry), maxHeight: rectangleHeight)
                    .foregroundColor(formBackgroundColor)
                    .shadow(radius: shadowRadius)
                        
                    content()
                        .frame(maxWidth: contentWidth(geometry))
                        .padding(.horizontal)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            .background(backgroundColor)
        }.ignoresSafeArea()
    }
    
    @ViewBuilder
    func content() -> some View {
        if isGenderPresented {
            GenderView(selectedGender: $selectedGender, isPresented: $isGenderPresented)
        } else {
            AgeView(userControl: userControl, gender: selectedGender)
        }
    }
    
    // MARK: - Drawing Constants
    private func rectangleWidth(_ geometry: GeometryProxy) -> CGFloat { min(geometry.size.width - 40, 500) }
    private func contentWidth(_ geometry: GeometryProxy) -> CGFloat { min(geometry.size.width - 80, 400) }
    private let rectangleHeight: CGFloat = 400
    private let cornerRadius: CGFloat = 5
    private let shadowRadius: CGFloat = 10
    private let formBackgroundColor = Color.white
    private let backgroundColor = Color.black.opacity(0.3)
}

struct GenderView: View {
    @Binding var selectedGender: Gender
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: spacing) {
            Text("Gender")
                .font(.title)
            DefaultButton(title: "WOMAN", action: {
                selectedGender = .woman
                self.isPresented = false
            })
            DefaultButton(title: "MAN", action: {
                selectedGender = .man
                self.isPresented = false
            })
        }
    }
    
    // MARK: - Drawing Constants
    private let spacing: CGFloat = 10
}

struct AgeView: View {
    @ObservedObject var userControl: UserController
    @State private var selectedAge = 20
    let gender: Gender
    
    var body: some View {
        VStack(spacing: spacing) {
                Text("Age")
                    .font(.title)
            Picker(selection: $selectedAge, label: Text("Age")) {
                ForEach(0...120, id:\.self) {
                    Text("\($0)")
                }
            }
            
            DefaultButton(title: "DONE", action: {
                userControl.setupNewUser(gender: gender, age: selectedAge)
            })
        }
    }
    
    // MARK: - Drawing Constants
    private let spacing: CGFloat = 10
}

struct GenderView_Previews: PreviewProvider {
    static var previews: some View {
        Registration(userControl: PreviewData.userController)
    }
}
