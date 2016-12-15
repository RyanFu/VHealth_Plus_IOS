//
//  IconItem.h
//  GongYunTong
//
//  Created by pingjun lin on 2016/12/9.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IconItem : NSObject

@property (nonatomic, strong) NSString *iconHref;   // url
@property (nonatomic, assign) NSInteger iconType;   // icon的类型
@property (nonatomic, strong) NSString *imgUrl;     // 图片链接

- (NSDictionary *)transferToDic;

@end
