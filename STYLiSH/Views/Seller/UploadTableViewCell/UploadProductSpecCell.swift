//
//  UploadProductSpecCell.swift
//  STYLiSH
//
//  Created by Milton Liu on 2023/6/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

protocol UploadProductSpecCellDelegate: AnyObject {
    func chooseColor(_ cell: UITableViewCell)
    func passData(_ cell: UITableViewCell, variant: Variant)
    func removeData(_ cell: UITableViewCell)
}

class UploadProductSpecCell: UITableViewCell {

    weak var delegate: UploadProductSpecCellDelegate?

    @IBOutlet weak var colorView: UIView! {
        didSet {
            colorView.backgroundColor = UIColor(hex: "#000000")
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

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @objc private func changeColor(_ gesture: UITapGestureRecognizer) {
        delegate?.chooseColor(self)
    }

    func checkUserInput() {
        guard
            let color = colorView.backgroundColor?.hexStringFromColor,
            let size = sizeTextField.text,
            let amount = amountTextField.text,
            !size.isEmpty,
            !amount.isEmpty,
            let stock = Int(amount)
        else {
            delegate?.removeData(self)
            return
        }

        let variants = Variant(colorCode: color, size: size, stock: stock)
        delegate?.passData(self, variant: variants)
    }
}

// MARK: - UITextField Delegate
extension UploadProductSpecCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkUserInput()
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
