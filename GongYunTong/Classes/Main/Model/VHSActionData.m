//
//  VHSActionData.m
//  GongYunTong
//
//  Created by pingjun lin on 2016/12/26.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSActionData.h"

@implementation VHSActionData

- (void)setActionId:(NSString *)actionId {
    if (!actionId) actionId = [VHSCommon getTimeStamp];
    
    _actionId = actionId;
}

- (void)setMemberId:(NSString *)memberId {
    if (!memberId) memberId = [[VHSCommon userInfo].memberId stringValue];
    
    _memberId = memberId;
}

- (void)setActionType:(NSString *)actionType {
    if (!actionType) actionType = @"2";
    
    _actionType = actionType;
}

- (void)setActionMode:(NSString *)actionMode {
    if (!actionMode) actionMode = @"0";
    
    _actionMode = actionMode;
}

- (void)setDistance:(NSString *)distance {
    if (!distance) distance = @"0";
    
    _distance = distance;
}

- (void)setSeconds:(NSString *)seconds {
    if (!seconds) seconds = @"0";
    
    _seconds = seconds;
}

- (void)setCalorie:(NSString *)calorie {
    if (!calorie) calorie = @"0";
    
    _calorie = calorie;
}

- (void)setStep:(NSString *)step {
    if (!step) step = @"0";
    
    _step = step;
}

- (void)setRecordTime:(NSString *)recordTime {
    if (!recordTime ) recordTime = @"";
    
    _recordTime = recordTime;
}

- (void)setStartTime:(NSString *)startTime {
    if (!startTime) startTime = @"";
    
    _startTime = startTime;
}

- (void)setEndTime:(NSString *)endTime {
    if (!endTime) endTime = @"";
    
    _endTime = endTime;
}

- (void)setScore:(NSString *)score {
    if (!score) score = @"0";
    
    _score = score;
}

- (void)setUpload:(NSInteger)upload {
    if (upload != 1) upload = 0;
    
    _upload = upload;
}

- (void)setMacAddress:(NSString *)macAddress {
    if (!macAddress) macAddress = @"0";
    
    _macAddress = macAddress;
}

- (void)setFloorAsc:(NSString *)floorAsc {
    if (!floorAsc) floorAsc = @"0";
    
    _floorAsc = floorAsc;
}

- (void)setFloorDes:(NSString *)floorDes {
    if (!floorDes) floorDes = @"0";
    
    _floorDes = floorDes;
}
@end
