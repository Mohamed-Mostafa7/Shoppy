//
//  NetworkReachabilityChecking.swift
//  Shoppy
//
//  Created by Mohamed Mostafa on 13/05/2025.
//

import Network

protocol NetworkReachabilityChecking {
    var isConnected: Bool { get }
    func startMonitoring()
    func stopMonitoring()
}

class NetworkReachability: NetworkReachabilityChecking {
    private var monitor: NWPathMonitor?
    private var isReachable = false
    
    var isConnected: Bool {
        return isReachable
    }

    init() {
        startMonitoring()
    }
    
    deinit {
        stopMonitoring()
    }

    func startMonitoring() {
        monitor = NWPathMonitor()
        
        // Set up the queue on which the monitor will run
        let queue = DispatchQueue(label: "NetworkMonitorQueue")
        
        monitor?.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self.isReachable = true
                } else {
                    self.isReachable = false
                }
            }
        }
        
        monitor?.start(queue: queue)
    }

    func stopMonitoring() {
        monitor?.cancel()
    }
}
