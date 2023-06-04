//
//  SellerProductViewController.swift
//  STYLiSH
//
//  Created by Milton Liu on 2023/6/3.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class SellerProductViewController: UIViewController {

    lazy var selectionView: SelectionView = {
        let selectionView = SelectionView()
        selectionView.dataSource = self
        selectionView.delegate = self
        return selectionView
    }()

    let buttonTitles = [NSLocalizedString("我的商品"), NSLocalizedString("我要上架")]

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.lk_registerCellWithNib(
            identifier: String(describing: ProductCollectionViewCell.self),
            bundle: nil
        )
        return collectionView
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.register(
            UINib(nibName: String(describing: UploadProductDetailCell.self), bundle: nil),
            forCellReuseIdentifier: UploadProductDetailCell.identifier)
        tableView.register(
            UINib(nibName: String(describing: UploadProductSpecCell.self), bundle: nil),
            forCellReuseIdentifier: UploadProductSpecCell.identifier)
        tableView.register(
            UploadProductSpecHeaderView.self,
            forHeaderFooterViewReuseIdentifier: UploadProductSpecHeaderView.identifier)
        return tableView
    }()

    private var sellerProducts: [Product] = []

    private var specSectionRows = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = NSLocalizedString("賣家中心")
        setupCloseButton()
        setupViews()

    }

    private func setupViews() {
        view.addSubview(selectionView)
        view.addSubview(collectionView)
        view.addSubview(tableView)
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            selectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            selectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            selectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: selectionView.bottomAnchor, constant: 6),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            tableView.topAnchor.constraint(equalTo: selectionView.bottomAnchor, constant: 6),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupCloseButton() {
        let closeButton = UIBarButtonItem(
            image: .asset(.Icons_24px_Close),
            style: .plain,
            target: self,
            action: #selector(didClickCloseButton))
        navigationItem.rightBarButtonItem = closeButton
    }

    @objc private func didClickCloseButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    @available(iOS 14.0, *)
    private func showColorPikerView() {
        let colorPickerView = UIColorPickerViewController()
        colorPickerView.supportsAlpha = false
        colorPickerView.delegate = self
        present(colorPickerView, animated: true)
    }
}

// MARK: - Selection view dataSource
extension SellerProductViewController: SelectionViewDataSource {
    func numberOfButtons(_ selectionView: SelectionView) -> Int {
        buttonTitles.count
    }

    func selectionView(_ selectionView: SelectionView, titleForButtonAt index: Int) -> String? {
        buttonTitles[index]
    }
}

// MARK: - Selection view delegate
extension SellerProductViewController: SelectionViewDelegate {
    func shouldSelectedButton(_ selectionView: SelectionView, at index: Int) -> Bool {
        return true
    }

    func didSelectedButton(_ selectionView: SelectionView, at index: Int) {
        if index == 1 {
            collectionView.isHidden = true
            tableView.isHidden = false
        } else {
            collectionView.isHidden = false
            tableView.isHidden = true
        }
    }
}

// MARK: - Collection view delegate
extension SellerProductViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24.0, left: 16.0, bottom: 24.0, right: 16.0)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        24
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: Int(164.0 / 375.0 * UIScreen.width) ,
            height: Int(164.0 / 375.0 * UIScreen.width * 308.0 / 164.0)
        )
    }
}

// MARK: - Collection view dataSource
extension SellerProductViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ProductCollectionViewCell.self),
            for: indexPath) as? ProductCollectionViewCell
            else {
            fatalError("Failed to dequeue cell.")
        }

        //cell.layoutCell(image: <#T##String#>, title: <#T##String#>, price: <#T##Int#>)
        return cell
    }
}

// MARK: - UITable view dataSource
extension SellerProductViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : specSectionRows
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        case 1:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: UploadProductSpecHeaderView.identifier) as? UploadProductSpecHeaderView
            else {
                return nil
            }

            headerView.handler = { [weak self] in
                self?.specSectionRows += 1
                let totalRows = tableView.numberOfRows(inSection: 1)
                let indexPath = IndexPath(row: totalRows, section: 1)
                self?.tableView.insertRows(at: [indexPath], with: .bottom)
            }
            return headerView

        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let detailCell = tableView.dequeueReusableCell(
            withIdentifier: UploadProductDetailCell.identifier,
            for: indexPath) as? UploadProductDetailCell
        else {
            fatalError("Failed to dequeue cell.")
        }

        guard let specCell = tableView.dequeueReusableCell(
            withIdentifier: UploadProductSpecCell.identifier,
            for: indexPath) as? UploadProductSpecCell
        else {
            fatalError("Failed to dequeue cell.")
        }

        switch indexPath.section {
        case 0:
            return detailCell
        case 1:
            specCell.chooseColorHandler = { [weak self] in
                if #available(iOS 14.0, *) {
                    self?.showColorPikerView()
                } else {
                    // Fallback on earlier versions
                }
            }
            return specCell
        default:
            return UITableViewCell()
        }

    }
}

// MARK: UITable view delegate
extension SellerProductViewController: UITableViewDelegate {

}

// MARK: - ColorPickerView Delegate
extension SellerProductViewController: UIColorPickerViewControllerDelegate {
    @available(iOS 14.0, *)
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        NotificationCenter.default.post(name: .updateColorView, object: color)
    }
}
