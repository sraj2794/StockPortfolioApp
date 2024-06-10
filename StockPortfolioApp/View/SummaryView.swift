//
//  SummaryView.swift
//  StockPortfolioApp
//
//  Created by Raj Shekhar on 22/05/24.
//

import UIKit

class SummaryView: UIView {
    private let currentValueLabel = UILabel()
    private let totalInvestmentLabel = UILabel()
    private let todaysPnlLabel = UILabel()
    private let totalPnlLabel = UILabel()
    
    private let currentValueValue = UILabel()
    private let totalInvestmentValue = UILabel()
    private let todaysPnlValue = UILabel()
    private let totalPnlValue = UILabel()
    
    private let separatorView = UIView()
    private let stackView = UIStackView()
    private let totalPnlStackView = UIStackView()
    private let toggleButton = UIButton()
    
    private var isExpanded = true
    private let viewModel = SummaryViewModel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupToggleButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0) // Light gray background

        // Set text, font, and color for all labels
        setupLabel(currentValueLabel, text: "Current value*")
        setupLabel(totalInvestmentLabel, text: "Total investment*")
        setupLabel(todaysPnlLabel, text: "Today's Profit & Loss*")
        setupLabel(totalPnlLabel, text: "Profit & Loss*")
        
        setupLabel(currentValueValue)
        setupLabel(totalInvestmentValue)
        setupLabel(todaysPnlValue)
        setupLabel(totalPnlValue)
        
        separatorView.backgroundColor = .lightGray
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 20 // Reduced spacing
        
        totalPnlStackView.axis = .horizontal
        totalPnlStackView.alignment = .center
        totalPnlStackView.distribution = .fill
        totalPnlStackView.spacing = 6 // Reduced spacing

        totalPnlStackView.addArrangedSubview(totalPnlLabel)
        totalPnlStackView.addArrangedSubview(toggleButton)
        totalPnlStackView.addArrangedSubview(UIView()) // Spacer to push totalPnlValue to the right
        totalPnlStackView.addArrangedSubview(totalPnlValue)

        let currentValueStack = createHorizontalStackView(leftLabel: currentValueLabel, rightLabel: currentValueValue)
        let totalInvestmentStack = createHorizontalStackView(leftLabel: totalInvestmentLabel, rightLabel: totalInvestmentValue)
        let todaysPnlStack = createHorizontalStackView(leftLabel: todaysPnlLabel, rightLabel: todaysPnlValue)
        
        [currentValueStack, totalInvestmentStack, todaysPnlStack, separatorView, totalPnlStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        addSubview(stackView)
    }
    
    private func setupLabel(_ label: UILabel, text: String? = nil) {
        if let text = text {
            label.text = text
        }
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        totalPnlValue.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            separatorView.heightAnchor.constraint(equalToConstant: 0.8),
            
            toggleButton.widthAnchor.constraint(equalToConstant: 24),
            toggleButton.heightAnchor.constraint(equalToConstant: 24),
            
            totalPnlValue.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }
    
    private func setupToggleButton() {
        toggleButton.setTitle("▼", for: .normal)
        toggleButton.setTitleColor(.black, for: .normal)
        toggleButton.addTarget(self, action: #selector(toggle), for: .touchUpInside)
    }
    
    @objc func toggle() {
        isExpanded.toggle()
        toggleButton.setTitle(isExpanded ? "▼" : "▲", for: .normal)
        stackView.arrangedSubviews.forEach { view in
            view.isHidden = !isExpanded && view !== totalPnlStackView
        }
        updateHeight()
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    private func createHorizontalStackView(leftLabel: UILabel, rightLabel: UILabel) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 8 // Reduced spacing
        
        leftLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        rightLabel.textAlignment = .right
        
        stackView.addArrangedSubview(leftLabel)
        stackView.addArrangedSubview(rightLabel)
        
        return stackView
    }
    
    func update(currentValue: Double, totalInvestment: Double, totalPNL: Double, todaysPNL: Double) {
        viewModel.update(currentValue: currentValue, totalInvestment: totalInvestment, totalPNL: totalPNL, todaysPNL: todaysPNL)
        
        currentValueValue.text = viewModel.currentValueText
        totalInvestmentValue.text = viewModel.totalInvestmentText
        todaysPnlValue.text = viewModel.todaysPNLText
        totalPnlValue.text = viewModel.totalPNLText
        
        todaysPnlValue.textColor = viewModel.todaysPNLColor
        totalPnlValue.textColor = viewModel.totalPNLColor
    }
    
    private func updateHeight() {
        let newHeight: CGFloat = isExpanded ? 180 : 60
        if let heightConstraint = constraints.first(where: { $0.firstAttribute == .height }) {
            heightConstraint.constant = newHeight
        }
    }
}
