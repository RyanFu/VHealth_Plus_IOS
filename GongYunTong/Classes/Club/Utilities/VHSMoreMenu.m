//
//  VHSMoreMenu.m
//  GongYunTong
//
//  Created by pingjun lin on 2017/1/19.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import "VHSMoreMenu.h"
#import "NSString+extension.h"
#import "UIView+extension.h"


static CGFloat moreMenuHeight = 0;
static CGFloat moreMenuWidth = 140;
static CGFloat moreItemHeight = 44;

@interface VHSMoreMenu ()

@property (nonatomic, strong) UIView *menuView;

@end

@implementation VHSMoreMenu

+ (void)showMoreMenuWithMenuList:(NSArray *)moreMenuList tapItemBlock:(void (^)(ChatMoreModel *))tapItemBlock {
    MoreMenuView *single = [MoreMenuView shareMoreMenu];
    [single showMoreMenuWithMenuList:moreMenuList];
    
    single.callBack = tapItemBlock;
}

@end




#pragma mark - 内容视图

@interface MoreMenuView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) MoreMenuView *moreMenu;

@property (nonatomic, assign) BOOL isShowContentView;

@end

@implementation MoreMenuView

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        _contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMoreMenu)];
        [_contentView addGestureRecognizer:tap];
    }
    return _contentView;
}

+ (MoreMenuView *)shareMoreMenu {
    static MoreMenuView *single = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [[MoreMenuView alloc] initWithFrame:CGRectMake(SCREENW - 150,
                                                                NAVIAGTION_HEIGHT + 10,
                                                                moreMenuWidth,
                                                                moreMenuHeight)];
    });
    return single;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLORHex(@"#4b4848");
        
        self.layer.cornerRadius = 5;
        self.layer.shadowOffset = CGSizeMake(5, 5);
        self.layer.shadowColor = COLORHex(@"#4b4848").CGColor;
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowRadius = 4;
    }
    return self;
}

- (MoreMenuView *)showMoreMenuWithMenuList:(NSArray *)moreMenuList {
    
    if (_contentView) {
        _contentView.hidden = NO;
        return self;
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.contentView];
    
    moreMenuHeight = [moreMenuList count] * moreItemHeight;
    
    CGRect frame = self.frame;
    frame.size.height = moreMenuHeight;
    self.frame = frame;
    [self.contentView addSubview:self];
    
    for (NSInteger i = 0; i < [moreMenuList count]; i++) {
        ChatMoreModel *model = moreMenuList[i];
        MoreItemBtn *btn = [[MoreItemBtn alloc] initWithFrame:CGRectMake(0, moreItemHeight * i, moreMenuWidth, moreItemHeight) withMoreItem:model];
        btn.moreModel = model;
        [btn addTarget:self action:@selector(moreItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

- (void)moreItemAction:(MoreItemBtn *)btn {
    self.contentView.hidden = YES;
    
    if (self.callBack) self.callBack(btn.moreModel);
}

- (void)tapMoreMenu {
    self.contentView.hidden = YES;
}

- (void)dealloc {
    CLog(@"MoreMenuView---be dealloc");
}

@end



#pragma mark - 更多菜单的每一个子项

@implementation MoreItemBtn

- (instancetype)initWithFrame:(CGRect)frame withMoreItem:(ChatMoreModel *)item {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat labelW = [item.moreName computerWithSize:CGSizeMake(CGFLOAT_MAX, frame.size.height - 1)
                                                font:[UIFont systemFontOfSize:15]].width + 10;
        
        CGFloat marginX = (frame.size.width - labelW) / 2.0;
        UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, 0, labelW, frame.size.height - 1)];
        moreLabel.text = item.moreName;
        moreLabel.textAlignment = NSTextAlignmentCenter;
        moreLabel.textColor = [UIColor whiteColor];
        moreLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:moreLabel];
        
        UIView *reddot = [[UIView alloc] initWithFrame:CGRectMake(moreLabel.frame.size.width - 3, 10, 8, 8)];
        reddot.backgroundColor = [UIColor redColor];
        reddot.hidden = !item.newMsg;
        [reddot vhs_drawCornerRadius];
        [moreLabel addSubview:reddot];
        
        UIView *footline = [[UIView alloc] initWithFrame:CGRectMake(15, frame.size.height - 1, frame.size.width - 30, 1)];
        footline.backgroundColor = COLORHex(@"#5d5b5b");
        [self addSubview:footline];
    }
    return self;
}

@end
