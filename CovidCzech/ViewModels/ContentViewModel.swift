//
//  ContentViewModel.swift
//  CovidCzech
//
//  Created by Richard Amare on 10/8/21.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var pickedRegion: String = "Hlavní město Praha"
    @Published var selectedChartPreview: ChartPreview = .week
    @Published var countryData: Country = .dummy
    @Published var alert = (isPresented: false, title: "", message: "")
    
    @AppStorage("lastChecked") var lastChecked: Date = .now
    
    var chartData: [InfectedDaily] {
        countryData.infectedDaily.reduced(to: selectedChartPreview)
    }
    
    var regionNames: [String] {
        countryData.infectedByRegion.map { $0.name }
    }
    
    var updated: String {
        countryData.lastUpdatedAtSource.toDate().timeAgo
    }
    
    var checked: String {
        lastChecked.timeAgo
    }
    
    var deceasedByRegion: Region {
        assignRegion(for: pickedRegion, in: countryData.deceasedByRegion)
    }
    
    var infectedByRegion: Region {
        assignRegion(for: pickedRegion, in: countryData.infectedByRegion)
    }
    
    var recoveredByRegion: Region {
        assignRegion(for: pickedRegion, in: countryData.recoveredByRegion)
    }
    
    func assignRegion(for string: String, in regions: [Region]) -> Region {
        regions.first(where: { $0.name == string }) ?? .dummy
    }
    
    func fetchData() async {
        let url = URL(string: "https://api.apify.com/v2/key-value-stores/K373S4uCFR9W1K8ei/records/LATEST?disableRedirect=true")
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            let decoded = try JSONDecoder().decode(Country.self, from: data)
            DispatchQueue.main.async {
                self.countryData = decoded
                self.lastChecked = .now
            }
        } catch {
            print(error.localizedDescription)
            DispatchQueue.main.async {
                self.alert = (true, "Error", error.localizedDescription)
            }
        }
    }
}
