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

    let deleteButton = UIButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func layoutCell(image: String, title: String, price: Int) {
        productImg.loadImage(image, placeHolder: .asset(.Image_Placeholder))
        productTitleLbl.text = title
        productPriceLbl.text = String(price)
    }
    
    func deletionButton() {
        deleteButton.setImage(UIImage.asset(.icons_deletion), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteProduct), for: .touchUpInside)
        addSubview(deleteButton)
        bringSubviewToFront(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: topAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 32),
            deleteButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    @objc func deleteProduct() {
        delegate?.buttonPressed(from: self)
    }
}
