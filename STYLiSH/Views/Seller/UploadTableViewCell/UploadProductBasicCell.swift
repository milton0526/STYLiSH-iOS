//
//  FirstTableViewCell.swift
//  STYLiSH
//
//  Created by 謝承翰 on 2023/6/3.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

protocol UploadProductBasicCellDelegate: AnyObject {
    func presentAlert(from cell: UploadProductBasicCell)
    func presentImagePicker(from cell: UploadProductBasicCell)
    func presentCamera(from cell: UploadProductBasicCell)
    func showImage(from cell: UploadProductBasicCell, image: UIImage)
}

class UploadProductBasicCell: UITableViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {
    
    let uploadImageLabel = UILabel()
    let imagesScrollView = UIScrollView()
    let uploadImageView1 = UIImageView()
    let uploadImageView2 = UIImageView()
    
    let productTitleLabel = UILabel()

    let productTitleTextField = CustomTextField()
    
    let productDescriptionLabel = UILabel()
    
    let productDescriptionTextField = STSellerUploadTextView()
    
    let categoryTitleLabel = UILabel()
    let categorySelectorStackView = UIStackView(arrangedSubviews: [])
    let womenButton = UIButton()
    let accessoriesButton = UIButton()
    let menButton = UIButton()
    
    let underline1 = UIView()
    let underline2 = UIView()
    
    weak var delegate: UploadProductBasicCellDelegate?
    
    var selectedViewIndex: Int?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        let imageFrameItems = [uploadImageLabel, imagesScrollView]
        let imageItems = [uploadImageView1, uploadImageView2]
        let productTitleItems = [productTitleLabel, productTitleTextField]
        let productDescriptionItems = [productDescriptionLabel, productDescriptionTextField]
        let categoryFrameItems = [categoryTitleLabel, categorySelectorStackView]
        let categoryItems = [womenButton, menButton, accessoriesButton]
        let underlines = [underline1, underline2]
        categoryItems.forEach { categorySelectorStackView.addSubview($0) }
        categorySelectorStackView.axis = .horizontal
        
        imageFrameItems.forEach { contentView.addSubview( $0 ) }
        imageItems.forEach { imagesScrollView.addSubview( $0 ) }
        underlines.forEach { contentView.addSubview( $0 ) }
        productTitleItems.forEach { contentView.addSubview( $0 ) }
        productDescriptionItems.forEach { contentView.addSubview( $0 ) }
        categoryFrameItems.forEach { contentView.addSubview( $0 ) }
        categoryItems.forEach { categorySelectorStackView.addArrangedSubview( $0 ) }
        
