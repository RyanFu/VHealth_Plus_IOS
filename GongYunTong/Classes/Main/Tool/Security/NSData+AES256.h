//
//  NSData+AES256.h
//  GongYunTong
//
//  Created by pingjun lin on 2016/11/11.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES256)

- (NSData *)aes256_encrypt:(NSString *)key;
- (NSData *)aes256_decrypt:(NSString *)key;

@end
