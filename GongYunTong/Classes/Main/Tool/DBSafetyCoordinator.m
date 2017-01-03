//
//  DBSafetyCoordinator.m
//  GongYunTong
//
//  Created by pingjun lin on 2016/12/26.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "DBSafetyCoordinator.h"
#import "AES128Util.h"

#define KEY_OF_ASE          @"1qaz2wsx3edc4rfv"

@implementation DBSafetyCoordinator

+ (DBSafetyCoordinator *)shareDBCoordinator {
    static DBSafetyCoordinator *coordinator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coordinator = [[DBSafetyCoordinator alloc] init];
    });
    return coordinator;
}

- (VHSActionData *)encryptAction:(VHSActionData *)action {
    action.step = [AES128Util AES128Encrypt:action.step key:KEY_OF_ASE];
    action.recordTime = [AES128Util AES128Encrypt:action.recordTime key:KEY_OF_ASE];
    action.memberId = [AES128Util AES128Encrypt:action.memberId key:KEY_OF_ASE];
    return action;
}

- (VHSActionData *)decryptAction:(VHSActionData *)action {
    action.step = [AES128Util AES128Decrypt:action.step key:KEY_OF_ASE];
    action.memberId = [AES128Util AES128Decrypt:action.memberId key:KEY_OF_ASE];
    action.recordTime = [AES128Util AES128Decrypt:action.recordTime key:KEY_OF_ASE];
    return action;
}

- (NSString *)encryptMemberId:(NSString *)memberId {
    return [AES128Util AES128Encrypt:memberId key:KEY_OF_ASE];
}

- (NSString *)decryptMemberId:(NSString *)memberId {
    return [AES128Util AES128Decrypt:memberId key:KEY_OF_ASE];
}

- (NSString *)encryptStep:(NSString *)step {
    return [AES128Util AES128Encrypt:step key:KEY_OF_ASE];
}

- (NSString *)decryptStep:(NSString *)step {
    return [AES128Util AES128Decrypt:step key:KEY_OF_ASE];
}

- (NSString *)encryptRecordTime:(NSString *)recordTime {
    return [AES128Util AES128Encrypt:recordTime key:KEY_OF_ASE];
}

- (NSString *)decryptRecordTime:(NSString *)recordTime {
    return [AES128Util AES128Decrypt:recordTime key:KEY_OF_ASE];
}

@end
