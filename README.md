# Re-Leva App ☕📱

[![Swift](https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=swift&logoColor=white)](https://swift.org/)
[![iOS](https://img.shields.io/badge/iOS-000000?style=flat-square&logo=apple&logoColor=white)](https://www.apple.com/ios/)
[![Bluetooth](https://img.shields.io/badge/Bluetooth-0082FC?style=flat-square&logo=bluetooth&logoColor=white)](https://developer.apple.com/documentation/corebluetooth)

Native iOS application for the **[Re-Leva](https://github.com/maknig/re-leva-app.git)** espresso machine project. This app leverages Bluetooth Low Energy (BLE) to interface with the hardware, enabling real-time thermal monitoring and remote PID setpoint control using a modern SwiftUI architecture.


## Features

- **BLE Communication**: Seamless scanning and pairing with the Re-Leva espresso machine.
- **MVVM Architecture**: Clean separation of concerns between Bluetooth logic, Data Models, and User Interface.
- **Real-time Telemetry**: Live display of coffee and steam boiler temperatures.
- **Dynamic Charts**: Interactive SwiftUI Charts rendering the last 60 seconds of temperature data.
- **PID Control**: Set target temperatures directly from the interface.


## Tech Stack

- **Language**: Swift 5.x
- **UI Framework**: SwiftUI
- **Visualization**: SwiftUI Charts
- **Hardware Protocol**: CoreBluetooth (BLE)
- **Architecture**: MVVM (Model-View-ViewModel)

---

## 📋 Prerequisites

Before you begin, ensure you have the following installed on your macOS machine:

- **Xcode**: Version 15.0 or later.
- **iOS Simulator**: iOS 15.0 or later (Note: Bluetooth requires a physical device).
- **Swift**: Included with Xcode.

---

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/maknig/re-leva-app.git
cd re-leva-app
```

### 2. Open in Xcode

```bash
open re_leva-app.xcodeproj
```

### 3. Configure Permissions

Go to your **Project Target** -> **Info** tab and add the following keys to `Info.plist`:

- `NSBluetoothAlwaysUsageDescription`: "This app uses Bluetooth to connect to your espresso machine."
- `NSBluetoothPeripheralUsageDescription`: "This app uses Bluetooth to connect to your espresso machine."

### 4. Run the App

- Select a physical **iPhone** device from the device dropdown.
- Press `Cmd + R` to build and run.

---

## Project Structure

The application follows a strict MVVM architecture to ensure maintainability and performance:

- **`re_leva_appApp.swift`**: The App lifecycle entry point. Manages the `@StateObject` for the Bluetooth Manager.
- **`BluetoothManager.swift`**: The ViewModel and Bluetooth Protocol implementation. It handles `CBCentralManager` state, peripheral discovery, and data parsing. It acts as the bridge between hardware data and the UI.
- **`ContentView.swift`**: The main container layout, combining the Chart view and the Target controls in a clean navigation stack.
- **`LineChartView.swift`**: A custom SwiftUI view that consumes `BluetoothManager` data and renders live line charts using the `Charts` framework.
- **`SetTargetView.swift`**: A dedicated view for user input, handling integer conversion and writing the target setpoint back to the Bluetooth characteristic.
