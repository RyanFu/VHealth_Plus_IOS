//
//  VHSCommentController.h
//  GongYunTong
//
//  Created by pingjun lin on 2017/2/6.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import "VHSBaseViewController.h"
#import "ClubModel.h"

typedef NS_ENUM(NSUInteger, VHSCommentOfMomentType) {
    VHSCommentOfMomentPublishPostType,          // 发帖子 - 有图片
    VHSCommentOfMomentReplyPostType,            // 回复帖子
    VHSCommentOfMomentAnnouncementType,         // 发布公告
    VHSCommentOfMomentUpdateAnnouncementType    // 编辑公告
};

@interface VHSCommentController : VHSBaseViewController

@property (nonatomic, assign) VHSCommentOfMomentType commentType;

//@property (nonatomic, strong) ClubModel *club;
@property (nonatomic, strong) NSString      *clubId;
@property (nonatomic, strong) NSString      *bbsId;
@property (nonatomic, strong) NSString      *noticeId;
@property (nonatomic, strong) NSString      *content;   // 编辑的内容

@end
