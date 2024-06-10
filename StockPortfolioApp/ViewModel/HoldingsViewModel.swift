//
//  HoldingsViewModel.swift
//  StockPortfolioApp
//
//  Created by Raj Shekhar on 22/05/24.
//

import Foundation
protocol HoldingsViewModelProtocol {
    var holdings: [Holding] { get }
    var currentValue: Double { get }
    var totalInvestment: Double { get }
    var totalPNL: Double { get }
    var todaysPNL: Double { get }
    var holdingsCount: Int { get }
    
    func setHoldings(_ holdings: [Holding])
    func loadHoldings(from data: Data)
    func holding(at index: Int) -> Holding
    func fetchHoldings(completion: @escaping (Bool, Error?) -> Void)
    func sortHoldings()
}

final class HoldingsViewModel: HoldingsViewModelProtocol {
    private(set) var holdings: [Holding] = []
    private let holdingsService: HoldingsServiceProtocol
    
    init(holdingsService: HoldingsServiceProtocol) {
        self.holdingsService = holdingsService
    }
    
    func setHoldings(_ holdings: [Holding]) {
        self.holdings = holdings
    }
    
    func loadHoldings(from data: Data) {
        let decoder = JSONDecoder()
        do {
            let holdingsData = try decoder.decode(HoldingsData.self, from: data)
            self.setHoldings(holdingsData.data.userHolding)
        } catch {
            print("Failed to decode holdings data: \(error.localizedDescription)")
        }
    }
    
    var currentValue: Double {
        return holdings.reduce(0) { $0 + ($1.ltp * Double($1.quantity)) }
    }
    
    var totalInvestment: Double {
        return holdings.reduce(0) { $0 + ($1.avgPrice * Double($1.quantity)) }
    }
    
    var totalPNL: Double {
        return currentValue - totalInvestment
    }
    
    var todaysPNL: Double {
        return holdings.reduce(0) { $0 + (($1.close - $1.ltp) * Double($1.quantity)) }
    }
    
    var holdingsCount: Int {
        return holdings.count
    }
    
    func holding(at index: Int) -> Holding {
        return holdings[index]
    }
    
    func fetchHoldings(completion: @escaping (Bool, Error?) -> Void) {
        holdingsService.fetchHoldings { result in
            switch result {
            case .success(let holdings):
                self.setHoldings(holdings)
                completion(true, nil)
            case .failure(let error):
                completion(false, error)
            }
        }
    }
    
    func sortHoldings() {
        holdings.sort { (holding1, holding2) -> Bool in
            let pnl1 = (holding1.ltp - holding1.avgPrice) * Double(holding1.quantity)
            let pnl2 = (holding2.ltp - holding2.avgPrice) * Double(holding2.quantity)
            return pnl1 > pnl2
        }
    }
}
