//
//  TimeBlockRow.swift
//  StudySwiftiOS
//

import SwiftUI

struct TimeBlockRow: View {
    let block: TimeBlock
    var onToggle: () -> Void

    private static let timeFormatter: DateFormatter = {
        let df = DateFormatter()
        df.timeStyle = .short
        df.dateStyle = .none
        return df
    }()

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: block.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(block.isCompleted ? Color.accentColor : Color.secondary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(block.isCompleted ? "Mark incomplete" : "Mark complete")

            VStack(alignment: .leading, spacing: 4) {
                Text(block.name)
                    .font(.body)
                    .strikethrough(block.isCompleted, color: .secondary)
                    .foregroundStyle(block.isCompleted ? .secondary : .primary)

                HStack(spacing: 6) {
                    Text(Self.timeFormatter.string(from: block.startTime))
                    Text("·")
                    Text(formatDuration(block.duration))
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }

    private func formatDuration(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds / 60)
        if minutes < 60 { return "\(minutes) min" }
        let hours = minutes / 60
        let rem = minutes % 60
        return rem == 0 ? "\(hours) hr" : "\(hours) hr \(rem) min"
    }
}
