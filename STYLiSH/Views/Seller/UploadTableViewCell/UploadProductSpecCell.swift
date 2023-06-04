//
//  UploadProductSpecCell.swift
//  STYLiSH
//
//  Created by Milton Liu on 2023/6/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class UploadProductSpecCell: UITableViewCell {

    @IBOutlet weak var colorView: UIView! {
        didSet {
            colorView.layer.cornerRadius = 10
            colorView.layer.masksToBounds = true
            colorView.layer.borderWidth = 1
            colorView.layer.borderColor = UIColor.systemGray5.cgColor
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeColor))
            colorView.addGestureRecognizer(tapGesture)
        }
    }

    @IBOutlet weak var sizeTextField: UITextField! {
        didSet {
            sizeTextField.layer.cornerRadius = 10
            sizeTextField.layer.masksToBounds = true
            sizeTextField.inputView = sizePickerView
        }
    }

    @IBOutlet weak var amountTextField: UITextField! {
        didSet {
            amountTextField.layer.cornerRadius = 10
            amountTextField.layer.masksToBounds = true
        }
    }

    private lazy var sizePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()

    private let sizeData = PickerModel(title: "Size", data: ["S", "M", "L"])

    var chooseColorHandler: ((UITableViewCell) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    @objc private func changeColor(_ gesture: UITapGestureRecognizer) {
        chooseColorHandler?(self)
    }

}

// MARK: - UITextField Delegate
extension UploadProductSpecCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        // pass data in textField
    }
}

// MARK: - UIPickerView Delegate
extension UploadProductSpecCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        sizeData.data[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sizeTextField.text = sizeData.data[row]
    }
}

// MARK: - UIPickerView Delegate
extension UploadProductSpecCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        sizeData.data.count
    }

}

