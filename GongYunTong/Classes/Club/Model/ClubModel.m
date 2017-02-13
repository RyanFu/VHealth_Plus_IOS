//
//  ClubModel.m
//  GongYunTong
//
//  Created by pingjun lin on 2017/1/12.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import "ClubModel.h"

@implementation ClubModel

- (instancetype)initWithIndex:(NSInteger)index {
    self = [super init];
    
    if (self) {
        self.clubUrl = @"http://118.242.18.199:10000/uploadFile/header/PLT3Z1483432327758.jpg";
        self.title = [NSString stringWithFormat:@"title--%@", @(index)];
        self.desc = [NSString stringWithFormat:@"desc--%@", @(index)];
        self.members = [NSString stringWithFormat:@"have--%@", @(index)];
        self.isRead = [@(arc4random() % 2) boolValue];
        self.targetId = [@(arc4random() % 100) stringValue];
    }
    
    return self;
}

@end
