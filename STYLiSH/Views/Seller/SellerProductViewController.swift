//
//  SellerProductViewController.swift
//  STYLiSH
//
//  Created by Milton Liu on 2023/6/3.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit
import Alamofire

class SellerProductViewController: STBaseViewController {

    lazy var indicatorView: UILabel = {
            let label = UILabel()
            label.text = "無上架商品"
            label.font = .systemFont(ofSize: 16, weight: .medium)
            label.textColor = .B2
            label.isHidden = true
            return label
        }()
    
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
    
    private var sellerProducts: [Product] = [] {
        didSet {
            DispatchQueue.main.async {
                self.indicatorView.isHidden = !self.sellerProducts.isEmpty
                self.collectionView.reloadData()
            }
        }
    }
    
    var uploadBasicData: UploadBasicCellModel?
    var uploadDetailData: UploadDetailCellModel?
    
    private var specSectionRows = 1
    
    private var currentSpecIndexPath: IndexPath?
    
    private var variants: [IndexPath: Variant] = [:] {
        didSet {
            print(variants)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = NSLocalizedString("我的賣場")
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
        
        collectionView.addSubview(indicatorView)
    }
    
    private func setupConfirmConstraint() {
        [confirmView, confirmButton, indicatorView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            confirmView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            confirmView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            confirmView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            confirmView.heightAnchor.constraint(equalToConstant: 100),
            
            confirmButton.topAnchor.constraint(equalTo: confirmView.topAnchor, constant: 16),
            confirmButton.leadingAnchor.constraint(equalTo: confirmView.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: confirmView.trailingAnchor, constant: -16),
            confirmButton.heightAnchor.constraint(equalToConstant: 56),
            
            indicatorView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
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

        fetchAllSellerProduct()
    }
    
    private func setupCloseButton() {
        let closeButton = UIBarButtonItem(
            image: .asset(.Icons_24px_Close),
            style: .plain,
            target: self,
            action: #selector(didClickCloseButton))
        navigationItem.rightBarButtonItem = closeButton
    }

    private func fetchAllSellerProduct() {
        let baseURL = Bundle.STValueForString(key: STConstant.urlKey)
        guard
            let url = URL(string: "\(baseURL)/products/seller"),
            let token = KeyChainManager.shared.token
        else {
            return
        }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard
                let self = self,
                error == nil,
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200
            else {
                return
            }

            do {
                let result = try JSONDecoder().decode(STSuccessParser<[Product]>.self, from: data)
                self.sellerProducts = result.data

            } catch {
                print("Decode error")
                print(error.localizedDescription)
            }
        }

        task.resume()
    }
    
    @objc private func didClickCloseButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "離開我的賣場", message: .empty, preferredStyle: .alert)
        
        let dismissAlert = UIAlertAction(title: "返回", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        
        let cameraAction = UIAlertAction(title: "確定", style: .default) { _ in
            self.dismiss(animated: true)
        }
        
        alert.addAction(dismissAlert)
        alert.addAction(cameraAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @available(iOS 14.0, *)
    private func showColorPikerView() {
        let colorPickerView = UIColorPickerViewController()
        colorPickerView.supportsAlpha = false
        colorPickerView.delegate = self
        present(colorPickerView, animated: true)
    }
    
    @objc private func uploadProduct() {

        if specSectionRows != 0 && uploadBasicData != nil && uploadDetailData != nil && variants.isEmpty != true {
            var responseFromServer = 0
            confirmButton.isUserInteractionEnabled = false
            confirmButton.backgroundColor = UIColor(hex: "7D7676")
            let baseURL = Bundle.STValueForString(key: STConstant.urlKey)
            guard let url = URL(string: "\(baseURL)/product") else {
                return
            }
            let dicCount = variants.count
            let colorCodes = variants.map { $0.value.colorCode }
            let sizes = variants.map { $0.value.size }
            let stocksInt = variants.map { $0.value.stock }
            let stocksString = stocksInt.map { String($0) }
            
            guard let uploadBasicData = uploadBasicData,
                  let uploadDetailData = uploadDetailData
            else {
                return
            }
            
            let temporaryToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjI0LCJpYXQiOjE2ODYwMjk5NDUsImV4cCI6MTY4NjM3NTU0NX0.WzJWe4MifkQCFGQLqf0uEUobWq1i8MToajL4bWlgpBU"
            
            let stringParameter: [String: String] = [
                "title" : uploadBasicData.productTitle,
                "price": uploadDetailData.price,
                "category": uploadBasicData.categoryButton,
                "description": uploadBasicData.productDescription,
                "story": uploadBasicData.productDescription,
                "texture": uploadDetailData.texture,
                "wash": uploadDetailData.wash,
                "place": uploadDetailData.contry,
                "note": "實品顏色依單品照為主",
            ]
            
            let stringArrayParameter: [String: [String]] = [
                "size": sizes,
                "stock": stocksString,
                "color": colorCodes,
                "colorName": colorCodes
            ]
            
            
            let headers: HTTPHeaders = ["Authorization": KeyChainManager.shared.token ?? temporaryToken]
            
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(uploadBasicData.images.image1, withName: "main_image", fileName: "image.jpg", mimeType: "image/jpeg")
                multipartFormData.append(uploadBasicData.images.image1, withName: "images", fileName: "image.jpg", mimeType: "image/jpeg")
                multipartFormData.append(uploadBasicData.images.image2, withName: "images", fileName: "image.jpg", mimeType: "image/jpeg")
                for (key, value) in stringParameter {
                    multipartFormData.append(Data(value.utf8), withName: key)
                }

                for (key, value) in stringArrayParameter {
                    for index in value.indices {
                        multipartFormData.append(Data(value[index].utf8), withName: key)
                    }
                }
            }, to: url, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success(let value):
                    print("Image uploaded successfully: \(value)")
                    responseFromServer = response.response!.statusCode
                    if responseFromServer == 200 {
                        self.confirmButton.isUserInteractionEnabled = true
                        self.confirmButton.backgroundColor = UIColor(hex: "3F3A3A")
                    }
                    
                    self.uploadBasicData = nil
                    self.uploadDetailData = nil
                    self.variants.removeAll()
                    self.tableView.reloadData()
                    
                    let alert = UIAlertController(title: "商品上架成功", message: nil, preferredStyle: .alert)
                    let confirmAction = UIAlertAction(title: "確定", style: .cancel) { _ in
                        alert.dismiss(animated: true)
                    }
                    alert.addAction(confirmAction)
                    self.present(alert, animated: true, completion: nil)
                    
                    print(responseFromServer)
                case .failure(let error):
                    let alert = UIAlertController(title: "商品上架失敗，請再試一遍", message: nil, preferredStyle: .alert)
                    let confirmAction = UIAlertAction(title: "確定", style: .cancel) { _ in
                        alert.dismiss(animated: true)
                    }
                    alert.addAction(confirmAction)
                    self.present(alert, animated: true, completion: nil)
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 400..<500:
                            print("Client error: \(statusCode)")
                            // Handle client-side errors (4xx)
                        case 500..<600:
                            print("Server error: \(statusCode)")
                            print(response)
                            // Handle server-side errors (5xx)
                        default:
                            print("Unexpected status code: \(statusCode)")
                        }
                    } else {
                        print("Image upload failed: \(error)")
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "注意", message: "您仍有欄位尚未填寫", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "確定", style: .cancel) { _ in
                alert.dismiss(animated: true)
            }
            
            alert.addAction(confirmAction)
            
            present(alert, animated: true, completion: nil)
        }
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
            indicatorView.isHidden = !sellerProducts.isEmpty
        } else {
            fetchAllSellerProduct()
            collectionView.isHidden = false
            confirmView.isHidden = true
            tableView.isHidden = true
            indicatorView.isHidden = true
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let detailVC = UIStoryboard.product.instantiateViewController(
                withIdentifier: String(describing: ProductDetailViewController.self)
            ) as? ProductDetailViewController
        else {
            return
        }
        detailVC.product = sellerProducts[indexPath.item]
        show(detailVC, sender: nil)
    }
}

