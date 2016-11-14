//
//  ShortcutItem.m
//  GongYunTong
//
//  Created by pingjun lin on 2016/11/14.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "ShortcutItem.h"

@interface ShortcutItem ()

@property (nonatomic, copy)NSMutableArray *shortcutItemList;

@end

@implementation ShortcutItem

- (NSMutableArray *)shortcutItemList {
    if (!_shortcutItemList) {
        _shortcutItemList = [NSMutableArray new];
    }
    return _shortcutItemList;
}

+ (ShortcutItem *)defaultShortcutItem {
    static ShortcutItem *shortcutItem = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (shortcutItem == nil) {
            shortcutItem = [[ShortcutItem alloc] init];
        }
    });
    return shortcutItem;
}

- (void)configShortcutItemApplication:(UIApplication *)application {
    
    UIApplicationShortcutIcon *shareIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare];
    NSDictionary *infoShare = @{@"scheme":@"vhealth://share"};
    UIMutableApplicationShortcutItem *shartItem = [[UIMutableApplicationShortcutItem alloc] initWithType:@"vhealth_plus_share" localizedTitle:@"分享 “V健康+”" localizedSubtitle:nil icon:shareIcon userInfo:infoShare];
    [self.shortcutItemList addObject:shartItem];
    
    
    [UIApplication sharedApplication].shortcutItems = self.shortcutItemList;
}


@end
