//
//  BalanceItemModel.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/22.
//  Copyright © 2016年 lucky. All rights reserved.
//

/// 收支明细 item

#import <Foundation/Foundation.h>

@interface BalanceItemModel : NSObject

@property (nonatomic, strong) NSString *actionName;
@property (nonatomic, strong) NSString *ctime;
@property (nonatomic, strong) NSString *gold;
@property (nonatomic, strong) NSString *score;

@end
