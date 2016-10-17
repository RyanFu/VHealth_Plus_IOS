//
//  UserScoreModel.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/3.
//  Copyright © 2016年 lucky. All rights reserved.
//

// 用户积分

#import <Foundation/Foundation.h>

@interface UserScoreModel : NSObject

@property (nonatomic, strong) NSNumber *memberId;       // 用户 ID
@property (nonatomic, strong) NSNumber *companyId;      // 公司ID
@property (nonatomic, strong) NSNumber *score;          // 当前积分
@property (nonatomic, strong) NSNumber *gold;           // 金币

@end
