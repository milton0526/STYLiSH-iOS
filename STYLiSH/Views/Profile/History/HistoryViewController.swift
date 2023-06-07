//
//  HistoryViewController.swift
//  STYLiSH
//
//  Created by Milton Liu on 2023/6/2.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.identifier)
        tableView.register(HistoryHeaderView.self, forHeaderFooterViewReuseIdentifier: HistoryHeaderView.identifier)
        tableView.register(HistoryFooterView.self, forHeaderFooterViewReuseIdentifier: HistoryFooterView.identifier)
        return tableView
    }()

    private let userProvider = UserProvider()
    private var orderRecord: [OrderRecord] = [] {
        didSet { tableView.reloadData() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = NSLocalizedString("購買紀錄")

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        setupBackButton()
        fetchData()
    }

    private func setupBackButton() {
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(
            image: .asset(.Icons_24px_Back02),
            style: .plain, target: self,
            action: #selector(dismissView))
        navigationItem.leftBarButtonItem = backButton
    }

    @objc func dismissView() {
        navigationController?.popViewController(animated: true)
    }

    private func fetchData() {
        userProvider.getUserProfile(completion: { [weak self] result in
            switch result {
            case .success(let user):
                self?.orderRecord = user.orderRecord ?? []
            case .failure:
                LKProgressHUD.showFailure(text: "讀取資料失敗！")
            }
        })
     }

}

// MARK: - Table view delegate
extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        110
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: HistoryHeaderView.identifier) as? HistoryHeaderView
        else {
            return nil
        }
        let orderID = orderRecord[section].number
        headerView.titleLabel.text = "訂單編號: \(orderID)"
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: HistoryFooterView.identifier) as? HistoryFooterView
        else {
            return nil
        }
        let total = orderRecord[section].total
        footerView.priceLabel.text = "$ \(total)"
        return footerView
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        50
    }

    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        50
    }
}

// MARK: - Table view dataSource
extension HistoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        orderRecord.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderRecord[section].products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath) as? HistoryTableViewCell else {
            fatalError("Failed to dequeue cell.")
        }

        let product = orderRecord[indexPath.section].products[indexPath.row]
        cell.configure(with: product)
        return cell
    }
}
