//
//  UploadProductSpecHeaderView.swift
//  STYLiSH
//
//  Created by Milton Liu on 2023/6/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class UploadProductSpecHeaderView: UITableViewHeaderFooterView {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "商品規格"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .B2
        return label
    }()

    lazy var addSpecButton: UIButton = {
        let button = UIButton()
        button.setTitle("新增", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.B2, for: .normal)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .B2
        button.addTarget(self, action: #selector(addNewSpecRow), for: .touchUpInside)
        return button
    }()

    var handler: (() -> Void)?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func addNewSpecRow(_ sender: UIButton) {
        handler?()
    }

    private func setupView() {
        [titleLabel, addSpecButton].forEach { subview in
            contentView.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            addSpecButton.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 16),
            addSpecButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            addSpecButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)

        ])
    }
}
