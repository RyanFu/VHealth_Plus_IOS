//
//  VHSMessageModel.swift
//  GongYunTong
//
//  Created by pingjun lin on 2017/3/8.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

import UIKit

enum MessageType: String {
    case news = "hnews"
    case meet = "meet"
    case dynamic = "dynamic"
    case activity = "activity"
}

class VHSMessageModel: NSObject {
    public var msgTitle: String = ""
    public var sourceUrl: String = ""
    public var msgTime: String = ""
    public var msgContent: String = ""
    public var sourceType: String = ""
}
