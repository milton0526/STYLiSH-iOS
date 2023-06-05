//
//  SellerProductViewController.swift
//  STYLiSH
//
//  Created by Milton Liu on 2023/6/3.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class SellerProductViewController: UIViewController {

//    lazy var selectionView: SelectionView = {
//        let selectionView = SelectionView()
//        selectionView.dataSource = self
//        selectionView.delegate = self
//        return selectionView
//    }()

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
    
//    lazy var tableView: UITableView = {
//        let tableView = UITableView(frame: .zero, style: .grouped)
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.isHidden = true
//        tableView.lk_registerCellWithNib(
//            identifier: String(describing: FirstUploadCell.self),
//            bundle: nil
//        )
//        tableView.register(UploadProductBasicCell.self, forCellReuseIdentifier: "UploadProductBasicCell")
//        return tableView
//    }()
    
    lazy var confirmView = UIView()
    lazy var confirmButton = UIButton()

    private var sellerProducts: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = NSLocalizedString("賣家中心")
        setupCloseButton()
        setupViews()
//        setupConfirmView()
        setupConfirmConstraint()
    }

//    private func setupConfirmView() {
//        confirmView.backgroundColor = .white
//        confirmView.layer.borderWidth = 0.4
//        confirmView.layer.borderColor = UIColor.B2?.cgColor
//        confirmView.isHidden = true
//
//        confirmButton.backgroundColor = UIColor(hex: "3F3A3A")
//        confirmButton.setAttributedTitle(NSMutableAttributedString(string: "上傳商品", attributes: [NSAttributedString.Key.kern: 2.4]), for: .normal)
//        confirmButton.setTitleColor(UIColor(hex: "FFFFFF"), for: .normal)
//        confirmButton.titleLabel?.font = UIFont(name: "PingFangTC-Regular", size: 16)
//        view.addSubview(confirmView)
//        confirmView.addSubview(confirmButton)
//    }
    
    private func setupConfirmConstraint() {
        [confirmView, confirmButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            confirmView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            confirmView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            confirmView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            confirmView.heightAnchor.constraint(equalToConstant: 100),
            
            confirmButton.topAnchor.constraint(equalTo: confirmView.topAnchor, constant: 16),
            confirmButton.leadingAnchor.constraint(equalTo: confirmView.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: confirmView.trailingAnchor, constant: -16),
            confirmButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        
    }
    
    private func setupViews() {
        view.addSubview(selectionView)
        view.addSubview(collectionView)
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
//        view.addSubview(tableView)
//        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            selectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            selectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            selectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: selectionView.bottomAnchor, constant: 6),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
//            tableView.topAnchor.constraint(equalTo: selectionView.bottomAnchor, constant: 6),
//            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -28)
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

//// MARK: - Selection view delegate
//extension SellerProductViewController: SelectionViewDelegate {
//    func shouldSelectedButton(_ selectionView: SelectionView, at index: Int) -> Bool {
//        return true
//    }
//
//    func didSelectedButton(_ selectionView: SelectionView, at index: Int) {
//        if index == 1 {
//            collectionView.isHidden = true
//            tableView.isHidden = false
//            confirmView.isHidden = false
//        } else {
//            tableView.isHidden = true
//            collectionView.isHidden = false
//            confirmView.isHidden = true
//        }
//    }
//}

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

//extension SellerProductViewController: UITableViewDelegate {
//    func numberOfSections(in tableView: UITableView) -> Int {
//      1
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//      25
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
//        let label = UILabel()
//
//        label.frame = CGRect.init(x: 16, y: 8, width: headerView.frame.width, height: headerView.frame.height)
//        label.backgroundColor = .white
//
//        label.textColor = UIColor(hex: "3F3A3A")
//        label.font = UIFont(name: "PingFangTC-Medium", size: 18)
//        if section == 0 {
//            label.text = "商品資訊"
//        } else {
//            label.text = "商品規格"
//        }
//
//        headerView.addSubview(label)
//        headerView.backgroundColor = UIColor.white
//
//        return headerView
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        tableView.separatorStyle = .none
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UploadProductBasicCell", for: indexPath) as? UploadProductBasicCell else { fatalError("Could not create TableViewCell") }
//        cell.delegate = self
//
//        return cell
//    }
//}

//extension SellerProductViewController: UITableViewDataSource {
//}

extension SellerProductViewController: UploadProductBasicCellDelegate {
    func presentAlert(from cell: UploadProductBasicCell) {
        let alert = UIAlertController(title: "選擇照片來源", message: .empty, preferredStyle: .actionSheet)
        
        let dismissAlert = UIAlertAction(title: "關閉", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        
        let galleryAction = UIAlertAction(title: "從相簿選擇", style: .default) { _ in
            cell.selectPhoto()
        }
        
        let cameraAction = UIAlertAction(title: "開啟相機", style: .default) { _ in
             cell.showCamera()
        }
        
        alert.addAction(dismissAlert)
        alert.addAction(galleryAction)
        alert.addAction(cameraAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func presentImagePicker(from cell: UploadProductBasicCell) {
        let picController = UIImagePickerController()
        picController.sourceType = .photoLibrary
        picController.delegate = cell
        present(picController, animated: true, completion: nil)
    }
    
    func presentCamera(from cell: UploadProductBasicCell) {
        let picController = UIImagePickerController()
        picController.sourceType = .camera
        picController.delegate = cell
        present(picController, animated: true, completion: nil)
    }
    
    func showImage(from cell: UploadProductBasicCell, image: UIImage) {
        if cell.selectedViewIndex == 0 {
            cell.uploadImageView1.image = image
        } else if cell.selectedViewIndex == 1 {
            cell.uploadImageView2.image = image
        } else if cell.selectedViewIndex == 2 {
            cell.uploadImageView3.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
