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
        let collectionView = UICollectionView()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.lk_registerCellWithNib(
            identifier: String(describing: ProductCollectionViewCell.self),
            bundle: nil
        )
        return collectionView
    }()

    private var sellerProducts: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("賣家中心")
        setupCloseButton()
        setupViews()

    }

    private func setupViews() {
        view.addSubview(selectionView)
        view.addSubview(collectionView)
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            selectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            selectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            selectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: selectionView.bottomAnchor, constant: 6),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
    func didSelectedButton(_ selectionView: SelectionView, at index: Int) {
        // Change view base on index
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
