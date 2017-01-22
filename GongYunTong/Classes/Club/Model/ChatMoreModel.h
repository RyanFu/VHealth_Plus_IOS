//
//  ChatMoreModel.h
//  GongYunTong
//
//  Created by pingjun lin on 2017/1/19.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ChatMoreType) {
    ChatMoreType_Card,
    ChatMoreType_NewMemberApply,
    ChatMoreType_ClubIntro,
    ChatMoreType_ClubMember,
    ChatMoreType_QuitClub
};

@interface ChatMoreModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isRead;
@property (nonatomic, assign) ChatMoreType moreType;

@end
