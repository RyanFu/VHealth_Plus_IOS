//
//  DynamicItemModel.h
//  GongYunTong
//
//  Created by pingjun lin on 16/8/4.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicItemModel : NSObject

@property (nonatomic, strong) NSString * hrefUrl;
@property (nonatomic, strong) NSNumber * imgType;
@property (nonatomic, strong) NSString * pubTime;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * urls;

- (NSDictionary *)transferToDict;

@end
