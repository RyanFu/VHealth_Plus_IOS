//
//  DateModel.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/4/12.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateModelAJ : NSObject
@property (nonatomic,assign) NSInteger year;
@property (nonatomic,assign) NSInteger month;
@property (nonatomic,assign) NSInteger day;
@property (nonatomic,assign) NSInteger week;
+ (NSMutableArray *)getDataArrayWith:(NSDate *)beginDate addEnd:(NSDate *)endDate;
@end
