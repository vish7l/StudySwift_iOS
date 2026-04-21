//
//  TimeBlock.swift
//  StudySwiftiOS
//

import Foundation

struct TimeBlock: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var startTime: Date
    var duration: TimeInterval
    var isCompleted: Bool = false

    var endTime: Date {
        startTime.addingTimeInterval(duration)
    }
}
