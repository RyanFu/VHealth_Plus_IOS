//
//  ChatController.h
//  CAAdvancedTech
//
//  Created by pingjun lin on 2017/1/10.
//  Copyright © 2017年 pingjun lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>
#import "ClubModel.h"

@interface VHSChatController : RCConversationViewController

@property (nonatomic, strong) ClubModel *club;

@property (nonatomic, copy) void (^clubChatCallBack)(ClubModel *club);

@end
