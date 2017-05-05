//
//  StoryboardHelper.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/1.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSStoryboardHelper.h"

@implementation VHSStoryboardHelper

+ (UIViewController *)controllerWithStoryboardName:(NSString *)storyboardName controllerId:(NSString *)identifier {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    UIViewController *vc=[storyboard instantiateViewControllerWithIdentifier:identifier];
    return vc;
}

@end
