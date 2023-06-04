//
//  LSColor+Extension.swift
//  STYLiSH
//
//  Created by Wayne Chen on 2021/4/21.
//  Copyright © 2021 WU CHIH WEI. All rights reserved.
//

import Foundation

extension LSColor {
    
    func toColor() -> Color? {
        if let code = code, let name = name {
            return Color(name: name, code: code)
        }
        return nil
    }
}

extension UIColor {
    public  convenience init(hex : String) {
      var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
      
      if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
      }
      
      if ((cString.count) != 6) {
        self.init(red: 1, green: 1, blue: 1, alpha: 1)
        return
      }
      
      var rgbValue:UInt64 = 0
      Scanner(string: cString).scanHexInt64(&rgbValue)
      
      self.init(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
      )
    }
  }
