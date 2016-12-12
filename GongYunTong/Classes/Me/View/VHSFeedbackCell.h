//
//  VHSFeedbackCell.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/2.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VHSFeedbackCell : UITableViewCell

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *placeHolder;

@property (nonatomic, copy) void (^callBack)(NSString *description);

@end
