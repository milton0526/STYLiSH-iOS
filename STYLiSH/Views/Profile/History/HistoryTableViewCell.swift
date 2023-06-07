//
//  HistoryTableViewCell.swift
//  STYLiSH
//
//  Created by Milton Liu on 2023/6/2.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    lazy var productIdLabel: UILabel = {
        let label = UILabel()
        label.textColor = .B2
        label.font = .regular(size: 14)
        return label
    }()

    lazy var productTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .B1
        label.font = .regular(size: 16)
        return label
    }()

    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .B2
        label.font = .regular(size: 16)
        return label
    }()

    lazy var colorView: UIView = {
        let colorView = UIView()
        return colorView
    }()

    lazy var separatorView: UIView = {
        let colorView = UIView()
        colorView.backgroundColor = .B4
        return colorView
    }()

    lazy var sizeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .B2
        label.font = .regular(size: 16)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        [productImageView, productIdLabel, productTitleLabel, amountLabel, colorView, separatorView, sizeLabel].forEach { subview in
            contentView.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productImageView.widthAnchor.constraint(equalToConstant: 82),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            productIdLabel.topAnchor.constraint(equalTo: productImageView.topAnchor),
            productIdLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
            productIdLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            productTitleLabel.leadingAnchor.constraint(equalTo: productIdLabel.leadingAnchor),
            productTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productTitleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),

            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            colorView.leadingAnchor.constraint(equalTo: productIdLabel.leadingAnchor),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 22),
            colorView.heightAnchor.constraint(equalTo: colorView.widthAnchor),

            separatorView.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 16),
            separatorView.widthAnchor.constraint(equalToConstant: 1),
            separatorView.heightAnchor.constraint(equalToConstant: 14),
            separatorView.centerYAnchor.constraint(equalTo: colorView.centerYAnchor),

            sizeLabel.leadingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 16),
            sizeLabel.centerYAnchor.constraint(equalTo: colorView.centerYAnchor)
        ])
    }

    func configure(with product: OrderProduct) {
        productImageView.loadImage(product.image)
        productIdLabel.text = "\(product.orderId)"
        productTitleLabel.text = product.productTitle
        amountLabel.text = "x \(product.quantity)"
        sizeLabel.text = product.size
        colorView.backgroundColor = UIColor.hexStringToUIColor(hex: product.colorName)
    }
}
