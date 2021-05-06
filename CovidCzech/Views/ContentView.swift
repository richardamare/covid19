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
                        Text("lastUpdate \(viewModel.timeAgo(for: viewModel.lastUpdated))")
                        Text("lastChecked \(viewModel.timeAgo(for: viewModel.lastChecked))")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 10)
                    .foregroundColor(.primary)
                }
            }
            
            Section(header: Text("cases")) {
                Chart(data: viewModel.graphData)
                    .chartStyle(LineChartStyle(.quadCurve, lineColor: .accentColor, lineWidth: 2.5))
                    .frame(height: UIScreen.main.bounds.height * 0.225)
                    .padding(.top, 15)
                    .padding(.bottom, 5)
                
                Picker(selection: $viewModel.timeRange, label: Text("Time Range")) {
                    ForEach(GraphRange.allCases, id: \.self) { range in
                        Text(range.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom, 10)
                .padding(.top, 5)
            }
            
            Section(header: countryHeader) {
                ListRowView(key: "infected", value: viewModel.country.infected)
                ListRowView(key: "recovered", value: viewModel.country.recovered)
                ListRowView(key: "hospitalized", value: viewModel.country.hospitalized)
                ListRowView(key: "critical", value: viewModel.country.critical)
                ListRowView(key: "deceased", value: viewModel.country.deceased)
                
                if viewModel.showMore {
                    ListRowView(key: "antigen", value: viewModel.country.antigen)
                    ListRowView(key: "pcr", value: viewModel.country.pcr)
                    ListRowView(key: "totalTested", value: viewModel.country.totalTested)
                }
            }
            
            Section(header: Text("region")) {
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
            
            Section(header: Text(viewModel.currentRegion)) {
                ListRowView(key: "infected", value: viewModel.currentRegionData.infected)
                ListRowView(key: "recovered", value: viewModel.currentRegionData.recovered)
                ListRowView(key: "deceased", value: viewModel.currentRegionData.deceased)
            }
            
            Section {
                Link(destination: URL(string: "https://onemocneni-aktualne.mzcr.cz/covid-19")!) {
                    Label("source \("onemocneni-aktualne.mzcr.cz")", systemImage: "link.circle")
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
            Button(viewModel.showMore ? "less" : "more") {
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




