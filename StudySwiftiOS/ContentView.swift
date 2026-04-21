//
//  ContentView.swift
//  StudySwiftiOS
//

import SwiftUI

struct ContentView: View {
    @State private var store = StudyStore()
    @State private var celebrationPlant: GardenPlant?

    var body: some View {
        TabView {
            ScheduleView(store: store) { plant in
                withAnimation { celebrationPlant = plant }
            }
            .tabItem { Label("Schedule", systemImage: "calendar") }

            GardenView(store: store)
                .tabItem { Label("Garden", systemImage: "leaf.fill") }
        }
        .overlay {
            if let plant = celebrationPlant {
                GrowthAnimationView(plant: plant) {
                    withAnimation { celebrationPlant = nil }
                }
                .transition(.opacity)
            }
        }
    }
}

#Preview {
    ContentView()
}
