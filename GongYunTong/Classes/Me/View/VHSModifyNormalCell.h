//
//  VHSModifyNormalCell.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/18.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VHSModifyNormalCell : UITableViewCell

@property (nonatomic, strong) NSString *content;

@property (nonatomic, copy) void (^callback)(NSString *destStr);

@end
