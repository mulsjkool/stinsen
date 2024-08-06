//
//  Tab.swift
//  BookMee
//
//  Created by Phung Chinh on 3/8/24.
//

import SwiftUI

public struct PlayStationTabbarConfiguration {
    public var titles: [String]
    public var theme: PlayStationTabbarTheme
    
    public init(titles: [String], theme: PlayStationTabbarTheme) {
        self.titles = titles
        self.theme = theme
    }
}

public protocol PlayStationTabbarTheme {
    var titleColor: Color { get }
    var titleFont: Font { get }
    var glows: (Color, Color) { get }
    var backgroundColor: Color { get }
    var tabBackgroundColor: Color { get }
}

public enum PlayStationTabbarThemeCase: PlayStationTabbarTheme {
    case dark
    
    public var titleColor: Color {
        switch self {
        case .dark:
            return Color.white
        }
    }
    
    public var titleFont: Font {
        switch self {
        case .dark:
            return Font.system(size: 14, weight: .semibold)
        }
    }
    
    public var glows: (Color, Color) {
        switch self {
        case .dark:
            return (Color.white, Color.fromRGB(red: 0, green: 134, blue: 228))
        }
    }
    
    public var backgroundColor: Color {
        switch self {
        case .dark:
            return Color.fromRGB(red: 18, green: 20, blue: 21)
        }
    }
    
    public var tabBackgroundColor: Color {
        switch self {
        case .dark:
            return Color.fromRGB(red: 47, green: 57, blue: 61)
        }
    }
}

extension Color {
    static func fromRGB(red: Double, green: Double, blue: Double, opacity: Double = 255) -> Color {
    Color(red: red/255, green: green/255, blue: blue/255, opacity: opacity/255)
  }
}
