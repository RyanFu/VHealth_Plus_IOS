//
//  UIColor+Extension.swift
//  GongYunTong
//
//  Created by pingjun lin on 2017/3/13.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func hex(_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor().proceesHex(hex: hex, alpha: alpha)
    }
    
    // MARK: - 主要逻辑
    private func proceesHex(hex: String, alpha: CGFloat) -> UIColor{
        if hex.isEmpty {
            return UIColor.clear
        }
        
        let set = CharacterSet.whitespacesAndNewlines
        var hHex = hex.trimmingCharacters(in: set).uppercased()
        
        if hHex.characters.count < 6 {
            return UIColor.clear
        }
        if hHex.hasPrefix("0X") {
            hHex = (hHex as NSString).substring(from: 2)
        }
        if hHex.hasPrefix("#") {
            hHex = (hHex as NSString).substring(from: 1)
        }
        if hHex.hasPrefix("##") {
            hHex = (hHex as NSString).substring(from: 2)
        }
        
        if hHex.characters.count != 6 {
            return UIColor.clear
        }
        
        // R
        var range = NSMakeRange(0, 2)
        let rHex = (hHex as NSString).substring(with: range)
        // G
        range.location = 2
        let gHex = (hHex as NSString).substring(with: range)
        // B
        range.location = 4
        let bHex = (hHex as NSString).substring(with: range)
        
        /** 类型转换 */
        var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0;
        
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
}

// 项目内部使用的颜色值
extension UIColor {
    
    class func bgColor() -> UIColor {
        return UIColor.hex("#EFEFF4")
    }
    
    class func bgBtnColor() -> UIColor {
        return UIColor.hex("#e65248")
    }
}
