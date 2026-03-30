//
//  LineChartView.swift
//  bluetooth
//
//  Created by Matthias König on 25.08.2024.
//

import SwiftUI
import Charts


struct LineChartView: View {
    @ObservedObject var bluetoothManager: BluetoothManager

    var body: some View {
        VStack {
            // First characteristic plot with title and rounded rectangle
            VStack {
                Text("CoffeeBoiler Temperature")
                    .font(.headline)
                    .padding(.top)

                Chart {
                    ForEach(filteredData1) { dataPoint in
                        LineMark(
                            x: .value("Δt (s)", deltaT(from: dataPoint.timestamp, data: filteredData1)),
                            y: .value("Value 1", dataPoint.value)
                        )
                        .foregroundStyle(.blue)
                        //.symbol(by: .value("Symbol", "circle"))
                    }
                }
                //.chartXAxis {
                 //           AxisMarks(values: .stride(by: .second, count: 10)) { value in
                 //               AxisValueLabel(format: .dateTime.second(), centered: true)
                 //           }
                  //      }
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                    AxisValueLabel() {
                            if let doubleValue = value.as(Double.self) {
                                Text("\(Int(doubleValue))s")
                            }
                        }
                    }
                }
                //.chartXScale(domain: .automatic(includesZero: false))
                .chartXScale(domain: xDomain(for: filteredData1))
                .chartYScale(domain: .automatic(includesZero: false)) // Adjust domain based on expected data range
                .padding()
            }
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
            .padding()
            .onAppear {
                print("LineChartView (Characteristic 1) appeared with \(filteredData1.count) data points in the last minute.")
            }

            // Second characteristic plot with title and rounded rectangle
            VStack {
                Text("SteamBoiler Temperature")
                    .font(.headline)
                    .padding(.top)

                Chart {
                    ForEach(filteredData2) { dataPoint in
                        LineMark(
                            x: .value("Δt (s)", deltaT(from: dataPoint.timestamp, data: filteredData2)),
                            y: .value("Value 2", dataPoint.value)
                        )
                        .foregroundStyle(.red)
                        //.symbol(by: .value("Symbol", "square"))
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisValueLabel() {
                            if let doubleValue = value.as(Double.self) {
                                Text("\(Int(doubleValue))s")
                            }
                        }
                    }
                }

                .chartXScale(domain: xDomain(for: filteredData2))
                .chartYScale(domain: .automatic(includesZero: false)) // Adjust domain based on expected data range
                .padding()
            }
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
            .padding()
            .onAppear {
                print("LineChartView (Characteristic 2) appeared with \(filteredData2.count) data points in the last minute.")
            }
            .hideKeyboardOnTap()
            
        }
    }

    // Filter the received data to include only the last minute for the first characteristic
    private var filteredData1: [DataPoint] {
        let oneMinuteAgo = Date().addingTimeInterval(-60)
        return bluetoothManager.receivedData1.filter { $0.timestamp >= oneMinuteAgo }
    }

    // Filter the received data to include only the last minute for the second characteristic
    private var filteredData2: [DataPoint] {
        let oneMinuteAgo = Date().addingTimeInterval(-60)
        return bluetoothManager.receivedData2.filter { $0.timestamp >= oneMinuteAgo }
    }

    // Function to calculate Δt (in seconds) from the first data point within the last minute
    private func deltaT(from date: Date, data: [DataPoint]) -> Double {
        guard let firstTimestamp = bluetoothManager.receivedData1.first?.timestamp else {
            print("No data points available in the last minute.")
            return 0
        }
        let delta = date.timeIntervalSince(firstTimestamp)
        print("Δt for current data point: \(delta) seconds")
        return delta
    }

    // Function to calculate the x-axis domain (range) based on data timestamps
    private func xDomain(for data: [DataPoint]) -> ClosedRange<Double> {
        guard let firstTimestamp = data.first?.timestamp else {
            print("No data points available for x-domain calculation.")
            return 0...60
        }
        let timeIntervals = data.map { deltaT(from: $0.timestamp, data: data) }
        let minTimeInterval = timeIntervals.min() ?? 0
        let maxTimeInterval = timeIntervals.max() ?? 60
        print("X-axis domain for current data: \(minTimeInterval) to \(maxTimeInterval) seconds")
        return minTimeInterval...maxTimeInterval
    }
    // Function to calculate time in seconds from the first data point within the last minute
    private func timeInSeconds(from date: Date, data: [DataPoint]) -> Double {
        guard let firstTimestamp = data.first?.timestamp else {
            print("No data points available in the last minute.")
            return 0
        }
        let timeInterval = date.timeIntervalSince(firstTimestamp)
        print("Time in seconds since first data point in last minute: \(timeInterval)")
        return timeInterval
    }
}
