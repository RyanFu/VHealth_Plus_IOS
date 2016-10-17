//
//  VHSFitBraceletHelpController.m
//  VHealth1.6
//
//  Created by vhsben on 16/6/29.
//  Copyright © 2016年 kumoway. All rights reserved.
//

#import "VHSFitBraceletHelpController.h"

@interface VHSFitBraceletHelpController ()

@property(nonatomic,retain) UIImageView *topShadowImage;
@end

@implementation VHSFitBraceletHelpController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
    self.title =@"手环帮助";
}


-(void)initNavigationBar
{
    UIButton* leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame=CGRectMake(0,0,22,22);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_common_back"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_common_back_p"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(reBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* left=[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    if (iOS7) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        item.width-=8;
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:item,left,nil];
        
    }else{
        self.navigationItem.leftBarButtonItem=left;
    }
}
-(void)reBack{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.topShadowImage];
}
#pragma mark --seters geters

/// 导航栏底部阴影
-(UIImageView*)topShadowImage{
    if (!_topShadowImage) {
        _topShadowImage=[[UIImageView alloc] init];
        _topShadowImage.image=[UIImage imageNamed:@"navibar_common_shadow"];
        [_topShadowImage setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2)];
        [self.view bringSubviewToFront:_topShadowImage];
    }
    return _topShadowImage;
}
@end
