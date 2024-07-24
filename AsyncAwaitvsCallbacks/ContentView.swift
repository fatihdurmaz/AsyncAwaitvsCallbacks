//
//  ContentView.swift
//  AsyncAwaitvsCallbacks
//
//  Created by Fatih Durmaz on 23.07.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                ProductListView()
            }
            .navigationTitle("Products")
        }
    }
}

#Preview {
    ContentView()
}
