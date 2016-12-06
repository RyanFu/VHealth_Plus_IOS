//
//  VHSDataBaseManager.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/8.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHSActionData.h"
#import <VeryfitSDK/FMDB.h>

@interface VHSDataBaseManager : NSObject

+ (VHSDataBaseManager *)shareInstance;          // 数据库管理员单例

/**
 *  数据库路径
 *
 *  @return database path
 */
- (NSString *)dbPath;

/**
 *  创建数据库
 */
- (void)createDB;

/**
 *  创建表
 */
- (void)createTable;

/**
 *  插入一条数据到运动一览表
 *
 *  @param action_id   主键 运动ID 时间戳
 *  @param member_id   用户ID
 *  @param action_mode 0
 *  @param action_type 运动检测类型 － 手环 － healthKit
 *  @param distance    运动距离 － km
 *  @param seconds     本次运动的时长，单位S
 *  @param calorie     卡路里
 *  @param step        运动步数
 *  @param start_time  开始时间
 *  @param end_time    结束时间
 *  @param score       分数
 *  @param upload      是否上传到服务器
 *  @param mac_address Mac 地址 主要用于区别手机数据和手环数据
 *
 *  @return 插入是否成功
 */
- (BOOL)insertActionLst:(NSString *)action_id
              member_id:(NSString *)member_id
            action_mode:(NSInteger) action_mode
            action_type:(NSString *)action_type
               distance:(float)distance
                seconds:(NSInteger)seconds
                calorie:(NSInteger)calorie
                   step:(NSInteger)step
             start_time:(NSString *)start_time
               end_time:(NSString *)end_time
            record_time:(NSString *)record_time
                  score:(NSInteger)score
                 upload:(NSInteger)upload
            mac_address:(NSString *)mac_address;


/**
 *  更新运动上传状态
 *
 *  @param actionId actionID
 */
-(void)updateStatusToActionLst:(NSString *)recordTime macAddress:(NSString *)macAddress distance:(NSString *)distance;

/**
 *  获取未上传所有运动（运动一览表）
 *
 *  @param memberId 用户ID
 *
 *  @return 未上传的数据
 */
-(NSMutableArray *)selectUnuploadFromActionLst:(NSString *)memberId;

/**
 *  获取用户一天的总步数
 *
 *  @param mdmberId 用户ID
 *  @param ymd      时间 yyyyMMdd
 *
 *  @return  总步数
 */
- (NSInteger)selectSumDayStepsFromActionLst:(NSString *)memberId ymd:(NSString *)ymd;

/**
 *  更新或记录时间插入或者更新一条手环数据
 *
 *  @param recordTime 记录时间
 *
 *  @param actionType 活动类型
 *
 *  @param 步数
 */
- (void)insertOrUpdateBleActionLst:(NSString *)action_id
                        member_id:(NSString *)member_id
                      action_mode:(NSInteger) action_mode
                      action_type:(NSString *)action_type
                         distance:(float)distance
                          seconds:(NSInteger)seconds
                          calorie:(NSInteger)calorie
                             step:(NSInteger)step
                       start_time:(NSString *)start_time
                         end_time:(NSString *)end_time
                      record_time:(NSString *)record_time
                            score:(NSInteger)score
                           upload:(NSInteger)upload
                      mac_address:(NSString *)mac_address;


/// 更新或同步谐处理器数据
- (void)insertOrUpdateM7ActionLst:(NSString *)action_id
                        member_id:(NSString *)member_id
                      action_mode:(NSInteger) action_mode
                      action_type:(NSString *)action_type
                         distance:(float)distance
                          seconds:(NSInteger)seconds
                          calorie:(NSInteger)calorie
                             step:(NSInteger)step
                       start_time:(NSString *)start_time
                         end_time:(NSString *)end_time
                      record_time:(NSString *)record_time
                            score:(NSInteger)score
                           upload:(NSInteger)upload
                      mac_address:(NSString *)mac_address;

/**
 *  更新一条数据
 *
 *  @param action 运动数据
 */
- (void)updateSportStepWithActionData:(VHSActionData *)action;


@end
