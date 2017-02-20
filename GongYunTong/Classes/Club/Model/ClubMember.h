//
//  ClubMember.h
//  GongYunTong
//
//  Created by pingjun lin on 2017/2/13.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClubMember : NSObject

@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *memberType;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *rongcloudToken;

@end
