//
//  ContentViewModel.swift
//  CovidCzech
//
//  Created by Richard Amare on 10/8/21.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var selectedRegion: Region = .dummy
    @Published var regions: [Region] = []
    @Published var selectedChartPreview: ChartPreview = .week
    @Published var countryData: Country = .dummy
    
    @AppStorage("lastChecked") var lastChecked: Date = .now
    
    var chartData: [InfectedDaily] {
        countryData.infectedDaily.reduced(to: selectedChartPreview)
    }
    
    var updated: String {
        countryData.lastUpdatedAtSource.toDate().formatted(.relative(presentation: .named))
    }
    
    var checked: String {
        lastChecked.formatted(.relative(presentation: .named))
    }
    
    func assignRegion(for string: String) -> Region {
        regions.first(where: { $0.name == string }) ?? .dummy
    }
    
    var deceasedByRegion: Region {
        countryData.deceasedByRegion.first(where: { $0.name == selectedRegion.name }) ?? .dummy
    }
    
    var infectedByRegion: Region {
        countryData.infectedByRegion.first(where: { $0.name == selectedRegion.name }) ?? .dummy
    }
    
    var recoveredByRegion: Region {
        countryData.recoveredByRegion.first(where: { $0.name == selectedRegion.name }) ?? .dummy
    }
    
    var regionNames: [String] {
        countryData.infectedByRegion.map { $0.name }
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
        }
    }
}
