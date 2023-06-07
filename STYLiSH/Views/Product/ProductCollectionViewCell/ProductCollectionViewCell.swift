//
//  ProductCollectionViewCell.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/15.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

protocol ProductCollectionViewCellDelegate: AnyObject {
    func buttonPressed(from cell: ProductCollectionViewCell)
}

class ProductCollectionViewCell: UICollectionViewCell {

    weak var delegate: ProductCollectionViewCellDelegate?
    
    @IBOutlet weak var productImg: UIImageView!

    @IBOutlet weak var productTitleLbl: UILabel!

    @IBOutlet weak var productPriceLbl: UILabel!
    
    var longPressGesture: UILongPressGestureRecognizer!
    var magnifiedImageView: UIImageView!
    var magnifiedWindow: UIWindow!

    let deleteButton = UIButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gestureForProductImg()
    }

    func layoutCell(image: String, title: String, price: Int) {
        productImg.loadImage(image, placeHolder: .asset(.Image_Placeholder))
        productTitleLbl.text = title
        productPriceLbl.text = String(price)
    }
    
    func deletionButton() {
        deleteButton.setImage(UIImage.asset(.Icons_Throw_Away), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteProduct), for: .touchUpInside)
        addSubview(deleteButton)
        bringSubviewToFront(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.centerXAnchor.constraint(equalTo: productImg.centerXAnchor),
            deleteButton.centerYAnchor.constraint(equalTo: productImg.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 54),
            deleteButton.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
    
    @objc func deleteProduct() {
        delegate?.buttonPressed(from: self)
    }
    
    func gestureForProductImg() {
        // 建立長按手勢辨識器
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        
        productImg.addGestureRecognizer(longPressGesture)
        productImg.isUserInteractionEnabled = true
        
        magnifiedImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 375, height: 500))
        magnifiedImageView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        magnifiedImageView.contentMode = .scaleAspectFit
        magnifiedImageView.clipsToBounds = true
//        magnifiedImageView.isHidden = true
        
        // 建立放大視窗
        magnifiedWindow = UIWindow(frame: UIScreen.main.bounds)
        let backViewColor =  UIColor(hex: "DAD5D4")
        let transparentBackViewColor = backViewColor.withAlphaComponent(0.8)
        magnifiedWindow.backgroundColor = transparentBackViewColor
        magnifiedWindow.windowLevel = UIWindow.Level.alert
//        magnifiedWindow.isHidden = true
        magnifiedWindow.addSubview(magnifiedImageView)
    }

    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            // 在長按手勢開始時顯示放大的圖片和視窗
            magnifyImage(gesture.location(in: productImg))
        } else if gesture.state == .changed {
//            // 更新放大的圖片和視窗的位置
//            updateMagnifiedImagePosition(gesture.location(in: productImg))
        } else if gesture.state == .ended || gesture.state == .cancelled {
            // 在長按手勢結束時隱藏放大的圖片和視窗
            hideMagnifiedImage()
        }
    }

    func magnifyImage(_ location: CGPoint) {
        // Set the magnified image
        magnifiedImageView.image = productImg.image
        magnifiedImageView.layer.cornerRadius = 10
        magnifiedImageView.clipsToBounds = true
        magnifiedImageView.contentMode = .scaleAspectFill
        magnifiedImageView.backgroundColor = UIColor.clear
        
        // Calculate the position and size of the magnified image
        let magnifiedImageSize = CGSize(width: 375, height: 500)
        let magnifiedImageOrigin = CGPoint(x: 7, y: 172)
        magnifiedImageView.frame = CGRect(origin: magnifiedImageOrigin, size: magnifiedImageSize)
        
        // Show the magnified image and window with animation
        magnifiedImageView.alpha = 0.0
        magnifiedWindow.alpha = 0.0
        magnifiedImageView.isHidden = false
        magnifiedWindow.isHidden = false
        
        // Add vibration feedback
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        
        UIView.animate(withDuration: 0.3) {
            self.magnifiedImageView.alpha = 1.0
            self.magnifiedWindow.alpha = 1.0
        }
    }

    func hideMagnifiedImage() {
        // 隱藏放大的圖片和視窗
        magnifiedImageView.isHidden = true
        magnifiedWindow.isHidden = true
    }
}
