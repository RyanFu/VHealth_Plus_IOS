//
//  DynamicItemModel.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/4.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "DynamicItemModel.h"

@implementation DynamicItemModel

- (NSDictionary *)transferToDict {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:self.hrefUrl forKey:@"hrefUrl"];
    [dict setObject:self.imgType forKey:@"imgType"];
    [dict setObject:self.pubTime forKey:@"pubTime"];
    [dict setObject:self.title forKey:@"title"];
    [dict setObject:self.urls forKey:@"urls"];
    return [dict copy];
}


@end
