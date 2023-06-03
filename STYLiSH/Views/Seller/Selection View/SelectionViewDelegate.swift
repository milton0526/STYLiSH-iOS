//
//  SelectionViewDelegate.swift
//  DI_1_Delegate
//
//  Created by Milton Liu on 2023/5/24.
//

import UIKit

@objc protocol SelectionViewDelegate: AnyObject {

    @objc optional func shouldSelectedButton(_ selectionView: SelectionView, at index: Int) -> Bool

    @objc optional func didSelectedButton(_ selectionView: SelectionView, at index: Int)
}
