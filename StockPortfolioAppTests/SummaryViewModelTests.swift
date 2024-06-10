//
//  SummaryViewModelTests.swift
//  StockPortfolioAppTests
//
//  Created by Raj Shekhar on 24/05/24.
//

import XCTest
@testable import StockPortfolioApp

class SummaryViewModelTests: XCTestCase {
    
    var viewModel: SummaryViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = SummaryViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testInitialValues() {
        XCTAssertEqual(viewModel.currentValueText, "₹0.00", "Initial current value should be ₹0.00")
        XCTAssertEqual(viewModel.totalInvestmentText, "₹0.00", "Initial total investment should be ₹0.00")
        XCTAssertEqual(viewModel.totalPNLText, "₹0.00 (0.00%)", "Initial total PNL should be ₹0.00 (0.00%)")
        XCTAssertEqual(viewModel.todaysPNLText, "₹0.00", "Initial today's PNL should be ₹0.00")
        XCTAssertEqual(viewModel.todaysPNLColor, .green, "Initial today's PNL color should be green")
        XCTAssertEqual(viewModel.totalPNLColor, .green, "Initial total PNL color should be green")
    }

    func testUpdateValues() {
        viewModel.update(currentValue: 1000, totalInvestment: 800, totalPNL: 200, todaysPNL: -50)
        
        XCTAssertEqual(viewModel.currentValueText, "₹1000.00", "Current value should be ₹1000.00")
        XCTAssertEqual(viewModel.totalInvestmentText, "₹800.00", "Total investment should be ₹800.00")
        XCTAssertEqual(viewModel.totalPNLText, "₹200.00 (25.00%)", "Total PNL should be ₹200.00 (25.00%)")
        XCTAssertEqual(viewModel.todaysPNLText, "₹-50.00", "Today's PNL should be ₹-50.00")
        XCTAssertEqual(viewModel.todaysPNLColor, .red, "Today's PNL color should be red")
        XCTAssertEqual(viewModel.totalPNLColor, .green, "Total PNL color should be green")
    }
    
    func testNegativeTotalPNL() {
        viewModel.update(currentValue: 1000, totalInvestment: 1200, totalPNL: -200, todaysPNL: 50)
        
        XCTAssertEqual(viewModel.currentValueText, "₹1000.00", "Current value should be ₹1000.00")
        XCTAssertEqual(viewModel.totalInvestmentText, "₹1200.00", "Total investment should be ₹1200.00")
        XCTAssertEqual(viewModel.totalPNLText, "₹-200.00 (-16.67%)", "Total PNL should be ₹-200.00 (-16.67%)")
        XCTAssertEqual(viewModel.todaysPNLText, "₹50.00", "Today's PNL should be ₹50.00")
        XCTAssertEqual(viewModel.todaysPNLColor, .green, "Today's PNL color should be green")
        XCTAssertEqual(viewModel.totalPNLColor, .red, "Total PNL color should be red")
    }
    
    func testZeroTotalInvestment() {
        viewModel.update(currentValue: 1000, totalInvestment: 0, totalPNL: 200, todaysPNL: 50)
        
        XCTAssertEqual(viewModel.currentValueText, "₹1000.00", "Current value should be ₹1000.00")
        XCTAssertEqual(viewModel.totalInvestmentText, "₹0.00", "Total investment should be ₹0.00")
        XCTAssertEqual(viewModel.totalPNLText, "₹200.00 (0.00%)", "Total PNL should be ₹200.00 (0.00%)")
        XCTAssertEqual(viewModel.todaysPNLText, "₹50.00", "Today's PNL should be ₹50.00")
        XCTAssertEqual(viewModel.todaysPNLColor, .green, "Today's PNL color should be green")
        XCTAssertEqual(viewModel.totalPNLColor, .green, "Total PNL color should be green")
    }
}
