import Foundation
import SwiftUI

struct TabCoordinatableView<T: TabCoordinatable, U: View>: View {
    private var coordinator: T
    private let router: TabRouter<T>
    @ObservedObject var child: TabChild
    private var customize: (AnyView) -> U
    private var views: [AnyView]
    private var mode: TabCoordinatableMode
    
    var body: some View {
        customize(
            AnyView(
                makeViewWithMode(mode)
            )
        )
        .environmentObject(router)
    }
    
    @ViewBuilder
    private func makeViewWithMode(_ mode: TabCoordinatableMode) -> some View {
        switch self.mode {
        case .default:
            TabView(selection: $child.activeTab) {
                ForEach(Array(views.enumerated()), id: \.offset) { view in
                    view
                        .element
                        .tabItem {
                            coordinator.child.allItems[view.offset].tabItem(view.offset == child.activeTab)
                        }
                        .tag(view.offset)
                }
            }
        case let .playStation(config):
            PlayStationTabbarContainerView(
                activeTab: $child.activeTab,
                coordinator: coordinator,
                views: views,
                configration: config
            )
        }
    }
    
    init(paths: [AnyKeyPath], coordinator: T, customize: @escaping (AnyView) -> U) {
        self.coordinator = coordinator
        self.mode = coordinator.mode
        self.router = TabRouter(coordinator: coordinator.routerStorable)
        RouterStore.shared.store(router: router)
        self.customize = customize
        self.child = coordinator.child
        
        if coordinator.child.allItems == nil {
            coordinator.setupAllTabs()
        }

        self.views = coordinator.child.allItems.map {
            $0.presentable.view()
        }
    }
}
