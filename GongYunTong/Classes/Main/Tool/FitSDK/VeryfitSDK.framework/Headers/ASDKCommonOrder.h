//
//  ASDKCommonOrder.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/8.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASDKDeviceEnum.h"
#pragma mark 传回数据block
/*  传回数据block
 *
 *  object 传回数据模型或字符
 *  isSuccess 是否调用成功
 */
typedef void(^BLTAcceptModelUpdateValue)(id object, int errorCode);
@interface ASDKCommonOrder : NSObject
@property (nonatomic,copy) BLTAcceptModelUpdateValue updateBlock;

#pragma mark 重启设备
/*  重启设备
 *
 *  @param block 传回数据
 */
- (void)ASDSendSetReloadDeviceWithUpdateBlock:(BLTAcceptModelUpdateValue)block;

@end
