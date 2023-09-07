//
//  NetworkStatus.swift
//  TodaysTrendingMovies
//
//  Created by Nhan Bao on 2023/09/06.
//

import Foundation
import Network

class NetworkStatus: ObservableObject {
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitor")

    @Published var isConnected: Bool

    init() {
        monitor = NWPathMonitor()
        isConnected = true

        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }

        monitor.start(queue: queue)
    }
}
