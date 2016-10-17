//
//  KeyChainStore.h
//  Foowwphone
//
//  Created by Fooww on 16/3/29.
//  Copyright © 2016年 Fooww. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;

@end
