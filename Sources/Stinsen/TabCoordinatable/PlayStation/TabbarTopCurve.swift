//
//  TabbarTopCurve.swift
//  BookMee
//
//  Created by Phung Chinh on 4/8/24.
//

import SwiftUI

struct TabbarTopCurve: Shape {
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            
            let width = rect.width
            let height = rect.height
            let midWidth = width / 2
                        
            path.move(to: .init(x: 0, y: 5))
            
            path.addCurve(to: .init(x: midWidth, y: -20), control1: .init(x: midWidth / 2, y: -20), control2: .init(x: midWidth, y: -20))
            path.addCurve(to: .init(x: width, y: 5), control1: .init(x: midWidth + (midWidth / 2), y: -20), control2: .init(x: width, y: 5))
            
            path.addLine(to: .init(x: width, y: height))
            path.addLine(to: .init(x: 0, y: height))
            
            path.closeSubpath()
            
        }
    }
}

extension View {
    var safeArea: UIEdgeInsets {
        if let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first {
            return safeArea.safeAreaInsets
        }
        return .zero
    }
    
    func glow(color: Color, radius: CGFloat) -> some View {
        self
            .shadow(color: color, radius: radius / 2.5)
            .shadow(color: color, radius: radius / 2.5)
            .shadow(color: color, radius: radius / 2.5)
    }
}
