//
//  UINavigationController+XLShouldPopExtention.h
//  CutNavBackTest2
//
//  Created by MacBook Pro on 16/3/23.
//  Copyright © 2016年 haoshenghuoLongXu. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol UINavigationControllerShouldPopProtocol <NSObject>

-(BOOL)navigationShouldPopOnBackButton:(UINavigationController *)navigationController;

@end

@interface UINavigationController (XLShouldPopExtention)

@end
