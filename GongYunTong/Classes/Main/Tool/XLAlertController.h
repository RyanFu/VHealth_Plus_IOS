//
//  XLAlertController.h
//  ArrayTest
//
//  Created by xulong on 16/7/23.
//  Copyright © 2016年 xulong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLAlertController : UIAlertController

/** 标题字体*/
@property (nonatomic,strong)UIFont *titleFont;
/** 标题颜色*/
@property (nonatomic,strong)UIColor *titleColor;

/** 内容字体*/
@property (nonatomic,strong)UIFont *messageFont;
/** 内容颜色*/
@property (nonatomic,strong)UIColor *messageColor;

/**
 * 初始化带attribute的alertController
 * 注意：通过此方法初始化后，如若改变title和message，需用kvc对成员变量赋值,且不能用同一个NSAttributedString对象
 */
+ (instancetype)alertControllerWithAttributedTitle:(NSAttributedString *)attributedTitle attributedMessage:(NSAttributedString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle;
@end

@interface XLAlertAction : UIAlertAction 

/** 字体颜色*/
@property(nonatomic,strong)UIColor *titleColor;
/** 左侧图片*/
@property(nonatomic,strong)UIImage *leftImage;

@end
