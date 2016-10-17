//
//  VHSQuestionPhoneCell.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/2.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VHSQuestionPhoneCell : UITableViewCell

@property (nonatomic, strong) NSString *phoneNumberStr;
@property (nonatomic, copy) void (^callBack)(NSString *phoneNumber);

@end
