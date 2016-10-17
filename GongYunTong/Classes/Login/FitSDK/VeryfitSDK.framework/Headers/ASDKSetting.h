//
//  AjSDKSetting.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/8.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ASDKDeviceUnbundling = 0,        // 解绑
    ASDKDeviceBinding = 1,           // 绑定
    ASDKDeviceConfirm =2
} ASDKDeviceBindCMD;
#pragma mark 传回数据block
/*  传回数据block
 *
 *  object 传回数据模型或字符
 *  isSuccess 是否调用成功
 */
typedef void(^BLTAcceptSettingValue)(int errorCode);


@interface ASDKSetting : NSObject
@property (nonatomic,copy) BLTAcceptSettingValue bleUpdateBlock;

#pragma mark 设备绑定
/*  设备绑定(解绑)
 *
 *  @param type 绑定或解绑
 *  @param block 传回数据 传回绑定或解绑状态值
 */

- (void)ASDKSendDeviceBindingWithCMDType:(ASDKDeviceBindCMD)type
                         withUpdateBlock:(BLTAcceptSettingValue)block;

#pragma mark 设置拍照
/*  设置拍照
 *
 *  @param isOpen 是否打开拍照模式
 *  @param block 传回数据 object为nil，errorCode为错误码
 */
- (void)ASDKSendSetTakePhotoWithCMDType:(BOOL)isOpen withUpdateBlock:(BLTAcceptSettingValue)block;


#pragma mark 设置寻找手机
/*  设置寻找手机
 *
 *  @param isOpen 是否打开
 *  @param block 传回数据 object为nil，errorCode为错误码
 */
- (void)ASDKSendSetFindPhoneType:(BOOL)isOpen  withUpdateBlock:(BLTAcceptSettingValue)block;

#pragma mark 设置升级模式
/*  设置升级模式
 *
 */
- (void)ASDKSendSetUpgrade;

#pragma mark 设置一键还原
/*  设置一键还原
 *
 */
- (void)ASDKSendSetOneKeySos;

@end
