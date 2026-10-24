#if os(iOS)
import SwiftUI

/// Reference-style Today dashboard. Reads existing Repository values; does not alter scoring or sync.
struct ReferenceTodayView: View {
    @EnvironmentObject private var repo: Repository
    @EnvironmentObject private var live: LiveState

    private var recovery: Double? { repo.today?.recovery }
    private var strain: Double? { repo.today?.strain }
    private var hrv: Double? { repo.today?.avgHrv }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    HStack(spacing: 7) {
                        Image(systemName: "waveform.path.ecg")
                            .foregroundStyle(ReferenceTheme.strain)
                        Text("NOOP")
                            .font(.system(size: 18, weight: .medium))
                            .tracking(2)
                    }
                    Spacer()
                    HStack(spacing: 5) {
                        Image(systemName: "antenna.radiowaves.left.and.right")
                        Text(live.connected ? "Connected" : "Disconnected")
                    }
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(live.connected ? ReferenceTheme.recovery : ReferenceTheme.muted)
                }
                .padding(.top, 12)

                VStack(spacing: 5) {
                    Text("Today")
                        .font(.system(size: 17, weight: .semibold))
                    Text(Date.now.formatted(date: .abbreviated, time: .omitted))
                        .font(.system(size: 13))
                        .foregroundStyle(ReferenceTheme.muted)
                }

                ReferenceMetricRing(
                    progress: (recovery ?? 0) / 100,
                    value: recovery.map { "\(Int($0.rounded()))%" } ?? "—",
                    label: "Recovery",
                    tint: ReferenceTheme.recovery,
                    diameter: 220
                )
                .padding(.vertical, 8)

                HStack(spacing: 9) {
                    ReferenceMetricTile(
                        symbol: "waveform.path",
                        value: strain.map { String(format: "%.1f", $0) } ?? "—",
                        label: "Strain",
                        tint: ReferenceTheme.strain
                    )
                    ReferenceMetricTile(
                        symbol: "moon.fill",
                        value: "—",
                        label: "Sleep",
                        tint: ReferenceTheme.sleep
                    )
                    ReferenceMetricTile(
                        symbol: "heart.fill",
                        value: hrv.map { "\(Int($0.rounded()))" } ?? "—",
                        label: "HRV (ms)",
                        tint: .pink
                    )
                }

                ReferenceCard {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "heart.text.square.fill")
                                .foregroundStyle(ReferenceTheme.recovery)
                            Text("Recovery insights")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        Text(recoveryInsight)
                            .font(.system(size: 13))
                            .foregroundStyle(ReferenceTheme.muted)
                            .fixedSize(horizontal: false, vertical: true)
                        HStack {
                            Spacer()
                            Text("Scores are calculated from your synced data")
                                .font(.system(size: 10))
                                .foregroundStyle(ReferenceTheme.muted)
                        }
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 28)
        }
        .background(ReferenceTheme.background.ignoresSafeArea())
        .foregroundStyle(.white)
    }

    private var recoveryInsight: String {
        guard let recovery else {
            return "Recovery is not available yet. Connect and sync your device to build a baseline."
        }
        if recovery >= 67 { return "Your recovery is high. Your body appears ready for a more demanding day." }
        if recovery >= 34 { return "Your recovery is moderate. Balance training with rest and monitor how you feel." }
        return "Your recovery is low. Consider prioritizing rest and lighter activity today."
    }
}
#endif
