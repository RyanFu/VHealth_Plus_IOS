//
//  NSDictionary+VHSExtension.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/15.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "NSDictionary+VHSExtension.h"

@implementation NSDictionary (VHSExtension)

- (NSString *)convertJson {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonStr = @"{}";
    if (jsonData) {
        jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonStr;
}


@end
