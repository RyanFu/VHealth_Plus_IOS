//
//  ProtocolMusicModel.h
//  SDKTestAppAiju
//
//  Created by aiju_huangjing1 on 16/5/24.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import "JKDBModel.h"

@interface ProtocolMusicModel : JKDBModel
@property (nonatomic,copy) NSString *smart_device_id;
@property (nonatomic,assign) BOOL isOn;
@end
