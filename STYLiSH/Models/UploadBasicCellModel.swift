//
//  UploadBasicCellModel.swift
//  STYLiSH
//
//  Created by 謝承翰 on 2023/6/5.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

struct UploadBasicCellModel: Codable {
    let images: ImageUpload
    let productTitle: String
    let productDescription: String
    let categoryButton: String
}

struct ImageUpload: Codable {
    let image1: Data
    let image2: Data
}
