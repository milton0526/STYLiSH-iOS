//
//  UploadProductDetailCell.swift
//  STYLiSH
//
//  Created by Milton Liu on 2023/6/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

protocol UploadProductDetailCellDelegate: AnyObject {
    func detailCellData(from cell: UploadProductDetailCell, data: UploadDetailCellModel)
    func removeData(_ cell: UploadProductDetailCell)
}

struct PickerModel {
    let title: String
    let data: [String]
}

class UploadProductDetailCell: UITableViewCell {
    
    weak var delegate: UploadProductDetailCellDelegate?

    @IBOutlet weak var textureTextField: STOrderUserInputTextField! {
        didSet {
            textureTextField.inputView = texturePickerView
        }
    }

    @IBOutlet weak var washTextField: STOrderUserInputTextField! {
        didSet {
            washTextField.inputView = washPickerView
        }
    }

    @IBOutlet weak var countryTextField: STOrderUserInputTextField! {
        didSet {
            countryTextField.inputView = countryPickerView
        }
    }

    @IBOutlet weak var priceTextField: STOrderUserInputTextField!

    private lazy var texturePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()

    private lazy var washPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()

    private lazy var countryPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()

    private let pickerViewData = [
        PickerModel(title: "材質", data: ["棉", "聚酯纖維", "亞麻"]),
        PickerModel(title: "洗滌方式", data: ["手洗", "乾洗", "機洗"]),
        PickerModel(title: "產地", data: ["台灣", "韓國", "日本", "中國大陸", "越南"])
    ]

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func switchPickerView(pickerView: UIPickerView) -> (textFiled: UITextField, data: [String]) {
        switch pickerView {
        case _ where pickerView === texturePickerView:
            return (textureTextField, pickerViewData[0].data)
        case _ where pickerView === washPickerView:
            return (washTextField, pickerViewData[1].data)
        case _ where pickerView === countryPickerView:
            return (countryTextField, pickerViewData[2].data)
        default:
            fatalError()
        }
    }
    
    func passData() {
        guard let textureText = textureTextField.text,
              let washText = washTextField.text,
              let contryText = countryTextField.text,
              let priceText = priceTextField.text,
              !textureText.isEmpty,
              !washText.isEmpty,
              !contryText.isEmpty,
              !priceText.isEmpty
        else {
            delegate?.removeData(self)
            return
        }
        
        let uploadDetailData = UploadDetailCellModel(
            texture: textureText,
            wash: washText,
            contry: contryText,
            price: priceText
        )
        
        delegate?.detailCellData(from: self, data: uploadDetailData)
    }
}

// MARK: - UITextField Delegate
extension UploadProductDetailCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        // pass data in each textField
        passData()

    }
}

// MARK: - UIPickerView Delegate
extension UploadProductDetailCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let (_, data) = switchPickerView(pickerView: pickerView)
        return data[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let (textField, data) = switchPickerView(pickerView: pickerView)
        textField.text = data[row]
    }
}

// MARK: - UIPickerView DataSource
extension UploadProductDetailCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let (_, data) = switchPickerView(pickerView: pickerView)
        return data.count
    }

}
