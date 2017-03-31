//
//  UILabel+Size.swift
//  GongYunTong
//
//  Created by pingjun lin on 2017/3/31.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

import UIKit

extension UILabel {
    /**
     Get the height with the UILabel.
     
     - returns: The height.
     */
    func height() -> CGFloat {
        let size = self.sizeThatFits(CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
        return size.height
    }
    
    /**
     Get the width with the UILabel.
     
     - returns: The width.
     */
    func width() -> CGFloat {
        let size = self.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: self.frame.height))
        return size.width
    }
    
    /**
     Auto fit label Height By fixed Width
     
     - returns: Void
    */
    func autofitByFixedWidth() {
        var frame = self.frame
        frame.size.height = self.height()
        self.frame = frame
    }
    
    /**
     Auto fit label Width By fixed Height
     
     - returns: Void
     */
    func autofitByFixedHeight() {
        var frame = self.frame
        frame.size.width = self.width()
        self.frame = frame
    }
}
