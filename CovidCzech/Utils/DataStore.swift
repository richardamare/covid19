//
//  DataStore.swift
//  CovidCzech
//
//  Created by Richard Amare on 5/21/22.
//

import Foundation

class DataStore: ObservableObject {
    private let repository: DataRepository
    
    init(repository: DataRepository = DataRepositoryImpl()) {
        self.repository = repository
    }
    
    @Published private(set) var country: Country?
    @Published var alertItem: AlertItem?
    @Published var selectedRegion: String = ""
    @Published var selectedPreview: ChartPreview = .week
    
    @MainActor
    func getData() async {
        do {
            let res = try await repository.fetchData()
            country = res
            selectedRegion = regions.first ?? ""
        } catch {
            alertItem = .ok(title: "Error", message: error.localizedDescription)
        }
    }
    
    var chartData: [InfectedDaily] {
        country?.infectedDaily.optionalPrefix(selectedPreview.limit) ?? []
    }
    
    var regions: [String] {
        country?.infectedByRegion.map { $0.name } ?? []
    }
    
    var recoveredByRegion: Region? {
        region(for: selectedRegion, in: country?.recoveredByRegion ?? [])
    }
    
    var deceasedByRegion: Region? {
        region(for: selectedRegion, in: country?.deceasedByRegion ?? [])
    }
    
    var infectedByRegion: Region? {
        region(for: selectedRegion, in: country?.infectedByRegion ?? [])
    }
    
    private func region(for string: String, in regions: [Region]) -> Region? {
        regions.first(where: { $0.name == string })
    }
}
