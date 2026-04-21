//
//  StudyStore.swift
//  StudySwiftiOS
//

import Foundation
import Observation

@Observable
final class StudyStore {
    private static let blocksKey = "studyBlocks.v1"
    private static let plantsKey = "gardenPlants.v1"

    var blocks: [TimeBlock] = [] {
        didSet { saveBlocks() }
    }

    var plants: [GardenPlant] = [] {
        didSet { savePlants() }
    }

    init() {
        loadBlocks()
        loadPlants()
    }

    // MARK: - Block mutations

    func add(_ block: TimeBlock) {
        blocks.append(block)
        blocks.sort { $0.startTime < $1.startTime }
    }

    func delete(at offsets: IndexSet, from dayBlocks: [TimeBlock]) {
        let idsToRemove = offsets.map { dayBlocks[$0].id }
        blocks.removeAll { idsToRemove.contains($0.id) }
    }

    /// Toggles completion state. Returns a new GardenPlant when the block
    /// transitions from incomplete → complete; returns nil otherwise.
    @discardableResult
    func toggleCompleted(_ block: TimeBlock) -> GardenPlant? {
        guard let idx = blocks.firstIndex(where: { $0.id == block.id }) else { return nil }
        let wasCompleted = blocks[idx].isCompleted
        blocks[idx].isCompleted.toggle()
        guard !wasCompleted else { return nil }
        let plant = GardenPlant(from: blocks[idx])
        plants.append(plant)
        return plant
    }

    // MARK: - Queries

    func blocks(on date: Date, calendar: Calendar = .current) -> [TimeBlock] {
        blocks
            .filter { calendar.isDate($0.startTime, inSameDayAs: date) }
            .sorted { $0.startTime < $1.startTime }
    }

    /// Sum of durations for completed blocks on the given day.
    func focusedSeconds(on date: Date, calendar: Calendar = .current) -> TimeInterval {
        blocks(on: date, calendar: calendar)
            .filter(\.isCompleted)
            .reduce(0) { $0 + $1.duration }
    }

    /// Consecutive days (ending today, or yesterday if today has no completions yet)
    /// on which at least one block was completed.
    func currentStreak(today: Date = Date(), calendar: Calendar = .current) -> Int {
        let completedDays: Set<Date> = Set(
            blocks
                .filter(\.isCompleted)
                .map { calendar.startOfDay(for: $0.startTime) }
        )

        guard !completedDays.isEmpty else { return 0 }

        let startOfToday = calendar.startOfDay(for: today)
        var cursor: Date
        if completedDays.contains(startOfToday) {
            cursor = startOfToday
        } else if let yesterday = calendar.date(byAdding: .day, value: -1, to: startOfToday),
                  completedDays.contains(yesterday) {
            cursor = yesterday
        } else {
            return 0
        }

        var streak = 0
        while completedDays.contains(cursor) {
            streak += 1
            guard let prev = calendar.date(byAdding: .day, value: -1, to: cursor) else { break }
            cursor = prev
        }
        return streak
    }

    // MARK: - Persistence

    private func saveBlocks() {
        if let data = try? JSONEncoder().encode(blocks) {
            UserDefaults.standard.set(data, forKey: Self.blocksKey)
        }
    }

    private func loadBlocks() {
        guard let data = UserDefaults.standard.data(forKey: Self.blocksKey),
              let decoded = try? JSONDecoder().decode([TimeBlock].self, from: data)
        else { return }
        blocks = decoded
    }

    private func savePlants() {
        if let data = try? JSONEncoder().encode(plants) {
            UserDefaults.standard.set(data, forKey: Self.plantsKey)
        }
    }

    private func loadPlants() {
        guard let data = UserDefaults.standard.data(forKey: Self.plantsKey),
              let decoded = try? JSONDecoder().decode([GardenPlant].self, from: data)
        else { return }
        plants = decoded
    }
}
