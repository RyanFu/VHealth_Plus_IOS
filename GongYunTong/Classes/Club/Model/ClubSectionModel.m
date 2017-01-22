//
//  ClubSectionModel.m
//  GongYunTong
//
//  Created by pingjun lin on 2017/1/12.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import "ClubSectionModel.h"
#import "ClubModel.h"

@implementation ClubSectionModel

- (instancetype)initWithIndex:(NSInteger)index {
    self = [super init];
    if (self) {
        [self setupSectionModel:index];
    }
    return self;
}

- (void)setupSectionModel:(NSInteger)index {
    self.title = [NSString stringWithFormat:@"Club-%@", @(index)];
    self.sectionClubType = index;
    
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:3];
    for (NSInteger i = 0; i < 3; i++) {
        ClubModel *model = [[ClubModel alloc] initWithIndex:i];
        [list addObject:model];
    }
    self.clubList = [list copy];
}

@end
