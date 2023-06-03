//
//  SecondUploadCell.swift
//  STYLiSH
//
//  Created by Milton Liu on 2023/6/3.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

protocol SecondUploadCellDelegate: AnyObject {
    func presentColorPickerView(_ cell: UITableViewCell)
}

class SecondUploadCell: UITableViewCell {
    struct PickerModel {
        let title: String
        let data: [String]
    }

    @IBOutlet weak var sizeTextField: STOrderUserInputTextField! {
        didSet {
            sizeTextField.inputView = sizePickerView
        }
    }

    @IBOutlet weak var amountTextField: STOrderUserInputTextField!
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

    @IBOutlet weak var noteTextField: STOrderUserInputTextField!

    private lazy var sizePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()

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
        PickerModel(title: "尺寸", data: ["S", "M", "L"]),
        PickerModel(title: "材質", data: ["棉", "聚酯纖維", "亞麻"]),
        PickerModel(title: "洗滌方式", data: ["手洗", "乾洗", "機洗"]),
        PickerModel(title: "產地", data: ["台灣", "韓國", "日本"])
    ]

    weak var delegate: SecondUploadCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    @IBAction func didClickChooseColorButton(_ sender: UIButton) {
        delegate?.presentColorPickerView(self)
    }

    @IBAction func addButton(_ sender: UIButton) {

    }
    
    @IBAction func subtractButton(_ sender: UIButton) {

    }

    private func switchPickerView(pickerView: UIPickerView) -> [String] {
        switch pickerView {
        case _ where sizeTextField.inputView === pickerView:
            return pickerViewData[0].data
        case _ where textureTextField.inputView === pickerView:
            return pickerViewData[1].data
        case _ where washTextField.inputView === pickerView:
            return pickerViewData[2].data
        case _ where countryTextField.inputView === pickerView:
            return pickerViewData[3].data
        default:
            return []
        }
    }
}

// MARK: - UITextField Delegate
extension SecondUploadCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {

    }
}

// MARK: - UIPickerView Delegate
extension SecondUploadCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let titles = switchPickerView(pickerView: pickerView)
        return titles[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

    }}

// MARK: - UIPickerView DataSource
extension SecondUploadCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        3
    }

}
