//
//  TimerModel.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/2.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerModel : NSObject
@property (nonatomic,assign) NSInteger tagNew;
@property (nonatomic,assign) double stopCount;
- (void) timerRepeat;
@end
