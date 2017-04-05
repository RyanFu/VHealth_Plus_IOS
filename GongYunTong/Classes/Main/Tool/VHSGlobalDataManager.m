//
//  VHSGlobalDataManager.m
//  GongYunTong
//
//  Created by pingjun lin on 2017/2/27.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import "VHSGlobalDataManager.h"

@implementation VHSMessageCounter

- (NSInteger)messageAllNumbers {
    NSInteger allNumbers = 0;
    allNumbers = self.messagePushTextNumbers + self.messagePushUrlNumbers + self.messagePushClubNumbers;
    if (allNumbers < 0) allNumbers = 0;
    
    return allNumbers;
}

- (void)increase:(MessageCounterType)type {
    switch (type) {
        case MessageCounterUrlType:
            ++self.messagePushUrlNumbers;
            break;
        case MessageCounterTextType:
            ++self.messagePushTextNumbers;
            break;
        case MessageCounterClubType:
            ++self.messagePushClubNumbers;
            break;
        default:
            break;
    }
}

- (void)decrease:(MessageCounterType)type {
    switch (type) {
        case MessageCounterUrlType:
        {
            --self.messagePushUrlNumbers;
            self.messagePushUrlNumbers = self.messagePushUrlNumbers ? self.messagePushUrlNumbers : 0;
        }
            break;
        case MessageCounterTextType:
        {
            --self.messagePushTextNumbers;
            self.messagePushTextNumbers = self.messagePushTextNumbers ? self.messagePushTextNumbers : 0;
        }
            break;
        case MessageCounterClubType:
        {
            --self.messagePushClubNumbers;
            self.messagePushClubNumbers = self.messagePushClubNumbers ? self.messagePushClubNumbers : 0;
        }
            break;
        default:
            break;
    }
}

@end

@implementation VHSGlobalDataManager

+ (VHSGlobalDataManager *)shareGlobalDataManager {
    static VHSGlobalDataManager *globalManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globalManager = [[VHSGlobalDataManager alloc] init];
    });
    return globalManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.messageCounter = [[VHSMessageCounter alloc] init];
    }
    
    return self;
}

@end

