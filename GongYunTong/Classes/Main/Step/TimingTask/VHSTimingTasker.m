//
//  VHSTimingTasker.m
//  GongYunTong
//
//  Created by pingjun lin on 2017/3/3.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import "VHSTimingTasker.h"
#import "VHSStepAlgorithm.h"
#import "VHSDataBaseManager.h"
#import "NSDate+VHSExtension.h"

@interface VHSTimingTasker ()

@end

@implementation VHSTimingTasker

- (void)startTimingTask {
    NSDate *startDate = [VHSCommon dateWithDateStr:self.startTime];
    NSDate *endDate = [VHSCommon dateWithDateStr:self.endTime];
    
    [[VHSDataBaseManager shareInstance] createTimingTaskTable];
    
    NSString *stDate = @"2017-01-25 09:40:00";
    NSInteger days = [NSDate pastOfNowWithPastDateStr:stDate];
    
    for (NSInteger i = days; i >= 0; i--) {
        
        NSDate *startDate = [NSDate designatDate:[NSDate yyyymmddhhmmssPastDay:i] hour:@"09" minute:@"30"];
        NSDate *endDate = [NSDate designatDate:[NSDate yyyymmddhhmmssPastDay:i] hour:@"19" minute:@"30"];
        
        [[VHSStepAlgorithm shareAlgorithm].pedometer queryPedometerDataFromDate:startDate toDate:endDate withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            CLog(@"---->>> %@ ---->>> %@ ---->>> %@", [NSDate ymdByPastDay:i], pedometerData.numberOfSteps, @(i));
            
            VHSActionData *action = [[VHSActionData alloc] init];
            action.actionId = [VHSCommon getTimeStamp];
            action.memberId = [VHSCommon userInfo].memberId.stringValue;
            action.taskType = @"task_09_17";
            action.actionType = @"0";
            action.step = pedometerData.numberOfSteps.stringValue;
            action.recordTime = [NSDate ymdByPastDay:i];
            action.floorAsc = pedometerData.floorsAscended.stringValue;
            action.floorDes = pedometerData.floorsDescended.stringValue;
            action.distance = @(pedometerData.distance.floatValue / 1000).stringValue;
            action.upload = 1;
            action.startTime = [VHSCommon getDate:startDate];
            action.endTime = [VHSCommon getDate:endDate];
            
            [[VHSDataBaseManager shareInstance] insertTimingTaskWith:action];
        }];
    }
}

@end
