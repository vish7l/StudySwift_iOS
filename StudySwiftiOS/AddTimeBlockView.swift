//
//  AddTimeBlockView.swift
//  StudySwiftiOS
//

import SwiftUI

struct AddTimeBlockView: View {
    @Environment(\.dismiss) private var dismiss
    var onSave: (TimeBlock) -> Void

    @State private var name: String = ""
    @State private var startTime: Date = Self.defaultStartTime()
    @State private var durationMinutes: Int = 30

    private static let durationOptions: [Int] = [15, 25, 30, 45, 60, 75, 90, 120]

    var body: some View {
        NavigationStack {
            Form {
                Section("Subject or Task") {
                    TextField("e.g. Calculus problem set", text: $name)
                        .autocorrectionDisabled()
                }

                Section("Start Time") {
                    DatePicker("Start", selection: $startTime, displayedComponents: [.date, .hourAndMinute])
                }

                Section("Duration") {
                    Picker("Duration", selection: $durationMinutes) {
                        ForEach(Self.durationOptions, id: \.self) { mins in
                            Text(formatDuration(minutes: mins)).tag(mins)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxHeight: 130)
                }
            }
            .navigationTitle("New Time Block")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let block = TimeBlock(
                            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                            startTime: startTime,
                            duration: TimeInterval(durationMinutes * 60)
                        )
                        onSave(block)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func formatDuration(minutes: Int) -> String {
        if minutes < 60 { return "\(minutes) min" }
        let hours = minutes / 60
        let rem = minutes % 60
        return rem == 0 ? "\(hours) hr" : "\(hours) hr \(rem) min"
    }

    private static func defaultStartTime() -> Date {
        let now = Date()
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: now)
        let rounded = ((minute + 14) / 15) * 15
        var comps = calendar.dateComponents([.year, .month, .day, .hour], from: now)
        comps.minute = rounded == 60 ? 0 : rounded
        if rounded == 60, let hour = comps.hour { comps.hour = hour + 1 }
        return calendar.date(from: comps) ?? now
    }
}

#Preview {
    AddTimeBlockView { _ in }
}
