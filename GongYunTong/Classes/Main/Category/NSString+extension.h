//
//  NSString+VHSExtension.h
//  GongYunTong
//
//  Created by pingjun lin on 2016/11/18.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (extension)

/// json转换为数组或字典
- (id)convertObject;
/// 计算文本的宽高
- (CGSize)computerWithSize:(CGSize)size font:(UIFont *)font;

@end
