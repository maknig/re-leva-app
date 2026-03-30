//
//  ViewController.swift
//  bluetooth
//
//  Created by Matthias König on 19.08.2024.
//

import UIKit
import CoreBluetooth
import SwiftUI
import Charts
import Foundation



class ViewController: UIViewController {
    var bluetoothManager = BluetoothManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        let hostingController = UIHostingController(rootView: LineChartView(bluetoothManager: bluetoothManager))
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}




struct DataPoint: Identifiable {
    let id = UUID()
    let timestamp: Date
    let value: Double
}



class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?
    var dataCharacteristic1: CBCharacteristic?
    var dataCharacteristic2: CBCharacteristic?
    var characteristicToWrite: CBCharacteristic?
    
    var targetPeripheral: CBPeripheral?

    @Published var receivedData1: [DataPoint] = []
    @Published var receivedData2: [DataPoint] = []

    private let targetDeviceName = "Pico 28:CD:C1:0D:51:C1"
    private let targetCharacteristicUUID1 = CBUUID(string: "0x2A6E")  // Replace with your first characteristic UUID
    private let targetCharacteristicUUID2 = CBUUID(string: "0x2AAE")  // Replace with your second characteristic UUID
    private let targetCharacteristicUUID3 = CBUUID(string: "0x2A6F")  // Replace with your second characteristic UUID

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        print("BluetoothManager initialized.")
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central Manager state updated: \(central.state)")
        if central.state == .poweredOn {
            print("Bluetooth is powered on. Starting scan...")
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("Bluetooth is not available.")
        }
    }
    




    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered peripheral: \(peripheral.name ?? "Unknown")")
        if let peripheralName = peripheral.name, peripheralName == targetDeviceName {
            print("Target device '\(targetDeviceName)' found. Connecting...")
            centralManager.stopScan()
            connectedPeripheral = peripheral
            connectedPeripheral?.delegate = self
            centralManager.connect(peripheral, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral: \(peripheral.name ?? "Unknown")")
        peripheral.discoverServices(nil)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }
        guard let services = peripheral.services else { return }
        print("Discovered services: \(services)")
        for service in services {
            peripheral.discoverCharacteristics([targetCharacteristicUUID1, targetCharacteristicUUID2, targetCharacteristicUUID3], for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Error discovering characteristics: \(error.localizedDescription)")
            return
        }
        guard let characteristics = service.characteristics else { return }
        print("Discovered characteristics: \(characteristics)")
        for characteristic in characteristics {
            if characteristic.uuid == targetCharacteristicUUID1 {
                print("Found target characteristic 1: \(characteristic.uuid)")
                dataCharacteristic1 = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
            } else if characteristic.uuid == targetCharacteristicUUID2 {
                print("Found target characteristic 2: \(characteristic.uuid)")
                dataCharacteristic2 = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
            } else if characteristic.uuid == targetCharacteristicUUID3 {
                print("Found target characteristic 3: \(characteristic.uuid)")
                characteristicToWrite = characteristic
                //peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func writeToCharacteristic(data: Data) {
            guard let peripheral = connectedPeripheral, let characteristic = characteristicToWrite else {
                print("Peripheral or characteristic not set.")
                return
            }
            
            peripheral.writeValue(data, for: characteristic, type: .withResponse)
            print("Data written to characteristic: \(data)")
        }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error updating value for characteristic: \(error.localizedDescription)")
            return
        }
        if let value = characteristic.value {
            print("Received data from characteristic \(characteristic.uuid): \(value as NSData)")
            guard value.count >= MemoryLayout<Int16>.size else {
                print("Received data is too short to be a valid Double.")
                return
            }
            
            let dataValue = value.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) -> Int16 in
                return pointer.load(as: Int16.self)
            }
            
            let dataPoint = DataPoint(timestamp: Date(), value: Double(dataValue)/100)
            print("Parsed data value: \(dataValue) at \(dataPoint.timestamp)")
            DispatchQueue.main.async {
                if characteristic.uuid == self.targetCharacteristicUUID1 {
                    self.receivedData1.append(dataPoint)
                    print("Data for characteristic 1 appended. Total points: \(self.receivedData1.count)")
                } else if characteristic.uuid == self.targetCharacteristicUUID2 {
                    self.receivedData2.append(dataPoint)
                    print("Data for characteristic 2 appended. Total points: \(self.receivedData2.count)")
                }
            }
        }
    }
}



