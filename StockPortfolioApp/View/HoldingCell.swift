//
//  HoldingCell.swift
//  StockPortfolioApp
//
//  Created by Raj Shekhar on 22/05/24.
//

import UIKit

class HoldingCell: UITableViewCell {
    static let identifier = "HoldingCell"
    
    private let symbolLabel = UILabel()
    private let quantityLabel = UILabel()
    private let ltpLabel = UILabel()
    private let pnlLabel = UILabel()
    
    private let leftStackView = UIStackView()
    private let rightStackView = UIStackView()
    private let mainStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupLabels()
        setupStackViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabels() {
        symbolLabel.font = UIFont.boldSystemFont(ofSize: 16)
        quantityLabel.font = UIFont.systemFont(ofSize: 10)
        ltpLabel.font = UIFont.systemFont(ofSize: 10)
        pnlLabel.font = UIFont.systemFont(ofSize: 10)
        
        [symbolLabel, quantityLabel, ltpLabel, pnlLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupStackViews() {
        leftStackView.axis = .vertical
        leftStackView.alignment = .leading
        leftStackView.distribution = .equalSpacing
        leftStackView.spacing = 20
        
        rightStackView.axis = .vertical
        rightStackView.alignment = .trailing
        rightStackView.distribution = .equalSpacing
        rightStackView.spacing = 20
        
        mainStackView.axis = .horizontal
        mainStackView.alignment = .center
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 16
        
        leftStackView.addArrangedSubview(symbolLabel)
        leftStackView.addArrangedSubview(quantityLabel)
        
        rightStackView.addArrangedSubview(ltpLabel)
        rightStackView.addArrangedSubview(pnlLabel)
        
        mainStackView.addArrangedSubview(leftStackView)
        mainStackView.addArrangedSubview(rightStackView)
        
        contentView.addSubview(mainStackView)
    }
    
    private func setupConstraints() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with holding: Holding) {
        symbolLabel.text = holding.symbol
        quantityLabel.text = "NET QTY: \(holding.quantity)"
        ltpLabel.text = "LTP: ₹\(String(format: "%.2f", holding.ltp))"
        
        let pnl = (holding.ltp - holding.avgPrice) * Double(holding.quantity)
        let pnlText = String(format: "₹%.2f", pnl)
        let fullPnlText = "P&L: \(pnlText)"
        
        let attributedText = NSMutableAttributedString(string: fullPnlText)
        let pnlColor: UIColor = pnl >= 0 ? .green : .red
        if let pnlRange = fullPnlText.range(of: pnlText) {
            let nsRange = NSRange(pnlRange, in: fullPnlText)
            attributedText.addAttribute(.foregroundColor, value: pnlColor, range: nsRange)
        }
        
        pnlLabel.attributedText = attributedText
    }
}
