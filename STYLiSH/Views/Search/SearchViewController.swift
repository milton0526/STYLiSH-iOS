//
//  SearchViewController.swift
//  STYLiSH
//
//  Created by Milton Liu on 2023/6/7.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

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

    lazy var indicatorView: UILabel = {
        let label = UILabel()
        label.text = "無相關搜尋結果"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .B2
        label.isHidden = false
        return label
    }()

    private let searchController = UISearchController(searchResultsController: nil)

    private var searchProducts: [Product] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.indicatorView.isHidden = !self.searchProducts.isEmpty
                self.collectionView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.addSubview(indicatorView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("找找你有興趣的服飾")
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true

    }

    private func fetchSearchResults(_ searchText: String) {
        let baseURL = Bundle.STValueForString(key: STConstant.urlKey)

        guard
            let urlString = "\(baseURL)/products/search?keyword=\(searchText)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlString)
        else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard
                let self = self,
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200
            else {
                return
            }

            do {
                let result = try JSONDecoder().decode(STSuccessParser<[Product]>.self, from: data)
                self.searchProducts = result.data
                print(self.searchProducts)
            } catch {
                print("Decode error.")
            }
        }

        task.resume()

    }
}

// MARK: - Search result update
extension SearchViewController: UISearchControllerDelegate {
    func willDismissSearchController(_ searchController: UISearchController) {
        searchProducts.removeAll()
    }
}

// MARK: - Search result Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard
            let searchText = searchBar.text,
            !searchText.isEmpty
        else {
            searchProducts.removeAll()
            return
        }

        fetchSearchResults(searchText)
    }
}

// MARK: - Collection view data source
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchProducts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ProductCollectionViewCell.self),
            for: indexPath) as? ProductCollectionViewCell
        else {
            fatalError("Failed to dequeue cell.")
        }

        let product = searchProducts[indexPath.item]
        cell.layoutCell(image: product.mainImage, title: product.title, price: product.price)
        return cell
    }
}


// MARK: - Collection view delegate
extension SearchViewController: UICollectionViewDelegateFlowLayout {
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let detailVC = UIStoryboard.product.instantiateViewController(
                withIdentifier: String(describing: ProductDetailViewController.self)
            ) as? ProductDetailViewController
        else {
            return
        }

        detailVC.product = searchProducts[indexPath.item]
        show(detailVC, sender: nil)
    }
}

