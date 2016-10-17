//
//  IntelligentRemindModel.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/24.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntelligentRemindModel : NSObject
@property (nonatomic,assign) BOOL IntelligentRemindSms;                   //短信提醒 YES为打开，NO为关闭
@property (nonatomic,assign) BOOL IntelligentRemindFaceBook;              //facebook YES为打开，NO为关闭
@property (nonatomic,assign) BOOL IntelligentRemindWeChat;
@property (nonatomic,assign) BOOL IntelligentRemindQQ;
@property (nonatomic,assign) BOOL IntelligentRemindTwitter;
@property (nonatomic,assign) BOOL IntelligentRemindWhatsapp;
@property (nonatomic,assign) BOOL IntelligentRemindLinkedIn;
@property (nonatomic,assign) BOOL IntelligentRemindInstagram;
@property (nonatomic,assign) BOOL IntelligentRemindFaceBookMessenger;

@property (nonatomic,assign) BOOL IntelligentRemindCallRemind;
@property (nonatomic,assign) int  IntelligentRemindCallDelay;


@end
