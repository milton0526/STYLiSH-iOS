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

// Example usage
//let image1 = UIImage(named: "image1.jpg")!
//let image2 = UIImage(named: "image2.jpg")!
//
//guard let imageData1 = image1.jpegData(compressionQuality: 0.8),
//      let imageData2 = image2.jpegData(compressionQuality: 0.8) else {
//    fatalError("Failed to convert images to data.")
//}
//
//let upload = ImageUpload(image1: imageData1, image2: imageData2)
//let uploadEncodable = upload.encodeImages()
//
//// Convert the uploadEncodable to JSON data
//let jsonEncoder = JSONEncoder()
//jsonEncoder.outputFormatting = .prettyPrinted
//
//do {
//    let jsonData = try jsonEncoder.encode(uploadEncodable)
//    if let jsonString = String(data: jsonData, encoding: .utf8) {
//        print(jsonString)
//    }
//} catch {
//    print("Failed to encode image upload: \(error)")
//}
//
