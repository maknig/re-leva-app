//
//  re_leva_appApp.swift
//  re-leva-app
//
//  Created by Matthias König on 07.02.2025.
//

import SwiftUI

@main
struct bluetoothApp: App {
    @StateObject private var bluetoothManager = BluetoothManager()
    var body: some Scene {
        WindowGroup {
            ContentView(bluetoothManager: bluetoothManager)
        }
    }
}
