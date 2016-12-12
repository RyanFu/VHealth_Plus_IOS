//
//  DynamicItemModel.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/4.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicItemModel : NSObject

@property (nonatomic, strong) NSString * hrefUrl;
@property (nonatomic, strong) NSNumber * imgType;
@property (nonatomic, strong) NSString * pubTime;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * urls;
@property (nonatomic, strong) NSString * dynamicZyText;

- (NSDictionary *)transferToDict;

@end
