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
    let uploadImageView3 = UIImageView()
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
        [uploadImageLabel, imagesScrollView].forEach { contentView.addSubview( $0 ) }
        [uploadImageView1, uploadImageView2, uploadImageView3].forEach { imagesScrollView.addSubview( $0 ) }
        
        let opacity = "MB"
        let labelText = "圖片 (最多兩張圖片、容量限制 2 \(opacity))"
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.kern: 2.25]
        let attributedText = NSMutableAttributedString(string: labelText, attributes: attributes)
        
        uploadImageLabel.attributedText = attributedText
        uploadImageLabel.font = UIFont(name: "PingFang TC", size: 14)
        uploadImageLabel.textColor = UIColor.B2
        
        imagesScrollView.showsHorizontalScrollIndicator = false
        
        // Create separate tap gesture recognizers for each image view
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(uploadForm))
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(uploadForm))
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(uploadForm))
        
        // Add the tap gesture recognizers to the image views
        uploadImageView1.addGestureRecognizer(tapGestureRecognizer1)
        uploadImageView1.tag = 0
        uploadImageView1.contentMode = .scaleAspectFill
        uploadImageView1.clipsToBounds = true
        uploadImageView2.addGestureRecognizer(tapGestureRecognizer2)
        uploadImageView2.tag = 1
        uploadImageView2.contentMode = .scaleAspectFill
        uploadImageView2.clipsToBounds = true
        uploadImageView3.addGestureRecognizer(tapGestureRecognizer3)
        uploadImageView3.tag = 2
        uploadImageView3.contentMode = .scaleAspectFill
        uploadImageView3.clipsToBounds = true
        
        // Enable user interaction for the image views
        uploadImageView1.isUserInteractionEnabled = true
        uploadImageView2.isUserInteractionEnabled = true
        uploadImageView3.isUserInteractionEnabled = true
        
        [uploadImageView1, uploadImageView2, uploadImageView3].forEach { $0.image = UIImage.asset(.Image_Placeholder) }
//        [uploadImageView1, uploadImageView2].forEach { $0.addGestureRecognizer(tap) }
//        [uploadImageView1, uploadImageView2].forEach { $0.isUserInteractionEnabled = true }
    }
    
    func setupConstraints() {
        let items = [uploadImageLabel, imagesScrollView, uploadImageView1, uploadImageView2, uploadImageView3]
        items.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            uploadImageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            uploadImageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            uploadImageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            imagesScrollView.topAnchor.constraint(equalTo: uploadImageLabel.bottomAnchor, constant: 4),
            imagesScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imagesScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imagesScrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            imagesScrollView.heightAnchor.constraint(equalToConstant: 317),
            
            uploadImageView1.topAnchor.constraint(equalTo: imagesScrollView.topAnchor),
            uploadImageView1.leadingAnchor.constraint(equalTo: imagesScrollView.leadingAnchor, constant: 15),
            uploadImageView1.bottomAnchor.constraint(equalTo: imagesScrollView.bottomAnchor),
            uploadImageView1.widthAnchor.constraint(equalToConstant: 237),
            uploadImageView1.heightAnchor.constraint(equalToConstant: 317),
            
            uploadImageView2.topAnchor.constraint(equalTo: imagesScrollView.topAnchor),
            uploadImageView2.leadingAnchor.constraint(equalTo: uploadImageView1.trailingAnchor, constant: 15),
            uploadImageView2.bottomAnchor.constraint(equalTo: imagesScrollView.bottomAnchor),
            uploadImageView2.widthAnchor.constraint(equalToConstant: 237),
            uploadImageView2.heightAnchor.constraint(equalToConstant: 317),
            
            uploadImageView3.topAnchor.constraint(equalTo: imagesScrollView.topAnchor),
            uploadImageView3.leadingAnchor.constraint(equalTo: uploadImageView2.trailingAnchor, constant: 15),
            uploadImageView3.trailingAnchor.constraint(equalTo: imagesScrollView.trailingAnchor, constant: -15),
            uploadImageView3.bottomAnchor.constraint(equalTo: imagesScrollView.bottomAnchor),
            uploadImageView3.widthAnchor.constraint(equalToConstant: 237),
            uploadImageView3.heightAnchor.constraint(equalToConstant: 317)
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
}

extension UploadProductBasicCell {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        guard let image = image else { return }
        delegate?.showImage(from: self, image: image)
    }
}
