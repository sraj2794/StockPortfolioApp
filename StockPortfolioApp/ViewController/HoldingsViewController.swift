//
//  HoldingsViewController.swift
//  StockPortfolioApp
//
//  Created by Raj Shekhar on 22/05/24.
//

import UIKit

class HoldingsViewController: UIViewController {
    private var viewModel: HoldingsViewModel!
    private var tableView: UITableView!
    private var summaryView: SummaryView!
    private var isSummaryExpanded = false
    private var summaryViewHeightConstraint: NSLayoutConstraint!
    private let summaryViewCollapsedHeight: CGFloat = 60

    init(viewModel: HoldingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        setupSummaryView()
        fetchHoldings()
    }

    private func setupNavigationBar() {
        navigationItem.title = "Portfolio"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .blue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        let sortButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortHoldings))
        sortButton.tintColor = .white
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchSymbol))
        searchButton.tintColor = .white

        navigationItem.rightBarButtonItems = [sortButton, searchButton]
    }

    @objc private func sortHoldings() {
        viewModel.sortHoldings()
        tableView.reloadData()
    }

    @objc private func searchSymbol() {
        // Implement search functionality if needed
    }

    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HoldingCell.self, forCellReuseIdentifier: HoldingCell.identifier)
        
        // Set bottom inset to account for the collapsed summary view height
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: summaryViewCollapsedHeight, right: 0)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Add a footer view to the table view to ensure last cell is visible above summary view
        let footerView = UIView()
        footerView.frame.size.height = summaryViewCollapsedHeight
        tableView.tableFooterView = footerView
    }

    private func setupSummaryView() {
        summaryView = SummaryView()
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(summaryView)
        
        // Set corner radius
        summaryView.layer.cornerRadius = 16
        summaryView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // Add top border
        let topBorder = CALayer()
        topBorder.backgroundColor = UIColor.lightGray.cgColor
        topBorder.frame = CGRect(x: 0, y: 0, width: summaryView.frame.width, height: 2)
        summaryView.layer.addSublayer(topBorder)
        
        // Add summary view constraints
        NSLayoutConstraint.activate([
            summaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            summaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleSummary))
        summaryView.addGestureRecognizer(tapGesture)
    }

    @objc private func toggleSummary() {
        isSummaryExpanded.toggle()
        summaryView.toggle()
        UIView.animate(withDuration: 0.35) {
            self.view.layoutIfNeeded()
        }
    }

    private func fetchHoldings() {
        viewModel.fetchHoldings { success, error in
            DispatchQueue.main.async {
                if success {
                    self.tableView.reloadData()
                    self.updateSummaryView()
                } else if let error = error {
                    self.handleFetchHoldingsError(error)
                } else {
                    self.handleFetchHoldingsError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Something Went Wrong"]))
                }
            }
        }
    }

    private func handleFetchHoldingsError(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }

    private func updateSummaryView() {
        let currentValue = viewModel.currentValue
        let totalInvestment = viewModel.totalInvestment
        let totalPNL = viewModel.totalPNL
        let todaysPNL = viewModel.todaysPNL
        summaryView.update(currentValue: currentValue, totalInvestment: totalInvestment, totalPNL: totalPNL, todaysPNL: todaysPNL)
    }
}

extension HoldingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.holdingsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HoldingCell.identifier, for: indexPath) as? HoldingCell else {
            return UITableViewCell()
        }
        let holding = viewModel.holding(at: indexPath.row)
        cell.configure(with: holding)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
