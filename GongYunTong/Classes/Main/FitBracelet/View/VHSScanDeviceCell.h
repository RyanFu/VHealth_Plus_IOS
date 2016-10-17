//
//  VHSScanDeviceCell.h
//  VHealth1.6
//
//  Created by vhsben on 16/6/27.
//  Copyright © 2016年 kumoway. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VHSScanDeviceCell;

@protocol VHSScanDeviceCellDelegate <NSObject>

@optional
-(void)vhsScanDeviceCellBindClick:(VHSScanDeviceCell *)cell;
@end


@interface VHSScanDeviceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *waitingIgv;
@property (weak, nonatomic) IBOutlet UIButton *bingButton;
@property (nonatomic,weak)  id <VHSScanDeviceCellDelegate> delegate;
@property (nonatomic,strong) PeripheralModel *model;

@end
