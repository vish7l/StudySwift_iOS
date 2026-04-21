//
//  StudyStore.swift
//  StudySwiftiOS
//

import Foundation
import Observation

@Observable
final class StudyStore {
    private static let storageKey = "studyBlocks.v1"

    var blocks: [TimeBlock] = [] {
        didSet { save() }
    }

    init() {
        load()
    }

    // MARK: - Mutations

    func add(_ block: TimeBlock) {
        blocks.append(block)
        blocks.sort { $0.startTime < $1.startTime }
    }

    func delete(at offsets: IndexSet, from dayBlocks: [TimeBlock]) {
        let idsToRemove = offsets.map { dayBlocks[$0].id }
        blocks.removeAll { idsToRemove.contains($0.id) }
    }

    func toggleCompleted(_ block: TimeBlock) {
        guard let idx = blocks.firstIndex(where: { $0.id == block.id }) else { return }
        blocks[idx].isCompleted.toggle()
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

    private func save() {
        do {
            let data = try JSONEncoder().encode(blocks)
            UserDefaults.standard.set(data, forKey: Self.storageKey)
        } catch {
            print("StudyStore save failed: \(error)")
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: Self.storageKey) else { return }
        do {
            blocks = try JSONDecoder().decode([TimeBlock].self, from: data)
        } catch {
            print("StudyStore load failed: \(error)")
        }
    }
}
