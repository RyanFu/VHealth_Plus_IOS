//
//  StringExtentsion.swift
//  GongYunTong
//
//  Created by pingjun lin on 2017/3/9.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

import UIKit

extension String  {
    /**
     Get the height with the string.
     
     - parameter font: The string font.
     - parameter fixedWidth: The fixed width.
     
     - returns: The height.
     */
    func heightWithFont(font: UIFont = UIFont.systemFont(ofSize: 17), fixedWidth: CGFloat) -> CGFloat {
        
        guard self.characters.count > 0 && fixedWidth > 0 else {
            return 0
        }
        
        let attributes = [NSFontAttributeName : font]
        let size = CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return rect.size.height + 10
    }
    
    /**
     Get the width with the string.
     
     - parameter font: The string font.
     - parameter fixedHeight: The fixed height.
     
     - returns: The width.
     */
    func widthWithFont(font: UIFont = UIFont.systemFont(ofSize: 17), fixedHeight: CGFloat) -> CGFloat {
        
        guard self.characters.count > 0 && fixedHeight > 0 else {
            return 0
        }
        
        let attributes = [NSFontAttributeName : font]
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: fixedHeight)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return rect.size.width
    }
}

