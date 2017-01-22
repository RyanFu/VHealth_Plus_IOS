//
//  ClubSectionModel.h
//  GongYunTong
//
//  Created by pingjun lin on 2017/1/12.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClubSectionModel : NSObject

@property (nonatomic, strong) NSArray       *clubList;
@property (nonatomic, strong) NSString      *title;
@property (nonatomic, assign) NSInteger     sectionClubType;


- (instancetype)initWithIndex:(NSInteger)index;

@end
