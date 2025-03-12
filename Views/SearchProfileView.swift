//
//  SearchProfileView.swift
//  dotaTracker
//
//  Created by cerdelen on 10.03.25.
//

import Foundation
import SwiftUI

struct SteamIDInputView: View {
    @State private var searchString: String = ""
    @State private var isNavigationActive = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // TextField for SteamID input
                TextField("Enter SteamID", text: $searchString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    isNavigationActive = true
                }) {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(searchString.isEmpty) // Disable button if SteamID is empty
                
                let steamID = SteamID.bit32(39401116)
                // NavigationLink to the existing view
                NavigationLink(
                    destination: ProfileView(steamID: steamID), // Pass SteamID to ContentView
                    isActive: $isNavigationActive
                ) {
                    EmptyView() // Hidden navigation link
                }
            }
            .padding()
            .navigationTitle("Enter SteamID")
        }
    }
}
