//
//  VHSCommentController.h
//  GongYunTong
//
//  Created by pingjun lin on 2017/2/6.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import "VHSBaseViewController.h"

typedef NS_ENUM(NSUInteger, VHSCommentOfMomentType) {
    VHSCommentOfMomentPublishPostType,          // 发帖子 - 有图片
    VHSCommentOfMomentReplyPostType,            // 回复帖子
    VHSCommentOfMomentAnnouncementType          // 编辑公告
};

@interface VHSCommentController : VHSBaseViewController

@property (nonatomic, assign) VHSCommentOfMomentType commentType;

@end
