//
//  VHSTimeToast.h
//  VHealth1.6
//
//  Created by vhsben on 16/7/8.
//  Copyright © 2016年 kumoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VHSTimeToast : UIView

+(instancetype)timeToastFromXib;

+(void)toastShow:(NSInteger)time;
+ (void)toastShow:(NSInteger)time success:(void (^)())showSuccessBlock;
@end
