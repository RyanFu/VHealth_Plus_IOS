//
//  ProtocolUnitModel.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/23.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import "JKDBModel.h"
typedef enum{
    DistKlioMeter = 0, //千米
    DistMeter          //米
} DistantUnit;         //距离单位

typedef enum{
    WeightKlioGram,    //千克
    WeightPound        //英镑
} WeightUnit;          //体重单位

typedef enum {
    TempCentigrade,    //摄氏度
    TempFahrenheit,    //华氏摄氏度
}TempUnit;             //温度单位

typedef enum{
    LanguageEnglish,   //英语
    LanguageChinise,   //汉语
}Language;             //语言制

typedef enum {
    HoursSystems12 = 0,//12小时制
    HoursSystems24,    //24小时制
}HourSystem;           //时间制

@interface ProtocolUnitModel : JKDBModel

@property (nonatomic,assign) DistantUnit dist_uint;
@property (nonatomic,assign) WeightUnit weight_uint;
@property (nonatomic,assign) TempUnit temp;
@property (nonatomic,assign) uint8_t stride;
@property (nonatomic,assign) Language language;
@property (nonatomic,assign) HourSystem is_12hour_format;

@property (nonatomic,copy) NSString *smart_device_id;
@end