// MARK: - Collection view dataSource
extension SellerProductViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sellerProducts.count
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
            
            
            cell.delegate = self
            
            cell.deletionButton()
            
            let product = sellerProducts[indexPath.item]

            cell.layoutCell(image: product.mainImage, title: product.title, price: product.price)

            return cell
        }
}

// MARK: - Product deletion delegate
extension SellerProductViewController: ProductCollectionViewCellDelegate {
    func buttonPressed(from cell: ProductCollectionViewCell) {
        
        let alert = UIAlertController(title: "刪除商品", message: .empty, preferredStyle: .alert)
        
        let dismissAlert = UIAlertAction(title: "返回", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        
        let cameraAction = UIAlertAction(title: "確定", style: .default) { _ in
            alert.dismiss(animated: true)

            
            struct DeleteResponse: Codable {
                let success: Bool
            }
            
            guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
            let baseURL = Bundle.STValueForString(key: STConstant.urlKey)
            
            guard let url = URL(string: "\(baseURL)/product") else {
                return
            }
            
            let headers: HTTPHeaders = ["Authorization": KeyChainManager.shared.token ?? ""]
            
            let parameters: [String: Any] = [
                "productId": self.sellerProducts[indexPath.row].id
            ]
            
            AF.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .response { response in
                    switch response.result {
                    case .success(let deleteResponse):
                        print("Product deletion successful. Success: \(deleteResponse)")
                        self.fetchAllSellerProduct()
                        let alert = UIAlertController(title: "商品已刪除", message: nil, preferredStyle: .alert)
                        let confirmAction = UIAlertAction(title: "確定", style: .cancel) { _ in
                            alert.dismiss(animated: true)
                        }
                        alert.addAction(confirmAction)
                        self.present(alert, animated: true, completion: nil)
                    case .failure(let error):
                        print("Product deletion failed: \(error)")
                        print(response)
                        print(self.sellerProducts[indexPath.row].id)
                        print("Token: \(KeyChainManager.shared.token)")
                        if let statusCode = response.response?.statusCode {
                            switch statusCode {
                            case 400..<500:
                                print("Client error: \(statusCode)")
                                // Handle client-side errors (4xx)
                            case 500..<600:
                                print("Server error: \(statusCode)")
                                // Handle server-side errors (5xx)
                            default:
                                print("Unexpected status code: \(statusCode)")
                            }
                        } else {
                            print("Image upload failed: \(error)")
                    }
                }
            }
        }
        
        alert.addAction(dismissAlert)
        alert.addAction(cameraAction)
        
        present(alert, animated: true, completion: nil)
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
                basicCell.uploadImageView1.image = UIImage.asset(.Image_Placeholder)
                basicCell.uploadImageView2.image = UIImage.asset(.Image_Placeholder)
                basicCell.productTitleTextField.text = ""
                basicCell.productDescriptionTextField.text = ""
                return basicCell
            }
            detailCell.delegate = self
            return detailCell
            
        case 1:
            specCell.delegate = self
            return specCell
        default:
            return UITableViewCell()
        }
        
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch indexPath.section {
        case 1:
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completionHandler) in
                // delete the item here
                self?.specSectionRows -= 1
                self?.variants.removeValue(forKey: indexPath)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                completionHandler(true)
            }
            deleteAction.image = UIImage(systemName: "trash")
            deleteAction.backgroundColor = .systemRed
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
        default:
            return nil
        }
    }

}

// MARK: - Spec cell Delegate {
extension SellerProductViewController: UploadProductSpecCellDelegate {
    func removeData(_ cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        variants.removeValue(forKey: indexPath)
    }
    
    func chooseColor(_ cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        currentSpecIndexPath = indexPath
        
        if #available(iOS 14.0, *) {
            showColorPikerView()
        } else {
            // Fallback on earlier versions
        }
    }
    
    func passData(_ cell: UITableViewCell, variant: Variant) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        variants.updateValue(variant, forKey: indexPath)
    }
    
}

// MARK: UITable view delegate
extension SellerProductViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
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
        cell.colorView.backgroundColor = color
        cell.checkUserInput()
    }
}

extension SellerProductViewController: UploadProductBasicCellDelegate {
    func removeData(_ cell: UploadProductBasicCell) {
        uploadBasicData = nil
    }
    
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
    func removeData(_ cell: UploadProductDetailCell) {
        uploadDetailData = nil
    }
    
    func detailCellData(from cell: UploadProductDetailCell, data: UploadDetailCellModel) {
        cell.delegate = self
        uploadDetailData = data
    }
}
