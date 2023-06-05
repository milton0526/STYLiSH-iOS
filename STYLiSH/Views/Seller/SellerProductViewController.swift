//
//  SellerProductViewController.swift
//  STYLiSH
//
//  Created by Milton Liu on 2023/6/3.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class SellerProductViewController: STBaseViewController {
    
    
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
    
    lazy var confirmView = UIView()
    lazy var confirmButton = UIButton()

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
        tableView.register(
            UploadProductBasicHeaderView.self,
            forHeaderFooterViewReuseIdentifier: UploadProductBasicHeaderView.identifier)
        tableView.register(UploadProductBasicCell.self, forCellReuseIdentifier: UploadProductBasicCell.identifier)
        return tableView
    }()

    private var sellerProducts: [Product] = []
    
    var uploadBasicData: UploadBasicCellModel?
    var uploadDetailData: UploadDetailCellModel?

    private var specSectionRows = 1

    private var currentSpecIndexPath: IndexPath?
    //private var testColorData: [IndexPath: UIColor?] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = NSLocalizedString("賣家中心")
        setupCloseButton()
        setupConfirmView()
        setupConfirmConstraint()
        setupViews()
    }

    private func setupConfirmView() {
        confirmView.backgroundColor = .white
        confirmView.layer.borderWidth = 0.4
        confirmView.layer.borderColor = UIColor.B2?.cgColor
        confirmView.isHidden = true

        confirmButton.backgroundColor = UIColor(hex: "3F3A3A")
        confirmButton.setAttributedTitle(NSMutableAttributedString(string: "上傳商品", attributes: [NSAttributedString.Key.kern: 2.4]), for: .normal)
        confirmButton.setTitleColor(UIColor(hex: "FFFFFF"), for: .normal)
        confirmButton.titleLabel?.font = UIFont(name: "PingFangTC-Regular", size: 16)
        confirmButton.addTarget(self, action: #selector(uploadProduct), for: .touchUpInside)
        view.addSubview(confirmView)
        confirmView.addSubview(confirmButton)
    }
    
    private func setupConfirmConstraint() {
        [confirmView, confirmButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            confirmView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            confirmView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            confirmView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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
            tableView.bottomAnchor.constraint(equalTo: confirmView.topAnchor)
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
    
    @objc private func uploadProduct() {
        print(uploadBasicData)
        print(uploadDetailData)
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
            confirmView.isHidden = false
            tableView.isHidden = false
        } else {
            collectionView.isHidden = false
            confirmView.isHidden = true
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
        section == 0 ? 2 : specSectionRows
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: UploadProductBasicHeaderView.identifier) as? UploadProductBasicHeaderView
            else {
                return nil
            }
            return headerView
            
        case 1:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: UploadProductSpecHeaderView.identifier) as? UploadProductSpecHeaderView
            else {
                return nil
            }

            headerView.handler = { [weak self] in
                guard let self = self else { return }
                self.specSectionRows += 1
                let indexPath = IndexPath(row: self.specSectionRows - 1, section: 1)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
            return headerView

        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let basicCell = tableView.dequeueReusableCell(
            withIdentifier: UploadProductBasicCell.identifier,
            for: indexPath) as? UploadProductBasicCell
        else {
            fatalError("Failed to dequeue cell.")
        }


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
            if indexPath.row == 0 {
                basicCell.delegate = self
                return basicCell
            }
            detailCell.delegate = self
            return detailCell

        case 1:
            specCell.chooseColorHandler = { [weak self] cell in
                guard let self = self else { return }

                guard let indexPath = self.tableView.indexPath(for: cell) else { return }
                self.currentSpecIndexPath = indexPath
                //self.testColorData.updateValue(nil, forKey: indexPath)

                if #available(iOS 14.0, *) {
                    self.showColorPikerView()
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
        guard
            let indexPath = currentSpecIndexPath,
            let cell = tableView.cellForRow(at: indexPath) as? UploadProductSpecCell
        else {
            return
        }
        // testColorData.updateValue(color, forKey: indexPath)
        cell.colorView.backgroundColor = color
    }
}


extension SellerProductViewController: UploadProductBasicCellDelegate {
    func basicCellData(from cell: UploadProductBasicCell, data: UploadBasicCellModel) {
        // 將
        uploadBasicData = data
        
    }
    
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
//            cell.firstImageForUpload = image
        } else if cell.selectedViewIndex == 1 {
            cell.uploadImageView2.image = image
//            cell.secImageForUpload = image
        } 
        dismiss(animated: true, completion: nil)
    }
}

extension SellerProductViewController: UploadProductDetailCellDelegate {
    func detailCellData(from cell: UploadProductDetailCell, data: UploadDetailCellModel) {
        cell.delegate = self
        uploadDetailData = data
        print(uploadDetailData)
    }
}
