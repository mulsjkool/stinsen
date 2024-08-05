//
//  CustomTabbar.swift
//  BookMee
//
//  Created by Phung Chinh on 3/8/24.
//

import SwiftUI

@available(iOS 15.0, *)
struct PlayStationTabbarContainerView<T: TabCoordinatable>: View {
    
    private var coordinator: T
    private var views: [AnyView]
    private var configration: PlayStationTabbarConfiguration
    
    @Binding var activeTab: Int
    
    init(activeTab: Binding<Int>, coordinator: T, views: [AnyView], configration: PlayStationTabbarConfiguration) {
        self._activeTab = activeTab
        self.coordinator = coordinator
        self.views = views
        self.configration = configration
    }
    
    
    var body: some View {
        VStack {
            ZStack {
                views[activeTab]
                    .padding(.bottom, 16)
            }
            PlayStationCustomTabbarView(coordinator: coordinator, activeTab: $activeTab, totalTab: CGFloat(views.count), configuration: configration)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}


@available(iOS 15.0, *)
struct PlayStationCustomTabbarView<T: TabCoordinatable>: View {
    
    var coordinator: T
    
    @Binding var activeTab: Int
    
    var totalTab: CGFloat
    var configuration: PlayStationTabbarConfiguration
    
    var body: some View {
        HStack {
            ForEach(Array(coordinator.child.allItems.enumerated()), id: \.offset) { item in
                Button {
                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.7)) {
                        activeTab = item.offset
                    }
                } label: {
                    let offset = offset(item.offset)
                    VStack {
                        item.element.tabItem(item.offset == activeTab)
                            .frame(width: 30, height: 30)
                            .offset(y: offset)
                            .contentShape(Rectangle())
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.top, 12)
        .padding(.bottom, 20)
        .padding(.bottom, safeArea.bottom == 0 ? 30 : safeArea.bottom)
        .background(content: {
            ZStack {
                TabbarTopCurve()
                    .stroke(.white, lineWidth: 0.5)
                    .blur(radius: 0.5)
                    .padding(.horizontal, -5)
                
                if #available(iOS 16.0, *) {
                    TabbarTopCurve()
                        .fill(configuration.theme.backgroundColor.opacity(0.5).gradient)
                } else {
                    TabbarTopCurve()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [configuration.theme.backgroundColor.opacity(0.5), configuration.theme.backgroundColor.opacity(0.5)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
            }
        })
        .overlay(content: {
            GeometryReader(content: { proxy in
                let rect = proxy.frame(in: .global)
                let width = rect.width
                let maxedWidth = width * totalTab
                let height = rect.height
                
                Circle()
                    .fill(.clear)
                    .frame(width: maxedWidth, height: maxedWidth)
                    .background(alignment: .top) {
                        Rectangle()
                            .fill(.linearGradient(colors: [
                                configuration.theme.tabBackgroundColor,
                                configuration.theme.backgroundColor,
                                configuration.theme.backgroundColor,
                            ], startPoint: .top, endPoint: .bottom))
                    }
                    .overlay(content: {
                        Circle()
                            .stroke(.white, lineWidth: 0.2)
                            .blur(radius: 0.5)
                    })
                    .frame(width: width)
                    .mask(alignment: .top) {
                        Circle()
                            .frame(width: maxedWidth, height: maxedWidth, alignment: .top)
                        
                    }
                    .background(content: {
                        Rectangle()
                            .fill(.white)
                            .frame(width: 45, height: 4)
                            .glow(color: .white.opacity(0.5), radius: 50)
                            .glow(color: .blue.opacity(0.7), radius: 30)
                            .offset(y: -1.5)
                            .offset(y: -maxedWidth / 2)
                            .rotationEffect(.init(degrees: calculateRotation(maxedWidth: maxedWidth / 2, actualWidth: width, true)))
                            .rotationEffect(.init(degrees: calculateRotation(maxedWidth: maxedWidth / 2, actualWidth: width)))
                    })
                    .offset(y: height / 2.1)
            })
            .overlay(alignment: .bottom, content: {
                Text(configuration.titles[activeTab])
                    .font(configuration.theme.titleFont)
                    .foregroundColor(configuration.theme.titleColor)
                    .offset(y: safeArea.bottom == 0 ? -15 : -safeArea.bottom + 12)
            })
        })
        .preferredColorScheme(.dark)
    }
    
    func calculateRotation(maxedWidth y: CGFloat, actualWidth: CGFloat, _ isInital: Bool = false) -> CGFloat {
        
        let activeTab = CGFloat(self.activeTab)
        let tabWidth = actualWidth / totalTab
        
        let firstTabPosition: CGFloat = -(actualWidth - tabWidth) / 2
        let tan = y / firstTabPosition
        let radians = atan(tan)
        let degree = radians * 180 / .pi
        
        if isInital {
            return -(degree + 90)
        }
        
        let x = tabWidth * activeTab
        let tan_ = y / x
        let radians_ = atan(tan_)
        let degree_ = radians_ * 180 / .pi
        let value = -(degree_ - 90)
                
        let oddTotalTab = totalTab.truncatingRemainder(dividingBy: 2) > 0
        let extraValue = totalTab > 4 ? 0.15 : 0.2
        if activeTab >= (oddTotalTab ? totalTab - 1 : totalTab) / 2 {
            return value + extraValue * (activeTab - 1)
        }
        return value
    }
    
    func offset(_ tab: Int) -> CGFloat {
        let totalIndicies = totalTab
        let currentIndex = CGFloat(tab)
        let progress = currentIndex / totalIndicies
        
        return progress < 0.5 ? (currentIndex * -10) : ((totalIndicies - currentIndex - 1) * -10)
    }
}
