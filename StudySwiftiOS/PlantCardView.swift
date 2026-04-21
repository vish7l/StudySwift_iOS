//
//  PlantCardView.swift
//  StudySwiftiOS
//

import SwiftUI

struct PlantCardView: View {
    let plant: GardenPlant

    private static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .none
        return df
    }()

    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .topTrailing) {
                Circle()
                    .fill(plant.rarity.color.opacity(0.15))
                    .frame(width: 56, height: 56)

                Image(systemName: "leaf.fill")
                    .font(.system(size: plant.rarity.cardIconSize))
                    .foregroundStyle(plant.rarity.color)

                if plant.rarity == .ancient {
                    Image(systemName: "sparkles")
                        .font(.system(size: 10))
                        .foregroundStyle(.yellow)
                        .offset(x: 4, y: -4)
                }
            }

            Text(plant.rarity.displayName)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(plant.rarity.color)

            Text(plant.blockName)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)

            Text(Self.dateFormatter.string(from: plant.earnedAt))
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}
