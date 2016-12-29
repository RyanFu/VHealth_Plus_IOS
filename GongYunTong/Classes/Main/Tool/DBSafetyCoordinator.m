//
//  DBSafetyCoordinator.m
//  GongYunTong
//
//  Created by pingjun lin on 2016/12/26.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "DBSafetyCoordinator.h"
#import "NSString+AES256.h"

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
    action.step = [action.step aes256_encrypt:KEY_OF_ASE];
    action.recordTime = [action.recordTime aes256_encrypt:KEY_OF_ASE];
    action.memberId = [action.memberId aes256_encrypt:KEY_OF_ASE];
    return action;
}

- (VHSActionData *)decryptAction:(VHSActionData *)action {
    action.step = [action.step aes256_decrypt:KEY_OF_ASE];
    action.memberId = [action.memberId aes256_decrypt:KEY_OF_ASE];
    action.recordTime = [action.recordTime aes256_decrypt:KEY_OF_ASE];
    return action;
}

- (NSString *)encryptMemberId:(NSString *)memberId {
    return [memberId aes256_encrypt:KEY_OF_ASE];
}

- (NSString *)decryptMemberId:(NSString *)memberId {
    return [memberId aes256_decrypt:KEY_OF_ASE];
}

- (NSString *)encryptStep:(NSString *)step {
    return [step aes256_encrypt:KEY_OF_ASE];
}

- (NSString *)decryptStep:(NSString *)step {
    return [step aes256_decrypt:KEY_OF_ASE];
}

- (NSString *)encryptRecordTime:(NSString *)recordTime {
    return [recordTime aes256_encrypt:KEY_OF_ASE];
}

- (NSString *)decryptRecordTime:(NSString *)recordTime {
    return [recordTime aes256_decrypt:KEY_OF_ASE];
}

@end
