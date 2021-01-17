//
//  Search.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-29.
//

import SwiftUI
import Combine


struct SearchView: View {    
    @ObservedObject var searchController: SearchController
    @State var isSearchPresented = true
        
    init(searchController: SearchController) {
        self.searchController = searchController
        UINavigationBar.setOpaqueBackground()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if isSearchPresented {
                   SearchForm(searchController: searchController, isSearchPresented: $isSearchPresented)
                } else {
                    SearchResultList(searchController: searchController, isSearchPresented: $isSearchPresented)
                }
            }
        }
    }
}

struct SearchForm: View {
    @ObservedObject var searchController: SearchController
    @Binding var isSearchPresented: Bool
    @State private var searchText: String = ""
    @State private  var isCancelHidden = true
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                TextField("Search Food", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                HStack(spacing: buttonSpacing) {
                    if !isCancelHidden {
                        DefaultButton(title: "Cancel", action: { self.isSearchPresented = false })
                    }
                    DefaultButton(title: "Search", action: {
                        self.isSearchPresented = false
                        self.isCancelHidden = false
                        searchController.searchFood(searchPhrase: searchText)
                        searchText = ""
                    })
                }.padding(.top, buttonPaddingTop)
                Spacer()
            }.padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text("Add Food"))
    }
    
    // MARK: - Drawing Constants
    private let buttonSpacing: CGFloat = 20
    private let buttonPaddingTop: CGFloat = 10
}

struct SearchResultList: View {
    @ObservedObject var searchController: SearchController
    @Binding var isSearchPresented: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(searchController.result) { foodController in
                    Row(name: foodController.name, calories: foodController.caloriesText, icon: Image.icon(foodController.category)) {
                        SearchDetail(profile: foodController)
                    }
                }
            }
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar() {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { isSearchPresented = true }) { Image(systemName: "magnifyingglass") }
            }
        }
    }
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchController: SearchController(required: PreviewData.userProfile,
                                                      persistenceController: PersistenceController.preview))
    }
}
