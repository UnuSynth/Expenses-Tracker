//
//  NumberPad.swift
//  Expenses Tracker
//
//  Created by Amantay Abdyshev on 28/5/26.
//

import SwiftUI

struct NumberPad: View {
    @Binding var text: String

    private let keys: [[PadKey]] = [
        [.digit("1"), .digit("2"), .digit("3")],
        [.digit("4"), .digit("5"), .digit("6")],
        [.digit("7"), .digit("8"), .digit("9")],
        [.decimal, .digit("0"), .backspace]
    ]

    var body: some View {
        Grid(horizontalSpacing: 16, verticalSpacing: 12) {
            ForEach(keys.indices, id: \.self) { rowIndex in
                GridRow {
                    ForEach(keys[rowIndex], id: \.self) { key in
                        if #available(iOS 26.0, *) {
                            PadButton(key: key) { handle(key) }
                                .glassEffect(.regular.interactive(), in: .capsule)
                        } else {
                            PadButton(key: key) { handle(key) }
                                .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }

    private func handle(_ key: PadKey) {
        let sep = String.decimalSeparator
        switch key {
        case .digit(let d):
            if !text.contains(sep) && text == "0" { return }
            if let sepRange = text.range(of: sep),
               text[sepRange.upperBound...].count >= 2 { return }
            text.append(d)
        case .decimal:
            guard !text.contains(sep) else { return }
            text = text.isEmpty ? "0\(sep)" : text + sep
        case .backspace:
            guard !text.isEmpty else { return }
            text.removeLast()
        }
    }
}

private enum PadKey: Hashable {
    case digit(String)
    case decimal
    case backspace
}

private struct PadButton: View {
    let key: PadKey
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            keyLabel
                .frame(maxWidth: .infinity, minHeight: 56)
                .background(
                    Capsule()
                        .fill(Color(.systemBackground))
                )
                .contentShape(Capsule())
        }
        .buttonStyle(PadButtonStyle())
    }

    @ViewBuilder
    private var keyLabel: some View {
        switch key {
        case .digit(let d):
            Text(d)
                .font(.title2.weight(.semibold))
                .foregroundStyle(.primary)
        case .decimal:
            Text(.dot)
                .font(.title2.weight(.semibold))
                .foregroundStyle(.primary)
        case .backspace:
            Image(systemName: "delete.backward")
                .font(.title3.weight(.medium))
                .foregroundStyle(.secondary)
        }
    }
}

private struct PadButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    @Previewable @State var text = ""
    VStack(spacing: 24) {
        Text(text.isEmpty ? "0" : text)
            .font(.system(size: 56, weight: .bold))
            .monospacedDigit()
        NumberPad(text: $text)
    }
    .padding(.top, 32)
    .background(Color(.secondarySystemBackground))
}
