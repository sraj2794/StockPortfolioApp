//
//  HoldingModel.swift
//  StockPortfolioApp
//
//  Created by Raj Shekhar on 22/05/24.
//

import Foundation

struct Holding: Codable {
    let symbol: String
    let quantity: Int
    let ltp: Double
    let avgPrice: Double
    let close: Double

    init?(dictionary: [String: Any]) {
        guard let symbol = dictionary["symbol"] as? String,
              let quantity = dictionary["quantity"] as? Int,
              let ltp = dictionary["ltp"] as? Double,
              let avgPrice = dictionary["avgPrice"] as? Double,
              let close = dictionary["close"] as? Double else {
            return nil
        }

        self.symbol = symbol
        self.quantity = quantity
        self.ltp = ltp
        self.avgPrice = avgPrice
        self.close = close
    }
}

struct HoldingsData: Codable {
    let data: UserHoldings
    
    struct UserHoldings: Codable {
        let userHolding: [Holding]
    }
}
