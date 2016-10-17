//
//  StoryboardHelper.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/1.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "StoryboardHelper.h"

@implementation StoryboardHelper

+ (UIViewController *)controllerWithStoryboardName:(NSString *)storyboardName controllerId:(NSString *)identifier {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    UIViewController *vc=[storyboard instantiateViewControllerWithIdentifier:identifier];
    return vc;
}

@end
