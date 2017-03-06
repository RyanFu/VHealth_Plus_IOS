//
//  VHSTimingTasker.h
//  GongYunTong
//
//  Created by pingjun lin on 2017/3/3.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface VHSTimingTasker : NSObject

@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;

- (void)startTimingTask;

@end
