//
//  BannerItemModel.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/4.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerItemModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) NSString *hrefUrl;
@property (nonatomic, assign) NSInteger discoveryType;

- (NSDictionary *)transferToDict:(BannerItemModel *)model;

@end
