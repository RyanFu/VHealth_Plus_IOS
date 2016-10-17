//
//  StoryboardHelper.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/1.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryboardHelper : NSObject

/**
 *  用于返回Storyboard中的视图控制器controller
 */
+ (UIViewController *)controllerWithStoryboardName:(NSString *)storyboardName controllerId:(NSString *)identifier;

@end
