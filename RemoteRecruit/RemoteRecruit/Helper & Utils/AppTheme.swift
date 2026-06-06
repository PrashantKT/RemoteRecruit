//
//  AppTheme.swift
//  RemoteRecruit
//
//  Created by OpenAI on 06/06/26.
//

import SwiftUI

enum AppTheme {
    static let backgroundStart = Color(hex: "F5F7FB")
    static let backgroundEnd = Color(hex: "E9EEF8")
    static let cardBackground = Color(.systemBackground)
    static let subtleBorder = Color(.separator).opacity(0.16)
    static let salaryGreen = Color(hex: "0C9B6A")
    static let locationRed = Color(hex: "D64545")
    static let accentBlue = Color(hex: "2F6BFF")
    static let accentPurple = Color(hex: "6D4CFF")

    static let rowGradient = LinearGradient(
        colors: [Color(hex: "2F6BFF"), Color(hex: "6D4CFF")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static func employmentColor(_ type: String?) -> Color {
        guard let type else { return .gray }
        switch type.lowercased() {
        case "Full Time".lowercased():
            return Color(hex: "12A57A")
        case "Part Time".lowercased():
            return Color(hex: "F59E0B")
        case "Contractor".lowercased():
            return Color(hex: "7C3AED")
        case "Temporary".lowercased():
            return Color(hex: "2563EB")
        default:
            return .gray
        }
    }

    static func avatarGradient(for name: String) -> LinearGradient {
        let palettes: [(Color, Color)] = [
            (Color(hex: "2F6BFF"), Color(hex: "6D4CFF")),
            (Color(hex: "12A57A"), Color(hex: "54C6A0")),
            (Color(hex: "F97316"), Color(hex: "FDBA74")),
            (Color(hex: "0EA5E9"), Color(hex: "38BDF8"))
        ]
        let hash = name.unicodeScalars.reduce(0) { ($0 &* 31) &+ Int($1.value) }
        let pair = palettes[abs(hash) % palettes.count]
        return LinearGradient(colors: [pair.0, pair.1], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&value)

        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, value >> 16, (value >> 8) & 0xFF, value & 0xFF)
        case 8:
            (a, r, g, b) = (value >> 24, (value >> 16) & 0xFF, (value >> 8) & 0xFF, value & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
