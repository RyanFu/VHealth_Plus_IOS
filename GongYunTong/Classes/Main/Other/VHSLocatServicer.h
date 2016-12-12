//
//  VHSLocatServicer.h
//  GongYunTong
//
//  Created by pingjun lin on 16/9/2.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VHSLocatServicer : NSObject

+ (VHSLocatServicer *)shareLocater;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end
