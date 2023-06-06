//
//  SellerProduct.swift
//  STYLiSH
//
//  Created by 謝承翰 on 2023/6/6.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import Foundation

struct SellerProducts: Codable {
    let title: String
    let products: [SellerProduct]
}

struct SellerProduct: Codable {
    let title: String
    let price: String
    let category : String
    let description: String
    let story: String
    let texture: String
    let wash: String
    let place: String
    let note: String
//    let mainImage: Data
//    let images: [Data]
    let size: [String]
    let stock: [String]
    let color: [String]
    let colorName: [String]

    enum CodingKeys: String, CodingKey {
        case title
        case price
        case category
        case description
        case story
        case texture
        case wash
        case place
        case note
        case size
        case stock
        case color
        case colorName
//        case mainImage = "main_Image"
//        case images
    }
}
