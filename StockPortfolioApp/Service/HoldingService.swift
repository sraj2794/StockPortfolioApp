//
//  HoldingService.swift
//  StockPortfolioApp
//
//  Created by Raj Shekhar on 24/05/24.
//

import Foundation

protocol HoldingsServiceProtocol {
    func fetchHoldings(completion: @escaping (Result<[Holding], Error>) -> Void)
}

final class HoldingsService: HoldingsServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func fetchHoldings(completion: @escaping (Result<[Holding], Error>) -> Void) {
        guard let url = URL(string: "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        networkManager.makeRequest(url: url) { (result: Result<HoldingsData, Error>) in
            switch result {
            case .success(let holdingsData):
                completion(.success(holdingsData.data.userHolding))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
