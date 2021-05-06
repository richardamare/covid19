//
//  ContentView.swift
//  CovidCzech
//
//  Created by Richard Amare on 05.05.2021.
//

import SwiftUI
import Charts

struct ContentView: View {
    
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        Form {
            Section {
                Button(action: viewModel.fetchAllData) {
                    VStack (alignment: .leading, spacing: 15) {
                        Text("Last update: \(viewModel.timeAgo(for: viewModel.lastUpdated)).")
                        Text("Checked \(viewModel.timeAgo(for: viewModel.lastChecked)).")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 10)
                    .foregroundColor(.primary)
                }
            }
            
            Section(header: Text("Region")) {
                Menu {
                    ForEach(regionNames, id: \.self) { region in
                        Button(action: {
                            viewModel.changeRegion(region: region)
                        }) {
                            HStack {
                                Text(region)
                                Spacer()
                                if viewModel.currentRegion == region {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text(viewModel.currentRegion)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(Font.title3.weight(.semibold))
                    }
                    .padding(.vertical)
                }
            }
            
            Section(header: Text("Cases")) {
                Chart(data: viewModel.graphData)
                    .chartStyle(LineChartStyle(.quadCurve, lineColor: .accentColor, lineWidth: 2.5))
                    .frame(height: UIScreen.main.bounds.height * 0.225)
                    .padding(.top, 15)
                
                Picker(selection: $viewModel.timeRange, label: Text("Time Range")) {
                    ForEach(GraphRange.allCases, id: \.self) { range in
                        Text(range.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom, 10)
            }
            
            Section(header: Text(viewModel.currentRegion)) {
                ListRowView(key: "Infected", value: viewModel.currentRegionData.infected)
                ListRowView(key: "Recovered", value: viewModel.currentRegionData.recovered)
                ListRowView(key: "Deaths", value: viewModel.currentRegionData.deceased)
            }
            
            Section(header: countryHeader) {
                ListRowView(key: "Infected", value: viewModel.country.infected)
                ListRowView(key: "Recovered", value: viewModel.country.recovered)
                ListRowView(key: "Hospitalized", value: viewModel.country.hospitalized)
                ListRowView(key: "Critical", value: viewModel.country.critical)
                ListRowView(key: "Deaths", value: viewModel.country.deceased)
                
                if viewModel.showMore {
                    ListRowView(key: "Anti-gene", value: viewModel.country.antigen)
                    ListRowView(key: "PCR tests", value: viewModel.country.pcr)
                    ListRowView(key: "Total tested", value: viewModel.country.totalTested)
                }
            }
            
            Section {
                Link(destination: URL(string: "https://onemocneni-aktualne.mzcr.cz/covid-19")!) {
                    Label("Source: onemocneni-aktualne.mzcr.cz", systemImage: "link.circle")
                        .font(.caption)
                }
            }
        }
        .accentColor(.blue)
        .onAppear(perform: viewModel.fetchAllData)
    }
    
    var countryHeader: some View {
        HStack {
            Text("Czech Republic")
            Spacer()
            Button(viewModel.showMore ? "Show less" : "Show more") {
                withAnimation(.easeOut) {
                    viewModel.showMore.toggle()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




