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
    func showImage(from cell: UploadProductBasicCell, image: UIImage)
}

class UploadProductBasicCell: UITableViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let uploadImageLabel = UILabel()
    lazy var uploadImageView1 = UIImageView()
    lazy var uploadImageView2 = UIImageView()
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
        [uploadImageLabel, uploadImageView1, uploadImageView2].forEach { contentView.addSubview( $0 ) }
        let labelText = "圖片 (最多兩張圖片、容量限制 2 ＭＢ)"
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.kern: 2.25]
        let attributedText = NSMutableAttributedString(string: labelText, attributes: attributes)
        uploadImageLabel.attributedText = attributedText
        uploadImageLabel.font = UIFont(name: "PingFang TC", size: 14)
        uploadImageLabel.textColor = UIColor.B2
        
        // Create separate tap gesture recognizers for each image view
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(uploadForm))
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(uploadForm))
        
        // Add the tap gesture recognizers to the image views
        uploadImageView1.addGestureRecognizer(tapGestureRecognizer1)
        uploadImageView1.tag = 0
        uploadImageView1.contentMode = .scaleAspectFill
        uploadImageView1.clipsToBounds = true
        uploadImageView2.addGestureRecognizer(tapGestureRecognizer2)
        uploadImageView2.tag = 1
        uploadImageView2.contentMode = .scaleAspectFill
        uploadImageView2.clipsToBounds = true
        
        // Enable user interaction for the image views
        uploadImageView1.isUserInteractionEnabled = true
        uploadImageView2.isUserInteractionEnabled = true
        
        [uploadImageView1, uploadImageView2].forEach { $0.image = UIImage.asset(.Image_Placeholder) }
//        [uploadImageView1, uploadImageView2].forEach { $0.addGestureRecognizer(tap) }
//        [uploadImageView1, uploadImageView2].forEach { $0.isUserInteractionEnabled = true }
    }
    
    func setupConstraints() {
        let items = [uploadImageLabel, uploadImageView1, uploadImageView2]
        items.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            uploadImageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            uploadImageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            uploadImageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            uploadImageView1.topAnchor.constraint(equalTo: uploadImageLabel.bottomAnchor, constant: 4),
            uploadImageView1.leadingAnchor.constraint(equalTo: uploadImageLabel.leadingAnchor),
            uploadImageView1.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            uploadImageView1.widthAnchor.constraint(equalToConstant: 82),
            uploadImageView1.heightAnchor.constraint(equalToConstant: 110),
            
            uploadImageView2.topAnchor.constraint(equalTo: uploadImageLabel.bottomAnchor, constant: 4),
            uploadImageView2.leadingAnchor.constraint(equalTo: uploadImageView1.trailingAnchor, constant: 15),
            uploadImageView2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            uploadImageView2.widthAnchor.constraint(equalToConstant: 82),
            uploadImageView2.heightAnchor.constraint(equalToConstant: 110)
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
}

extension UploadProductBasicCell {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        guard let image = image else { return }
        delegate?.showImage(from: self, image: image)
    }
}
