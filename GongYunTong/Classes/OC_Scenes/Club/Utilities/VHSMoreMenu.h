//
//  VHSMoreMenu.h
//  GongYunTong
//
//  Created by pingjun lin on 2017/1/19.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMoreModel.h"

@interface VHSMoreMenu : NSObject

+ (void)showMoreMenuWithMenuList:(NSArray *)moreMenuList tapItemBlock:(void (^)(ChatMoreModel *model))tapItemBlock;

@end


@interface MoreMenuView : UIView

@property (nonatomic, copy) void (^callBack)(ChatMoreModel *model);

+ (instancetype)shareMoreMenu;
- (MoreMenuView *)showMoreMenuWithMenuList:(NSArray *)moreMenuList;

@end



@interface MoreItemBtn : UIButton

@property (nonatomic, strong)ChatMoreModel *moreModel;

- (instancetype)initWithFrame:(CGRect)frame withMoreItem:(ChatMoreModel *)item;

@end
