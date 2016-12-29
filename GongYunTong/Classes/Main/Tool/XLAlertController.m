//
//  XLAlertController.m
//  ArrayTest
//
//  Created by xulong on 16/7/23.
//  Copyright © 2016年 xulong. All rights reserved.
//

#import "XLAlertController.h"

@interface XLAlertController ()

@end

@implementation XLAlertController

+ (instancetype)alertControllerWithAttributedTitle:(nullable NSAttributedString *)attributedTitle attributedMessage:(nullable NSAttributedString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle
{
    XLAlertController *alert=[[self alloc] init];
    
    [alert setValue:attributedTitle forKeyPath:@"_attributedTitle"];
    [alert setValue:message forKeyPath:@"_attributedMessage"];
    [alert setValue:[NSNumber numberWithInt:preferredStyle] forKey:@"_preferredStyle"];
    alert.title=attributedTitle.string;
    alert.message=message.string;
    
    return alert;
}
// 设置标题属性
-(void)setTitleAttributeWithTitle:(NSString *)title
{
    NSMutableAttributedString *aTitle;
    if ([self valueForKeyPath:@"_attributedTitle"]) {
        aTitle=[self valueForKeyPath:@"_attributedTitle"];
    }else
    {
        aTitle=[[NSMutableAttributedString alloc]initWithString:title];
    }
    if (self.titleFont) [aTitle addAttribute:NSFontAttributeName value:self.titleFont range:NSMakeRange(0, aTitle.length)];
    if (self.titleColor) [aTitle addAttribute:NSForegroundColorAttributeName value:self.titleColor range:NSMakeRange(0, aTitle.length)];
    [self setValue:aTitle forKeyPath:@"_attributedTitle"];
}
// 设置内容属性
-(void)setMessageAttributeWithMessage:(NSString *)message
{
    NSMutableAttributedString *aMessage;
    if ([self valueForKeyPath:@"_attributedMessage"]) {
        aMessage=[self valueForKeyPath:@"_attributedMessage"];
    }else
    {
        aMessage=[[NSMutableAttributedString alloc]initWithString:message];
    }
    if (self.messageFont) [aMessage addAttribute:NSFontAttributeName value:self.messageFont range:NSMakeRange(0, aMessage.length)];
    if (self.messageColor) [aMessage addAttribute:NSForegroundColorAttributeName value:self.messageColor range:NSMakeRange(0, aMessage.length)];
    [self setValue:aMessage forKeyPath:@"_attributedMessage"];
}
-(void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    [self setTitleAttributeWithTitle:self.title ];
}
-(void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    [self setTitleAttributeWithTitle:self.title ];
}
-(void)setMessageFont:(UIFont *)messageFont
{
    _messageFont=messageFont;
    [self setMessageAttributeWithMessage:self.message];
}
-(void)setMessageColor:(UIColor *)messageColor
{
    _messageColor=messageColor;
    [self setMessageAttributeWithMessage:self.message];
}

-(void)setTitle:(NSString *)title
{
    [super setTitle:title];
    [self setTitleAttributeWithTitle:title ];
}
-(void)setMessage:(NSString *)message
{
    [super setMessage:message];
    [self setMessageAttributeWithMessage:message];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end


@implementation XLAlertAction

-(void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self setValue:titleColor forKeyPath:@"_titleTextColor"];
}

-(void)setLeftImage:(UIImage *)leftImage
{
    _leftImage = leftImage;
    [self setValue:[leftImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKeyPath:@"_image"];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
