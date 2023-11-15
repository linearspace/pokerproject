//
//  ContentView.swift
//  pokerproject
//
//  Created by Alexander on 15.11.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image("fractal")
                .resizable()
                .scaledToFill()
                .clipped()
        }
        .padding()
    }
}

//#Preview {
//    ContentView()
//}
