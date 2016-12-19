//
//  VHSDynamicConfigurationCell.m
//  GongYunTong
//
//  Created by pingjun lin on 2016/12/7.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSDynamicConfigurationCell.h"

@class IconConfigurationBtn;

@implementation VHSDynamicConfigurationCell

- (void)setConfigurationList:(NSArray *)configurationList {
    _configurationList = configurationList;
    
    for (NSInteger i = 0; i < [self.configurationList count]; i++) {
        CGFloat fixX = i % 4;
        CGFloat fixY = i / 4;
        
        IconConfigurationBtn *btn = [[IconConfigurationBtn alloc] initWithFrame:CGRectMake((15 + (15 + 75) * fixX) * ratioW, ((5 + 90 * ratioW) * fixY), 75 * ratioW, 90 * ratioW)];
        btn.tag = i + 100;
        [btn addTarget:self action:@selector(configurationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
        // 数据配置
        btn.iconItem = self.configurationList[i];
        
        // cell底部的线条
        if (i == [self.configurationList count] - 1) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame), SCREENW, 15)];
            line.backgroundColor = COLORHex(@"#f0f0f2");
            [self.contentView addSubview:line];
        }
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    }
    return self;
}

#pragma mark - configurationBtnClick

- (void)configurationBtnClick:(IconConfigurationBtn *)btn {
    NSInteger index = btn.tag - 100;
    IconItem *iconItem = self.configurationList[index];
    
    if (self.iconCallBack) {
        self.iconCallBack(iconItem);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end


// 配置按钮

@interface IconConfigurationBtn ()

@property (nonatomic, strong) UIImageView   *iconImgView;
@property (nonatomic, strong) UILabel       *titleLbl;

@end

@implementation IconConfigurationBtn

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        CGFloat iconW = frame.size.width;
        CGFloat iconH = frame.size.height;
        
        _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iconW, iconH)];
        [self addSubview:_iconImgView];
    }
    return self;
}

- (void)setIconItem:(IconItem *)iconItem {
    if (_iconItem == iconItem) return;
    
    _iconItem = iconItem;
    
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:_iconItem.imgUrl]
                    placeholderImage:[UIImage imageNamed:@"pic_dynamic_default200_120"]];
}

@end
