//
//  ChatMoreModel.h
//  GongYunTong
//
//  Created by pingjun lin on 2017/1/19.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatMoreModel : NSObject

@property (nonatomic, strong) NSString *moreName;
@property (nonatomic, assign) BOOL newMsg;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *moreType;

@end
