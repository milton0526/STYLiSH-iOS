//
//  floatingButton.swift
//  STYLiSH
//
//  Created by 謝承翰 on 2023/6/2.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class FloatingButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    private func setupButton() {
        backgroundColor = .white
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = frame.height / 2
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
        setImage(UIImage.asset(.Image_24px_Floating), for: .normal)
    }
}
