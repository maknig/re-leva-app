# Re-Leva App ☕📱

[![Swift](https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=swift&logoColor=white)](https://swift.org/)
[![iOS](https://img.shields.io/badge/iOS-000000?style=flat-square&logo=apple&logoColor=white)](https://www.apple.com/ios/)
[![Bluetooth](https://img.shields.io/badge/Bluetooth-0082FC?style=flat-square&logo=bluetooth&logoColor=white)](https://developer.apple.com/documentation/corebluetooth)

Native iOS application for the **[Re-Leva](https://github.com/maknig/re-leva-app.git)** espresso machine project. It uses Bluetooth Low Energy (BLE) to interface with the machine's hardware for real-time thermal management and monitoring.

---

## 🚀 Features

- **BLE Connectivity**: Scan and pair with the Re-Leva coffee machine.
- **Live Temperature**: Real-time monitoring of the boiler/group head temperature.
- **Target Control**: Set and update the target temperature (PID setpoint) directly from the app.
- **Native UI**: Built with SwiftUI for low-latency updates and responsive control.

## 🛠 Tech Stack

- **Language**: Swift 5
- **UI Framework**: SwiftUI
- **Hardware Communication**: CoreBluetooth (BLE)
- **Architecture**: MVVM

## 📦 Setup

1.  **Clone the repository**
    ```bash
    git clone [https://github.com/maknig/re-leva-app.git](https://github.com/maknig/re-leva-app.git)
    ```
2.  **Open in Xcode**
    ```bash
    open ReLeva.xcodeproj
    ```
3.  **Run**
    Select a physical iPhone (required for Bluetooth) and press `Cmd + R`.

## 📂 Project Structure

- `BluetoothManager.swift`: Handles the `CBCentralManager` logic, scanning, and peripheral communication.
- `ContentView.swift`: Main dashboard for temperature display and slider controls.
- `TemperatureViewModel.swift`: Bridges the Bluetooth data to the SwiftUI views.
