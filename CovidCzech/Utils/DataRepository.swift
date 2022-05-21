//
//  DataRepository.swift
//  CovidCzech
//
//  Created by Richard Amare on 5/21/22.
//

import Foundation

protocol DataRepository {
    func fetchData() async throws -> Country
}

class DataRepositoryImpl: DataRepository {
    func fetchData() async throws -> Country {
        guard let url = URL.apiUrl else { throw DataError.invalidURL }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let (data, _) = try await URLSession.shared.data(from: url)
        return try decoder.decode(Country.self, from: data)
    }
}
