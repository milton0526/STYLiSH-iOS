//
//  UserObject.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/7.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import Foundation

struct UserObject: Codable {
    let accessToken: String?
    let data: User

    enum CodingKeys: String, CodingKey {
        case data
        case accessToken = "access_token"
    }
}

struct User: Codable {
    let id: Int
    let provider: String?
    let name: String
    let email: String
    let picture: String
    let orderRecord: [OrderRecord]?
}

struct OrderRecord: Codable {
    let number: String
    let total: Int
    let products: [OrderProduct]
}

struct OrderProduct: Codable {
    let orderId: Int
    let productTitle: String
    let productId: Int
    let colorName: String
    let size: String
    let quantity: Int
    let image: String

    enum CodingKeys: String, CodingKey {
        case size, quantity, image
        case orderId = "order_id"
        case productTitle = "product_title"
        case productId = "product_id"
        case colorName = "color_name"
    }
}

struct Reciept: Codable {
    let number: String
}
