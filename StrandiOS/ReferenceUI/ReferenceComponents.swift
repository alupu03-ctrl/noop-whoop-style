#if os(iOS)
import SwiftUI

/// Visual primitives for the reference-inspired NOOP interface.
/// Kept independent of repository state so existing BLE, HealthKit, and analytics flows remain unchanged.
enum ReferenceTheme {
    static let background = Color(red: 0.025, green: 0.039, blue: 0.047)
    static let surface = Color(red: 0.065, green: 0.086, blue: 0.100)
    static let border = Color.white.opacity(0.10)
    static let recovery = Color(red: 0.20, green: 0.88, blue: 0.42)
    static let strain = Color(red: 0.04, green: 0.59, blue: 1.0)
    static let sleep = Color(red: 0.48, green: 0.39, blue: 1.0)
    static let muted = Color(red: 0.62, green: 0.67, blue: 0.70)
}

struct ReferenceMetricRing: View {
    let progress: Double
    let value: String
    let label: String
    let tint: Color
    var diameter: CGFloat = 210

    var body: some View {
        ZStack {
            Circle()
                .stroke(tint.opacity(0.17), lineWidth: 13)
            Circle()
                .trim(from: 0, to: min(1, max(0, progress)))
                .stroke(
                    AngularGradient(colors: [tint.opacity(0.55), tint], center: .center),
                    style: StrokeStyle(lineWidth: 13, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            VStack(spacing: 3) {
                Text(value)
                    .font(.system(size: diameter * 0.19, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.white)
                Text(label.uppercased())
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .tracking(1.2)
                    .foregroundStyle(.white)
            }
        }
        .frame(width: diameter, height: diameter)
        .shadow(color: tint.opacity(0.16), radius: 25)
        .accessibilityElement(children: .combine)
    }
}

struct ReferenceMetricTile: View {
    let symbol: String
    let value: String
    let label: String
    let tint: Color

    var body: some View {
        VStack(spacing: 7) {
            Image(systemName: symbol)
                .font(.system(size: 19, weight: .semibold))
                .foregroundStyle(tint)
            Text(value)
                .font(.system(size: 23, weight: .semibold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.white)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
            Text(label.uppercased())
                .font(.system(size: 10, weight: .medium))
                .tracking(0.5)
                .foregroundStyle(.white.opacity(0.83))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(ReferenceTheme.surface, in: RoundedRectangle(cornerRadius: 13))
        .overlay(RoundedRectangle(cornerRadius: 13).stroke(ReferenceTheme.border))
    }
}

struct ReferenceCard<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        content
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(ReferenceTheme.surface, in: RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(ReferenceTheme.border))
    }
}
#endif
