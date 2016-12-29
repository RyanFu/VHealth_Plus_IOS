//
//  DBSafetyCoordinator.h
//  GongYunTong
//
//  Created by pingjun lin on 2016/12/26.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHSActionData.h"

@interface DBSafetyCoordinator : NSObject

+ (DBSafetyCoordinator *)shareDBCoordinator;

/// 运动数据加密
- (VHSActionData *)encryptAction:(VHSActionData *)action;

/// 运动数据解密
- (VHSActionData *)decryptAction:(VHSActionData *)action;

- (NSString *)encryptMemberId:(NSString *)memberId;

- (NSString *)decryptMemberId:(NSString *)memberId;

- (NSString *)encryptStep:(NSString *)step;

- (NSString *)decryptStep:(NSString *)step;

- (NSString *)encryptRecordTime:(NSString *)recordTime;

- (NSString *)decryptRecordTime:(NSString *)recordTime;

@end
