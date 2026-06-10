import SwiftUI

private struct SoundingPoint: Identifiable {
    let id = UUID()
    let sounding: Double
    let cubicMeters: Double
}

private let soundingPoints: [SoundingPoint] = [
    .init(sounding: 0.000, cubicMeters: 0.00),
    .init(sounding: 0.050, cubicMeters: 0.21),
    .init(sounding: 0.100, cubicMeters: 1.18),
    .init(sounding: 0.150, cubicMeters: 3.29),
    .init(sounding: 0.200, cubicMeters: 5.41),
    .init(sounding: 0.250, cubicMeters: 7.53),
    .init(sounding: 0.300, cubicMeters: 9.64),
    .init(sounding: 0.350, cubicMeters: 11.76),
    .init(sounding: 0.400, cubicMeters: 13.88),
    .init(sounding: 0.450, cubicMeters: 15.99),
    .init(sounding: 0.500, cubicMeters: 18.11),
    .init(sounding: 0.550, cubicMeters: 20.23),
    .init(sounding: 0.600, cubicMeters: 22.34),
    .init(sounding: 0.650, cubicMeters: 24.46),
    .init(sounding: 0.700, cubicMeters: 26.58),
    .init(sounding: 0.750, cubicMeters: 28.69),
    .init(sounding: 0.800, cubicMeters: 30.81),
    .init(sounding: 0.850, cubicMeters: 32.93),
    .init(sounding: 0.900, cubicMeters: 35.05),
    .init(sounding: 0.950, cubicMeters: 37.16),
    .init(sounding: 1.000, cubicMeters: 39.28),
    .init(sounding: 1.050, cubicMeters: 41.40),
    .init(sounding: 1.100, cubicMeters: 43.51),
    .init(sounding: 1.150, cubicMeters: 45.63)
]

private func interpolate(sounding: Double) -> Double? {
    guard let first = soundingPoints.first,
          let last = soundingPoints.last,
          sounding >= first.sounding,
          sounding <= last.sounding else {
        return nil
    }

    for index in 0..<(soundingPoints.count - 1) {
        let start = soundingPoints[index]
        let end = soundingPoints[index + 1]

        if sounding == start.sounding {
            return start.cubicMeters
        }

        if sounding > start.sounding && sounding < end.sounding {
            let ratio = (sounding - start.sounding) / (end.sounding - start.sounding)
            return start.cubicMeters + (end.cubicMeters - start.cubicMeters) * ratio
        }
    }

    return last.cubicMeters
}

struct ContentView: View {
    @State private var soundingInput = ""
    @State private var resultText = "-"
    @State private var errorText = ""

    private var currentDateText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.string(from: Date())
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 8) {
                        Text("Sonde Interpolation")
                            .font(.largeTitle.bold())
                        Text(currentDateText)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)

                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("Sounding")
                                .font(.headline)
                            Spacer()
                            Text("m³")
                                .font(.headline)
                        }

                        HStack(spacing: 12) {
                            TextField("Ex: 0.95", text: $soundingInput)
#if os(iOS)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
#else
                                .textFieldStyle(.plain)
#endif

                            Button("Calculer") {
                                calculate()
                            }
                            .buttonStyle(.borderedProminent)
                        }

                        HStack {
                            Text("Résultat")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(resultText)
                                .font(.title3.bold())
                        }

                        if !errorText.isEmpty {
                            Text(errorText)
                                .font(.footnote)
                                .foregroundStyle(.red)
                        }
                    }
                    .padding()
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Table d'interpolation")
                            .font(.headline)

                        ForEach(soundingPoints.prefix(8)) { point in
                            HStack {
                                Text(String(format: "%.3f", point.sounding))
                                Spacer()
                                Text(String(format: "%.2f", point.cubicMeters))
                            }
                            .font(.footnote.monospacedDigit())
                        }

                        Text("...")
                            .foregroundStyle(.secondary)
                            .font(.footnote)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
#if os(iOS)
                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
#else
                    .background(Color.gray.opacity(0.12), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
#endif
                }
                .padding()
            }
            .navigationTitle("Sonde")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
        }
    }

    private func calculate() {
        let normalized = soundingInput.replacingOccurrences(of: ",", with: ".")

        guard let sounding = Double(normalized) else {
            resultText = "-"
            errorText = "Entre une valeur valide."
            return
        }

        guard let interpolated = interpolate(sounding: sounding) else {
            resultText = "-"
            errorText = "Valeur hors plage."
            return
        }

        resultText = String(format: "%.3f", interpolated)
        errorText = ""
    }
}

#Preview {
    ContentView()
}
