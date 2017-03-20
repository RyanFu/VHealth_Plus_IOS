//
//  TabbarItem.h
//  GongYunTong
//
//  Created by pingjun lin on 2016/11/29.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VHSTabConfigurationItem : NSObject

@property (nonatomic, strong) NSString *topUrl;
@property (nonatomic, strong) NSNumber *topType;        // 0: 图片 1: 文字
@property (nonatomic, strong) NSString *nindex;
@property (nonatomic, strong) NSString *footerName;

@end
