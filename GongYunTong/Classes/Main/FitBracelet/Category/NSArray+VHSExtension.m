//
//  NSArray+VHSExtension.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/15.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "NSArray+VHSExtension.h"

@implementation NSArray (VHSExtension)

- (NSString *)vhs_jsonStringWithPrettyPrint:(BOOL) prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions) (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"[]";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
