//
//  NSDictionary+VHSExtension.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/15.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (VHSExtension)

/// NSDictionary --> Json String
-(NSString *)vhs_jsonStringWithPrettyPrint:(BOOL) prettyPrint;

@end
