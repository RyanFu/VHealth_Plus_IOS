//
//  VHSUnBindCell.h
//  VHealth1.6
//
//  Created by vhsben on 16/7/6.
//  Copyright © 2016年 kumoway. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VHSUnBindCell;

@protocol VHSUnBindCellDelegate <NSObject>

-(void)vHSUnBindCellClick:(VHSUnBindCell *)cell;

@end

@interface VHSUnBindCell : UITableViewCell

@property(nonatomic,weak)id<VHSUnBindCellDelegate>clickDelegate;
@end
