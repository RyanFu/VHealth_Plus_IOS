//
//  MomentPhotoModel.h
//  GongYunTong
//
//  Created by pingjun lin on 2017/2/7.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, VHSImagePickerOfImageType) {
    VHSImagePickerOfImageAlbumType,         // 从相册选择
    VHSImagePickerOfImagePhotoType,         // 拍照选择
    VHSImagePickerOfImagePlaceHolderType,   // 占位选择图片
};

@interface MomentPhotoModel : NSObject

@property (nonatomic, strong) UIImage *photoImage;
@property (nonatomic, assign) VHSImagePickerOfImageType imageType;

@end
