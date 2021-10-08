//
//  ContentView.swift
//  CovidCzech
//
//  Created by Richard Amare on 10/4/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 2.5) {
                    Text("Last update was \(viewModel.updated).")
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    Text("Checked \(viewModel.checked).")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
            }
            
            Section {
                LineChartView(data: viewModel.chartData)
                
                Picker(selection: $viewModel.selectedChartPreview, label: EmptyView()) {
                    ForEach(ChartPreview.allCases, id: \.self) { item in
                        Text(item.rawValue).tag(item)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.top, 4)
                .padding(.bottom, 8)
            }
            
            Section("Czech Republic") {
                InfoRow("Infected", value: viewModel.countryData.infected)
                InfoRow("Recovered", value: viewModel.countryData.recovered)
                InfoRow("Hospitalized", value: viewModel.countryData.hospitalized)
                InfoRow("Critical", value: viewModel.countryData.critical)
                InfoRow("Deceased", value: viewModel.countryData.deceased)
            }
            
            Section {
                InfoRow("Infected", value: viewModel.infectedByRegion.value)
                InfoRow("Recovered", value: viewModel.recoveredByRegion.value)
                InfoRow("Deceased", value: viewModel.deceasedByRegion.value)
            } header: {
                Picker(selection: $viewModel.pickedRegion, label: Text(viewModel.pickedRegion)) {
                    ForEach(viewModel.regionNames, id: \.self) { item in
                        Text(item).textCase(nil).tag(item)
                    }
                }
                .pickerStyle(.menu)
            }
            
            Section {
                Link(destination: .ministry) {
                    Label("Ministry of Health", systemImage: "link")
                }
                Link(destination: .erouska) {
                    Label("Get eRouška", systemImage: "link")
                }
            }
        }
        .listStyle(.insetGrouped)
        .task { await viewModel.fetchData() }
        .refreshable { await viewModel.fetchData() }
        .alert(viewModel.alert.title, isPresented: $viewModel.alert.isPresented) {} message: {
            Text(viewModel.alert.message)
        }
        .navigationTitle("COVID CZ")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
