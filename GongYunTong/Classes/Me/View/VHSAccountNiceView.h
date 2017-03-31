//
//  VHSAccountNiceView.h
//  GongYunTong
//
//  Created by pingjun lin on 2017/2/28.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VHSAccountNiceView : UIView

@property (strong, nonatomic) NSDictionary *invitationInfoDict;

+ (VHSAccountNiceView *)share;

- (void)alertWithTitle:(NSString *)title prompt:(NSString *)prompt actions:(NSArray *)actions;


@end
