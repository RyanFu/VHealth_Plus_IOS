//  ActivityIndicatorView.h
//  MarkCheung
//
//  Created by Liang on 09/01/2014.
//  Copyright (c) 2014 sheng All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VHSCommon.h"

@interface ActivityIndicatorView: UIView
{
    UIActivityIndicatorView * indicator;
    UILabel* label;
    UILabel* labelMore;
    UIView* view;
}

- (id)initWithFrame2:(CGRect)frame;
-(void)setContent:(NSString *)content;
-(void)setContentMore:(NSString *)content;
-(void)startAnimating;
-(void)stopAnimating;

@end
