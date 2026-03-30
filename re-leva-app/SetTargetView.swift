//
//  SetTargetView.swift
//  bluetooth
//
//  Created by Matthias König on 25.08.2024.
//

import Foundation
import SwiftUI


struct CharacteristicWriteView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    @State private var textFieldValue: String = ""
    @State private var integerValue: String = ""
    @State private var showAlert = false
    @State private var alertMessage: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Set CoffeBoiler Temperature")
                .font(.headline)
            
            TextField("Temperature", text: $integerValue)
                            .keyboardType(.numberPad) // Ensures only numeric input
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
            
            Button(action: {
                            if let value = Int(integerValue) {
                                // Convert the integer to Data
                                var intValue = value
                                let data = Data(bytes: &intValue, count: MemoryLayout<Int>.size)

                                // Write the integer to the characteristic
                                bluetoothManager.writeToCharacteristic(data: data)
                                showAlert = false
                                alertMessage = "Integer \(value) sent successfully."
                            } else {
                                showAlert = true
                                alertMessage = "Please enter a valid integer."
                            }
                        }) {
                            Text("Set Temperature")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Write Characteristic"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                        }
        }
        .padding()
        .navigationTitle("Write Integer")
        .hideKeyboardOnTap()
        
    }
        
}
