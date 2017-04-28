//
//  UserInfoModel.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/3.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

@property (nonatomic, strong) NSNumber *loginNum;           // 登录次数
@property (nonatomic, strong) NSNumber *gender;             // 性别
@property (nonatomic, strong) NSNumber *height;             // 身高
@property (nonatomic, strong) NSNumber *weight;             // 体重
@property (nonatomic, strong) NSString *birthday;           // 出生日期
@property (nonatomic, strong) NSNumber *upgrade;            // 是否升级 0否1强制升级2建议升级
@property (nonatomic, strong) NSNumber *acceptMsg;          // 是否接受消息 0否，1是
@property (nonatomic, strong) NSNumber *addStepMaxNum;      // 单次上传步数条数最大值  默认50条
@property (nonatomic, strong) NSNumber *memberId;           // 用户ID
@property (nonatomic, strong) NSString *account;            // 用户账户
@property (nonatomic, strong) NSNumber *companyId;          // 公司ID
@property (nonatomic, strong) NSString *rongcloudToken;     // 连接融云的token

@end

