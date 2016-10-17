//
//  LoginModel.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/2.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject

@property (nonatomic, assign) NSInteger loginNum;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger weight;
@property (nonatomic, strong) NSString  *birthday;
@property (nonatomic, assign) NSInteger upgrade;
@property (nonatomic, assign) NSInteger acceptMsg;
@property (nonatomic, assign) NSInteger addStepMaxNum;

@end
