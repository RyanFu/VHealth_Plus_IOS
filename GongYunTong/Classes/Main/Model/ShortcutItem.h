//
//  ShortcutItem.h
//  GongYunTong
//
//  Created by pingjun lin on 2016/11/14.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShortcutItem : NSObject

+ (ShortcutItem *)defaultShortcutItem;
- (void)configShortcutItemApplication:(UIApplication *)application;

@end
