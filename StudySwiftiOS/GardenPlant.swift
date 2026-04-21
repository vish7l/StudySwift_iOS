//
//  GardenPlant.swift
//  StudySwiftiOS
//

import SwiftUI

enum PlantRarity: String, Codable {
    case sprout   // < 25 min
    case herb     // 25–44 min
    case sapling  // 45–74 min
    case ancient  // 75+ min

    init(duration: TimeInterval) {
        let minutes = duration / 60
        if minutes < 25 { self = .sprout }
        else if minutes < 45 { self = .herb }
        else if minutes < 75 { self = .sapling }
        else { self = .ancient }
    }

    var displayName: String {
        switch self {
        case .sprout:  "Sprout"
        case .herb:    "Herb"
        case .sapling: "Sapling"
        case .ancient: "Ancient Oak"
        }
    }

    var color: Color {
        switch self {
        case .sprout:  .green
        case .herb:    .teal
        case .sapling: .blue
        case .ancient: .purple
        }
    }

    // Icon size in the garden grid card
    var cardIconSize: CGFloat {
        switch self {
        case .sprout:  22
        case .herb:    26
        case .sapling: 30
        case .ancient: 34
        }
    }
}

struct GardenPlant: Identifiable, Codable {
    var id: UUID = UUID()
    var blockName: String
    var duration: TimeInterval
    var earnedAt: Date
    var rarity: PlantRarity

    init(from block: TimeBlock) {
        blockName = block.name
        duration = block.duration
        earnedAt = Date()
        rarity = PlantRarity(duration: block.duration)
    }
}
