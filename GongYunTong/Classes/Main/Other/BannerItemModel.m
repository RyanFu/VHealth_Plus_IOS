//
//  BannerItemModel.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/4.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "BannerItemModel.h"

@implementation BannerItemModel

- (NSDictionary *)transferToDict:(BannerItemModel *)model {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    if (!self.title) {
        return [dict copy];
    }
    
    [dict setObject:self.title forKey:@"title"];
    [dict setObject:self.iconUrl forKey:@"iconUrl"];
    [dict setObject:self.hrefUrl forKey:@"hrefUrl"];
    [dict setObject:@(self.discoveryType) forKey:@"discoveryType"];
    return [dict copy];
}

@end
