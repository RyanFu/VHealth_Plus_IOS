//
//  VHSActionData.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/8.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "VHSActionData.h"

@implementation VHSActionData

- (void)setMacAddress:(NSString *)macAddress {
    _macAddress = macAddress;
    
    if (![macAddress isEqualToString:@"0"]) {
        _macAddress = [macAddress lowercaseString];
    }
}

@end
