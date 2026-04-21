//
//  GrowthAnimationView.swift
//  StudySwiftiOS
//

import SwiftUI

struct GrowthAnimationView: View {
    let plant: GardenPlant
    let onDismiss: () -> Void

    @State private var stage = 0       // 0=seed  1=sprout  2=sapling  3=full
    @State private var showLabel = false

    private var leafScale: CGFloat {
        switch stage {
        case 0: return 0.0
        case 1: return 0.35
        case 2: return 0.65
        default: return 1.0
        }
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.55)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }

            VStack(spacing: 28) {
                Text("Block Complete!")
                    .font(.headline)

                ZStack {
                    Circle()
                        .fill(plant.rarity.color.opacity(0.12))
                        .frame(width: 160, height: 160)

                    // Seed — fades out once the plant appears
                    Circle()
                        .fill(.brown.opacity(0.65))
                        .frame(width: 18, height: 18)
                        .opacity(stage == 0 ? 1 : 0)
                        .animation(.easeOut(duration: 0.25), value: stage)

                    // Growing plant
                    ZStack {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(plant.rarity.color)

                        // Sparkle badge for the top-tier rarity
                        if plant.rarity == .ancient {
                            Image(systemName: "sparkles")
                                .font(.system(size: 20))
                                .foregroundStyle(.yellow)
                                .offset(x: 26, y: -26)
                                .opacity(stage == 3 ? 1 : 0)
                                .animation(.easeIn(duration: 0.3), value: stage)
                        }
                    }
                    .scaleEffect(leafScale)
                    .opacity(stage == 0 ? 0 : 1)
                    .animation(.spring(response: 0.45, dampingFraction: 0.52), value: stage)
                }

                if showLabel {
                    VStack(spacing: 6) {
                        HStack(spacing: 6) {
                            Text(plant.rarity.displayName)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(plant.rarity.color)
                            Text("Grown!")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        Text(plant.blockName)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.88)))
                }

                Text("Tap anywhere to dismiss")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(32)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
            .padding(.horizontal, 32)
        }
        .onAppear {
            Task {
                try? await Task.sleep(for: .seconds(0.3))
                withAnimation { stage = 1 }
                try? await Task.sleep(for: .seconds(0.5))
                withAnimation { stage = 2 }
                try? await Task.sleep(for: .seconds(0.5))
                withAnimation { stage = 3 }
                try? await Task.sleep(for: .seconds(0.35))
                withAnimation(.spring()) { showLabel = true }
                // Auto-dismiss after the user has had time to enjoy their plant
                try? await Task.sleep(for: .seconds(2.5))
                onDismiss()
            }
        }
    }
}
