//
//  SummaryViewModel.swift
//  StockPortfolioApp
//
//  Created by Raj Shekhar on 24/05/24.
//

import UIKit

class SummaryViewModel {
    private var currentValue: Double = 0.0
    private var totalInvestment: Double = 0.0
    private var totalPNL: Double = 0.0
    private var todaysPNL: Double = 0.0

    var currentValueText: String {
        return formatCurrency(currentValue)
    }

    var totalInvestmentText: String {
        return formatCurrency(totalInvestment)
    }

    var totalPNLText: String {
        let percentage = totalInvestment != 0 ? (totalPNL / totalInvestment * 100) : 0
        return "\(formatCurrency(totalPNL)) (\(String(format: "%.2f", percentage))%)"
    }

    var todaysPNLText: String {
        return formatCurrency(todaysPNL)
    }

    var todaysPNLColor: UIColor {
        return todaysPNL >= 0 ? .green : .red
    }

    var totalPNLColor: UIColor {
        return totalPNL >= 0 ? .green : .red
    }

    func update(currentValue: Double, totalInvestment: Double, totalPNL: Double, todaysPNL: Double) {
        self.currentValue = currentValue
        self.totalInvestment = totalInvestment
        self.totalPNL = totalPNL
        self.todaysPNL = todaysPNL
    }

    private func formatCurrency(_ value: Double) -> String {
        return "₹\(String(format: "%.2f", value))"
    }
}
