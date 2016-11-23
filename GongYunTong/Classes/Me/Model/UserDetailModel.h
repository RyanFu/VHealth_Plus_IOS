//
//  UserDetailModel.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/3.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import <Foundation/Foundation.h>

// 用户详情

@interface UserDetailModel : NSObject

@property (nonatomic, strong) NSNumber * memberId;
@property (nonatomic, strong) NSNumber * companyId;
@property (nonatomic, strong) NSString * companyName;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * birthday;
@property (nonatomic, strong) NSNumber * gender;
@property (nonatomic, strong) NSNumber * height;
@property (nonatomic, strong) NSNumber * weight;
@property (nonatomic, strong) NSArray * depts;
@property (nonatomic, strong) NSString * headerUrl;
@property (nonatomic, strong) NSString *workNo;         // 员工号

@end
