//
//  IconItem.m
//  GongYunTong
//
//  Created by pingjun lin on 2016/12/9.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "IconItem.h"

@implementation IconItem

- (NSDictionary *)transferToDic {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:self.iconHref forKey:@"iconHref"];
    [dic setObject:[NSNumber numberWithInteger:self.iconType] forKey:@"iconType"];
    [dic setObject:self.imgUrl forKey:@"imgUrl"];
    
    NSDictionary *desDic = [NSDictionary dictionaryWithDictionary:dic];
    return desDic;
}

@end
