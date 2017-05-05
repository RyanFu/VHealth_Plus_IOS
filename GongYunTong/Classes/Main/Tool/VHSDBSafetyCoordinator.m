//
//  DBSafetyCoordinator.m
//  GongYunTong
//
//  Created by pingjun lin on 2016/12/26.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSDBSafetyCoordinator.h"
#import "AES128Util.h"

#define KEY_OF_ASE          @"1qaz2wsx3edc4rfv"

@implementation VHSDBSafetyCoordinator

+ (VHSDBSafetyCoordinator *)shareDBCoordinator {
    static VHSDBSafetyCoordinator *coordinator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coordinator = [[VHSDBSafetyCoordinator alloc] init];
    });
    return coordinator;
}

- (VHSActionData *)copyWithAction:(VHSActionData *)action {
    
    VHSActionData *copyAction = [[VHSActionData alloc] init];
    copyAction.actionId = action.actionId;
    copyAction.memberId = action.memberId;
    copyAction.actionMode = action.actionMode;
    copyAction.actionType = action.actionType;
    copyAction.distance = action.distance;
    copyAction.seconds = action.seconds;
    copyAction.calorie = action.calorie;
    copyAction.step = action.step;
    copyAction.recordTime = action.recordTime;
    copyAction.startTime = action.startTime;
    copyAction.endTime = action.endTime;
    copyAction.score = action.score;
    copyAction.upload = action.upload;
    copyAction.macAddress = action.macAddress;
    copyAction.initialStep = action.initialStep;
    copyAction.currentDeviceStep = action.currentDeviceStep;
    
    return copyAction;
}

- (VHSActionData *)encryptAction:(VHSActionData *)action {
    
    VHSActionData *encryAction = [self copyWithAction:action];
    
    encryAction.step = [AES128Util AES128Encrypt:action.step key:KEY_OF_ASE];
    encryAction.recordTime = [AES128Util AES128Encrypt:action.recordTime key:KEY_OF_ASE];
    encryAction.memberId = [AES128Util AES128Encrypt:action.memberId key:KEY_OF_ASE];
    
    return encryAction;
}

- (VHSActionData *)decryptAction:(VHSActionData *)action {
    
    VHSActionData *decryptAction = [self copyWithAction:action];
    
    decryptAction.step = [AES128Util AES128Decrypt:action.step key:KEY_OF_ASE];
    decryptAction.memberId = [AES128Util AES128Decrypt:action.memberId key:KEY_OF_ASE];
    decryptAction.recordTime = [AES128Util AES128Decrypt:action.recordTime key:KEY_OF_ASE];
    
    return decryptAction;
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