        let opacity = "MB"
        let imageTitle = "圖片 (最多兩張圖片、容量限制 2 \(opacity))"
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.kern: 2.25]
        let imageAttributedText = NSMutableAttributedString(string: imageTitle, attributes: attributes)
        
        uploadImageLabel.attributedText = imageAttributedText
        uploadImageLabel.font = UIFont(name: "PingFang TC", size: 14)
        uploadImageLabel.textColor = UIColor.B2
        
        imagesScrollView.showsHorizontalScrollIndicator = false
        
        // Create separate tap gesture recognizers for each image view
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(uploadForm))
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(uploadForm))
        
        // Add the tap gesture recognizers to the image views
        uploadImageView1.addGestureRecognizer(tapGestureRecognizer1)
        uploadImageView1.tag = 0
        uploadImageView2.addGestureRecognizer(tapGestureRecognizer2)
        uploadImageView2.tag = 1
        
        [uploadImageView1, uploadImageView2].forEach { $0.contentMode = .scaleAspectFill }
        [uploadImageView1, uploadImageView2].forEach { $0.clipsToBounds = true }
        [uploadImageView1, uploadImageView2].forEach { $0.isUserInteractionEnabled = true }
        [uploadImageView1, uploadImageView2].forEach { $0.image = UIImage.asset(.Image_Placeholder) }
        
        let productTitle = "名稱"
        let productAttributedText = NSMutableAttributedString(string: productTitle, attributes: attributes)
        
        underlines.forEach { $0.backgroundColor = .hexStringToUIColor(hex: "cccccc")}
        
        productTitleLabel.attributedText = productAttributedText
        productTitleLabel.font = UIFont(name: "PingFang TC", size: 14)
        productTitleLabel.textColor = UIColor.B2
        
        productTitleTextField.backgroundColor = UIColor(hex: "FFFFFF")
        productTitleTextField.layer.borderWidth = 0.4
        productTitleTextField.layer.borderColor = UIColor(hex: "cccccc").cgColor
        productTitleTextField.layer.cornerRadius = 4
        productTitleTextField.textAlignment = .left
        productTitleTextField.font = UIFont(name: "PingFang TC", size: 16)
        
        let descriptionTitle = "描述"
        let descriptionAttributedText = NSMutableAttributedString(string: descriptionTitle, attributes: attributes)
        
        productDescriptionLabel.attributedText = descriptionAttributedText
        productDescriptionLabel.font = UIFont(name: "PingFang TC", size: 14)
        productDescriptionLabel.textColor = UIColor.B2
        
        categorySelectorStackView.layer.borderWidth = 1
        categorySelectorStackView.layer.borderColor = UIColor(hex: "3F3A3A").cgColor
        
        womenButton.setAttributedTitle(NSMutableAttributedString(string: "女裝", attributes: [NSAttributedString.Key.kern: 2.4]), for: .normal)
        womenButton.setTitleColor(UIColor(hex: "FFFFFF"), for: .normal)
        womenButton.titleLabel?.font = UIFont(name: "PingFangTC-Regular", size: 14)
        womenButton.addTarget(self, action: #selector(womenButtonAction), for: .touchUpInside)
        womenButton.tag = 0
        womenButton.backgroundColor = UIColor(hex: "3F3A3A")
        womenButton.layer.borderWidth = 0.5
        womenButton.layer.borderColor = UIColor(hex: "3F3A3A").cgColor
        
        accessoriesButton.setAttributedTitle(NSMutableAttributedString(string: "配件", attributes: [NSAttributedString.Key.kern: 2.4]), for: .normal)
        accessoriesButton.setTitleColor(UIColor(hex: "3F3A3A"), for: .normal)
        accessoriesButton.titleLabel?.font = UIFont(name: "PingFangTC-Regular", size: 14)
        accessoriesButton.addTarget(self, action: #selector(accessoriesButtonAction), for: .touchUpInside)
        accessoriesButton.tag = 1
        accessoriesButton.layer.borderWidth = 0.5
        accessoriesButton.layer.borderColor = UIColor(hex: "3F3A3A").cgColor
        
        menButton.setAttributedTitle(NSMutableAttributedString(string: "男裝", attributes: [NSAttributedString.Key.kern: 2.4]), for: .normal)
        menButton.setTitleColor(UIColor(hex: "3F3A3A"), for: .normal)
        menButton.titleLabel?.font = UIFont(name: "PingFangTC-Regular", size: 14)
        menButton.addTarget(self, action: #selector(menButtonAction), for: .touchUpInside)
        menButton.tag = 2
        menButton.layer.borderWidth = 0.5
        menButton.layer.borderColor = UIColor(hex: "3F3A3A").cgColor
    }
    
    func setupConstraints() {
        let imageItems = [uploadImageLabel, imagesScrollView, uploadImageView1, uploadImageView2]
        let productTitleItems = [productTitleLabel, productTitleTextField]
        let productDescriptionItems = [productDescriptionLabel, productDescriptionTextField]
        let categoryFrameItems = [categoryTitleLabel, categorySelectorStackView, womenButton, menButton, accessoriesButton]
        let categoryItems = [womenButton, menButton, accessoriesButton]
        let underlines = [underline1, underline2]
        imageItems.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        productTitleItems.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        productDescriptionItems.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        categoryFrameItems.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        categoryItems.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        underlines.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            uploadImageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            uploadImageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            uploadImageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            imagesScrollView.topAnchor.constraint(equalTo: uploadImageLabel.bottomAnchor, constant: 4),
            imagesScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imagesScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imagesScrollView.heightAnchor.constraint(equalToConstant: 317),
            
            uploadImageView1.topAnchor.constraint(equalTo: imagesScrollView.topAnchor),
            uploadImageView1.leadingAnchor.constraint(equalTo: imagesScrollView.leadingAnchor, constant: 15),
            uploadImageView1.bottomAnchor.constraint(equalTo: imagesScrollView.bottomAnchor),
            uploadImageView1.widthAnchor.constraint(equalToConstant: 237),
            uploadImageView1.heightAnchor.constraint(equalToConstant: 317),
            
            uploadImageView2.topAnchor.constraint(equalTo: imagesScrollView.topAnchor),
            uploadImageView2.leadingAnchor.constraint(equalTo: uploadImageView1.trailingAnchor, constant: 15),
            uploadImageView2.trailingAnchor.constraint(equalTo: imagesScrollView.trailingAnchor, constant: -15),
            uploadImageView2.bottomAnchor.constraint(equalTo: imagesScrollView.bottomAnchor),
            uploadImageView2.widthAnchor.constraint(equalToConstant: 237),
            uploadImageView2.heightAnchor.constraint(equalToConstant: 317),
            
            productTitleLabel.topAnchor.constraint(equalTo: imagesScrollView.bottomAnchor, constant: 16),
            productTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            underline1.leadingAnchor.constraint(equalTo: productTitleTextField.leadingAnchor),
            underline1.trailingAnchor.constraint(equalTo: productTitleTextField.trailingAnchor),
            underline1.topAnchor.constraint(equalTo: productTitleTextField.bottomAnchor),
            underline1.heightAnchor.constraint(equalToConstant: 0.7),
            
            underline2.leadingAnchor.constraint(equalTo: productDescriptionTextField.leadingAnchor),
            underline2.trailingAnchor.constraint(equalTo: productDescriptionTextField.trailingAnchor),
            underline2.topAnchor.constraint(equalTo: productDescriptionTextField.bottomAnchor),
            underline2.heightAnchor.constraint(equalToConstant: 0.7),
            
            productTitleTextField.topAnchor.constraint(equalTo: productTitleLabel.bottomAnchor, constant: 4),
            productTitleTextField.leadingAnchor.constraint(equalTo: productTitleLabel.leadingAnchor),
            productTitleTextField.trailingAnchor.constraint(equalTo: productTitleLabel.trailingAnchor),
            productTitleTextField.heightAnchor.constraint(equalToConstant: 56),
//            productTitleTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            productDescriptionLabel.topAnchor.constraint(equalTo: productTitleTextField.bottomAnchor, constant: 16),
            productDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            productDescriptionTextField.topAnchor.constraint(equalTo: productDescriptionLabel.bottomAnchor, constant: 4),
            productDescriptionTextField.leadingAnchor.constraint(equalTo: productDescriptionLabel.leadingAnchor),
            productDescriptionTextField.trailingAnchor.constraint(equalTo: productDescriptionLabel.trailingAnchor),
            productDescriptionTextField.heightAnchor.constraint(equalToConstant: 178),
            
            categorySelectorStackView.topAnchor.constraint(equalTo: productDescriptionTextField.bottomAnchor, constant: 16),
            categorySelectorStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categorySelectorStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categorySelectorStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            womenButton.widthAnchor.constraint(equalToConstant: 115),
            womenButton.heightAnchor.constraint(equalToConstant: 44),
            accessoriesButton.widthAnchor.constraint(equalToConstant: 115),
            accessoriesButton.heightAnchor.constraint(equalToConstant: 44),
            menButton.widthAnchor.constraint(equalToConstant: 115),
            menButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // Alert
    @objc func uploadForm(_ sender: UITapGestureRecognizer) {
        print("跳出選擇照片的警示窗")
        selectedViewIndex = sender.view?.tag
        delegate?.presentAlert(from: self)
    }
    
    func selectPhoto() {
        delegate?.presentImagePicker(from: self)
    }
    
    func showCamera() {
        delegate?.presentCamera(from: self)
    }
    
    @objc func womenButtonAction() {
        [accessoriesButton, menButton].forEach { $0.backgroundColor = UIColor(hex: "FFFFFF") }
        [accessoriesButton, menButton].forEach { $0.setTitleColor(UIColor(hex: "3F3A3A"), for: .normal) }
        womenButton.backgroundColor = UIColor(hex: "3F3A3A")
        womenButton.setTitleColor(UIColor(hex: "FFFFFF"), for: .normal)
    }
    
    @objc func accessoriesButtonAction() {
        [womenButton, menButton].forEach { $0.backgroundColor = UIColor(hex: "FFFFFF") }
        [womenButton, menButton].forEach { $0.setTitleColor(UIColor(hex: "3F3A3A"), for: .normal) }
        accessoriesButton.backgroundColor = UIColor(hex: "3F3A3A")
        accessoriesButton.setTitleColor(UIColor(hex: "FFFFFF"), for: .normal)
    }
    
    @objc func menButtonAction() {
        [accessoriesButton, womenButton].forEach { $0.backgroundColor = UIColor(hex: "FFFFFF") }
        [accessoriesButton, womenButton].forEach { $0.setTitleColor(UIColor(hex: "3F3A3A"), for: .normal) }
        menButton.backgroundColor = UIColor(hex: "3F3A3A")
        menButton.setTitleColor(UIColor(hex: "FFFFFF"), for: .normal)
    }
}

extension UploadProductBasicCell {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        guard let image = image else { return }
        delegate?.showImage(from: self, image: image)
    }
}



class STSellerUploadTextView: UITextView {
    
//    func textRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))
//    }
//
//    func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))
//    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        backgroundColor = UIColor(hex: "FFFFFF")
        layer.borderWidth = 0.4
        layer.borderColor = UIColor(hex: "cccccc").cgColor
        layer.cornerRadius = 4
        textAlignment = .left
        font = UIFont(name: "PingFang TC", size: 16)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        addUnderLine()
    }
    
    private func addUnderLine() {
        let underline = UIView()
        underline.translatesAutoresizingMaskIntoConstraints = false
        addSubview(underline)
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: underline.leadingAnchor),
            trailingAnchor.constraint(equalTo: underline.trailingAnchor),
            bottomAnchor.constraint(equalTo: underline.bottomAnchor),
            underline.heightAnchor.constraint(equalToConstant: 1.0)
        ])
        
        underline.backgroundColor = .hexStringToUIColor(hex: "cccccc")
    }
}

class CustomTextField: UITextField {
    
    let inset: CGFloat = 10.0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: 0)
    }
}
