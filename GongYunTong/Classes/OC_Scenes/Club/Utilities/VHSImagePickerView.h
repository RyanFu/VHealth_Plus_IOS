//
//  VHSImagePickerView.h
//  GongYunTong
//
//  Created by pingjun lin on 2017/2/6.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MomentPhotoModel.h"

@interface VHSImagePickerView : UIView

@property (nonatomic, weak) UIViewController *fatherController;

@property (nonatomic, copy) void(^imagePickerCompletionHandler)(NSArray *momentItems);

@end


@interface VHSImagePickerCollectionCell : UICollectionViewCell

@property (nonatomic, strong) MomentPhotoModel *moment;

@property (nonatomic, copy) void(^removeSelectedImageBlock)();


@end
