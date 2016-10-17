//
//  XLTextView.h
//  WeChatTestXL
//
//  Created by MacBook Pro on 16/3/9.
//  Copyright © 2016年 haoshenghuoLongXu. All rights reserved.
//

//自定义带placeholder的textview
#import <UIKit/UIKit.h>

@interface XLTextView : UITextView

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
@end
