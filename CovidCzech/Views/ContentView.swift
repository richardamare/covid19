//
//  ContentView.swift
//  CovidCzech
//
//  Created by Richard Amare on 10/4/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataStore: DataStore
    
    var country: Country? { dataStore.country }
    
    var body: some View {
        List {
            
            Section {
                LineChartView(data: dataStore.chartData)

                Picker(selection: $dataStore.selectedPreview, label: EmptyView()) {
                    ForEach(ChartPreview.allCases, id: \.self) { item in
                        Text(item.rawValue).tag(item)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.top, 4)
                .padding(.bottom, 8)
            }
            
            Section("Czech Republic") {
                InfoRow("Infected", value: country?.infected)
                InfoRow("Recovered", value: country?.recovered)
                InfoRow("Hospitalized", value: country?.hospitalized)
                InfoRow("Critical", value: country?.critical)
                InfoRow("Deceased", value: country?.deceased)
            }

            Section {
                InfoRow("Infected", value: dataStore.infectedByRegion?.value)
                InfoRow("Recovered", value: dataStore.recoveredByRegion?.value)
                InfoRow("Deceased", value: dataStore.deceasedByRegion?.value)
            } header: {
                Picker(selection: $dataStore.selectedRegion, label: Text(dataStore.selectedRegion)) {
                    ForEach(dataStore.regions, id: \.self) { item in
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
        .task { await dataStore.getData() }
        .refreshable { await dataStore.getData() }
        .alert(item: $dataStore.alertItem) { $0.alert }
        .navigationTitle("COVID CZ")
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Text("Last update: \(dataStore.country?.lastUpdated.timeAgo ?? "")")
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
        .environmentObject(DataStore())
    }
}
