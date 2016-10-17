//
//  VHSBaseViewController.h
//  GongYunTong
//
//  Created by vhsben on 16/7/18.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlassView.h"
#import "BaiduMobStat.h"

@interface VHSBaseViewController : UIViewController

@property (nonatomic, assign) BOOL isVisible;

/**
 *  毛玻璃效果view
 */
@property (nonatomic,strong)GlassView * glassView;
/**
 *下个页面显示的返回按钮标题
 * 注意：导航不能为空
 */
@property(nonatomic,copy)NSString *nextVcBackTitle;
@end
