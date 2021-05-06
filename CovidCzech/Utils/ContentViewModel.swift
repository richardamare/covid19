//
//  ContentViewModel.swift
//  CovidCzech
//
//  Created by Richard Amare on 05.05.2021.
//

import SwiftUI
import SwiftyJSON

final class ContentViewModel: ObservableObject {
    @AppStorage("lastChecked") var lastChecked = Date()
    @AppStorage("lastUpdate") var lastUpdated = Date()
    
    @Published var timeRange: GraphRange = .all
    @Published var currentRegion = regionNames[0]
    @Published var showMore = false
    @Published var infectedDaily: [Double] = []
    @Published var regions: [Region] = []
    @Published var country: Country = defaultCountry
    
    func timeAgo(for date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    func stringTime(for time: String) -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.s'Z'"
        return formatter.date(from: time) ?? Date()
    }
    
    // MARK: - REGION
    
    func changeRegion(region: String) {
        currentRegion = region
    }
    
    var currentRegionData: Region {
        regions.first(where: { $0.name == currentRegion }) ?? defaultRegion
    }
    
    // MARK: - GRAPH
    
    func convertForGraph(range: GraphRange) -> [Double] {
        infectedDaily.map { $0 / scaleGraph(range: range) }
    }
    
    func scaleGraph(range: GraphRange) -> Double {
        switch range {
        case .week:
            return 5000
        case .month:
            return 7500
        case .threeMonths:
            return 16500
        case .sixMonths:
            return 18000
        case .all:
            return 20000
        }
    }
    
    var graphData: [Double] {
        switch timeRange {
        case .week:
            return convertForGraph(range: .week).suffix(7)
        case .month:
            return convertForGraph(range: .month).suffix(30)
        case .threeMonths:
            return convertForGraph(range: .threeMonths).suffix(90)
        case .sixMonths:
            return convertForGraph(range: .sixMonths).suffix(180)
        case .all:
            return convertForGraph(range: .all)
        }
    }
    
    // MARK: - JSON
    
    func fetchAllData() {
        let url = "https://api.apify.com/v2/key-value-stores/K373S4uCFR9W1K8ei/records/LATEST?disableRedirect=true"
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: URL(string: url)!) { [self] data, response, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            let json = try! JSON(data: data!)
            
            fetchStats(json: json)
            fetchCases(json: json)
            fetchRegions(json: json)
            
            let responseLastUpdate = json["lastUpdatedAtSource"].stringValue
            
            lastChecked = Date()
            lastUpdated = stringTime(for: responseLastUpdate)
        }
        
        task.resume()
    }
    
    func fetchCases(json: JSON) {
        DispatchQueue.main.async {
            self.infectedDaily.removeAll()
            
            for i in json["infectedDaily"] {
                let infected = i.1["value"].doubleValue
                self.infectedDaily.append(infected)
            }
        }
    }
    
    func fetchRegions(json: JSON) {
        var infected: [Int] = []
        var recovered: [Int] = []
        var deceased: [Int] = []
        
        for i in json["infectedByRegion"] {
            let val = i.1["value"].intValue
            infected.append(val)
        }
        
        for i in json["recoveredByRegion"] {
            let val = i.1["value"].intValue
            recovered.append(val)
        }
        
        for i in json["deceasedByRegion"] {
            let val = i.1["value"].intValue
            deceased.append(val)
        }
        
        DispatchQueue.main.async {
            for i in 0..<regionNames.count {
                self.regions.append(
                    Region(
                        name: regionNames[i],
                        infected: infected[i],
                        recovered: recovered[i],
                        deceased: deceased[i]
                    )
                )
            }
        }
    }
    
    func fetchStats(json: JSON) {
        let deceased = json["deceased"].intValue
        let recovered = json["recovered"].intValue
        let critical = json["critical"].intValue
        let hospitalized = json["hospitalized"].intValue
        let infected = json["active"].intValue
        let totalTested = json["totalTested"].intValue
        let testedPCR = json["testedPCR"].intValue
        let testedAG = json["testedAG"].intValue
        
        DispatchQueue.main.async {
            self.country = Country(
                infected: infected,
                recovered: recovered,
                hospitalized: hospitalized,
                critical: critical,
                deceased: deceased,
                antigen: testedAG,
                pcr: testedPCR,
                totalTested: totalTested
            )
        }
    }
}
