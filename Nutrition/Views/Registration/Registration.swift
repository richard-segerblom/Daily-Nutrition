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
    @State private var rewind = false
    @State private var showContent = false
    
    @State private var selectedGender: Gender = .unknown
    @State private var selectedAge = 20
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                content(geometry)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            .background(backgroundColor)            
        }.ignoresSafeArea()
        .onAppear { showContent = true }
    }
    
    @ViewBuilder
    func content(_ geometry: GeometryProxy) -> some View {
        if showContent {
            if isGenderPresented {
                genderView(geometry)
            } else {
                ageView(geometry)
            }
        }
    }
    
    func genderView(_ geometry: GeometryProxy) -> some View {
        PopupView(geometry: geometry) {
            Text("Gender")
                .font(.title)
            DefaultButton(title: "WOMAN", action: {
                selectedGender = .woman
                self.isGenderPresented = false
            })
            DefaultButton(title: "MAN", action: {
                selectedGender = .man
                self.isGenderPresented = false
            })
        }
        .transition(.asymmetric(insertion: .offset(x: 0, y: 1000), removal: .opacity))
        .animation(rewind ? .none : Animation.linear(duration: 0.5).delay(0.5))
    }
            
    func ageView(_ geometry: GeometryProxy) -> some View {
        PopupView(geometry: geometry) {
            HStack {
                Button(action: {
                    rewind = true
                    isGenderPresented = true
                }) {
                    Image(systemName: "arrow.backward")
                }
                Spacer()
            }.foregroundColor(.accentColor)

            Text("Age")
                .font(.title)

            Picker(selection: $selectedAge, label: Text("Age")) {
                ForEach(0...120, id:\.self) {
                    Text("\($0)")
                }
            }

            DefaultButton(title: "DONE", action: {
                userControl.setupNewUser(gender: selectedGender, age: selectedAge)
            })
        }
        .transition(.opacity)
        .animation(Animation.linear(duration: 0.5))
    }
        
    // MARK: - Drawing Constants
    private let backgroundColor = Color.black.opacity(0.3)
}

struct PopupView<Content: View>: View {
    let geometry: GeometryProxy
    let content: Content
    
    init(geometry: GeometryProxy, @ViewBuilder content: () -> Content) {
        self.geometry = geometry
        self.content = content()
    }
    
    var body: some View {
        Group {
            RoundedRectangle(cornerRadius: cornerRadius)
                .frame(maxWidth: rectangleWidth(geometry), maxHeight: rectangleHeight)
                .foregroundColor(formBackgroundColor)
                .shadow(radius: shadowRadius)
                                                
            VStack(spacing: spacing) {
                content
            }
            .frame(maxWidth: contentWidth(geometry))
            .padding(.horizontal)
        }
    }
    
    // MARK: - Drawing Constants
    private func rectangleWidth(_ geometry: GeometryProxy) -> CGFloat { min(geometry.size.width - 40, 500) }
    private func contentWidth(_ geometry: GeometryProxy) -> CGFloat { min(geometry.size.width - 80, 400) }
    private let shadowRadius: CGFloat = 10
    private let formBackgroundColor = Color.white
    private let spacing: CGFloat = 10
    private let rectangleHeight: CGFloat = 400
    private let cornerRadius: CGFloat = 5
}

struct GenderView_Previews: PreviewProvider {
    static var previews: some View {
        Registration(userControl: PreviewData.userController)
    }
}
