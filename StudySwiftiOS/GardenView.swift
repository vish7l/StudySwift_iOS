//
//  GardenView.swift
//  StudySwiftiOS
//

import SwiftUI

struct GardenView: View {
    let store: StudyStore

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            Group {
                if store.plants.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(store.plants.reversed()) { plant in
                                PlantCardView(plant: plant)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Garden")
            .toolbar {
                if !store.plants.isEmpty {
                    ToolbarItem(placement: .status) {
                        Text("\(store.plants.count) plant\(store.plants.count == 1 ? "" : "s")")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "leaf")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("Your garden is empty")
                .font(.headline)
            Text("Complete a time block to grow your first plant.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
