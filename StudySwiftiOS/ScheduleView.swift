//
//  ScheduleView.swift
//  StudySwiftiOS
//

import SwiftUI

struct ScheduleView: View {
    let store: StudyStore
    var onPlantEarned: (GardenPlant) -> Void

    @State private var showingAdd = false

    private var todayBlocks: [TimeBlock] {
        store.blocks(on: Date())
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                StatsHeader(
                    focusedSeconds: store.focusedSeconds(on: Date()),
                    streak: store.currentStreak()
                )

                if todayBlocks.isEmpty {
                    emptyState
                } else {
                    List {
                        ForEach(todayBlocks) { block in
                            TimeBlockRow(block: block) {
                                if let plant = store.toggleCompleted(block) {
                                    onPlantEarned(plant)
                                }
                            }
                        }
                        .onDelete { offsets in
                            store.delete(at: offsets, from: todayBlocks)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Today")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add time block")
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddTimeBlockView { block in
                    store.add(block)
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No blocks scheduled for today")
                .font(.headline)
            Text("Tap + to plan your first study block.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

private struct StatsHeader: View {
    let focusedSeconds: TimeInterval
    let streak: Int

    var body: some View {
        HStack(spacing: 12) {
            StatCard(
                icon: "clock.fill",
                tint: .blue,
                value: focusedString,
                label: "Focused today"
            )
            StatCard(
                icon: "flame.fill",
                tint: .orange,
                value: "\(streak)",
                label: streak == 1 ? "day streak" : "day streak"
            )
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }

    private var focusedString: String {
        let totalMinutes = Int(focusedSeconds / 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        if hours == 0 { return "\(minutes)m" }
        return minutes == 0 ? "\(hours)h" : "\(hours)h \(minutes)m"
    }
}

private struct StatCard: View {
    let icon: String
    let tint: Color
    let value: String
    let label: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundStyle(tint)
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
                .monospacedDigit()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}
