//
//  VHSCommon.m
//  GongYunTong
//
//  Created by vhsben on 16/7/20.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSCommon.h"
#import <SystemConfiguration/SystemConfiguration.h>
#include <netdb.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#import <CommonCrypto/CommonDigest.h>
#import "KeyChainStore.h"

NSString *const DeviceDidScanBLEsUserInfoKey = @"DeviceDidScanBLEsUserInfoKey";
NSString *const DeviceDidConnectedBLEsNotification = @"DeviceDidConnectedBLEsNotificationKey";
NSString *const DeviceDidConnectedBLEsUserInfoPeripheral = @"DeviceDidConnectedBLEsUserInfoPeripheral";

@implementation VHSCommon

+ (NSString *)appName {
    NSString *appName = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
    return appName;
}

+ (NSString *)appVersion {
    return [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
}

+ (NSString *)osVersion {
    return [NSString stringWithFormat:@"ios%@", [[UIDevice currentDevice] systemVersion]];
}

+ (NSString *)osName {
    return [[UIDevice currentDevice] systemName];
}

+ (NSString *)osNameVersion {
    return [NSString stringWithFormat:@"%@%@", [self osName], [self osVersion]];
}

+ (NSString *)idfv {
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return idfv;
}

+ (NSString *)uuid {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge_transfer NSString *)string ;
}

+ (NSString *)deviceToken {
    NSString *deviceToken = (NSString *)[KeyChainStore load:@"com.vhs.appstore.gongyuntong"];
    if (deviceToken.length) {
        return deviceToken;
    }
    NSString *deviceTokenNew = [VHSCommon uuid];
    [KeyChainStore save:@"com.vhs.appstore.gongyuntong" data:deviceTokenNew];
    return deviceTokenNew;
}

//手机型号
+ (NSString *)phoneModel{
    NSString *phoneModel = [[UIDevice currentDevice] model];
    return phoneModel;
}

+ (void)toAppStore {
    // 应用ID信息可以直接从AppStore拿到
    NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1084589981"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

+ (void)toSafariWithUrl:(NSString *)urlAddress {
    if (!urlAddress) return;
    
    BOOL isExsit = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlAddress]];
    if(isExsit) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlAddress]];
    }
}

+ (NSString *)vhstoken {
    return [self getUserDefautForKey:k_VHS_Token];
}

+ (NSString *)latitudeLongitude {
    NSString *latiLongi = [self getUserDefautForKey:k_LATITUDE_LONGITUDE];
    if (!latiLongi || !latiLongi.length) {
        return @"";
    }
    return latiLongi;
}

+ (void)removeLocationUserInfo {
    [k_UserDefaults removeObjectForKey:@"userInfo"];
    [k_UserDefaults removeObjectForKey:k_User_Detail_Info];
    [k_UserDefaults removeObjectForKey:k_VHS_Token];
    
    [k_UserDefaults removeObjectForKey:Cache_Dynamic_BannerList];
    [k_UserDefaults removeObjectForKey:Cache_Dynamic_DynamicList];
    [k_UserDefaults removeObjectForKey:Cache_Discover_BannerList];
    [k_UserDefaults removeObjectForKey:Cache_Me_UserScore];
    [k_UserDefaults synchronize];
}

+ (void)saveUserDefault:(id)value forKey:(NSString *)key {
    [k_UserDefaults setObject:value forKey:key];
    [k_UserDefaults synchronize];
}

+ (void)removeUserDefaultForKey:(NSString *)key {
    [k_UserDefaults removeObjectForKey:key];
    [k_UserDefaults synchronize];
}

+ (id)getUserDefautForKey:(NSString *)key {
    id value = [k_UserDefaults objectForKey:key];
    return value;
}

+ (BOOL)validatePassword:(NSString *)passWord
{
    NSArray *arrPassword; /*将文件转化为一行一行的*/
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"SimplePassword"
                                                          ofType:@"txt"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    arrPassword = [[NSString stringWithString:htmlCont]componentsSeparatedByString:@"\n"];
    for (id obj in arrPassword) {
        
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *objStr = (NSString *)obj;
            if (IOS_8) {
                if ([objStr containsString:passWord]) {
                    return NO;
                }
            }else{
                if ([objStr rangeOfString:passWord].location != NSNotFound) {
                    return NO;
                }
            }
        }
    }
    
    if ([passWord isEqualToString:@"654321"]
        || [passWord isEqualToString:@"123456"]) {
        
        return NO;
    }else{
        
        NSString *lastStr = @"";
        NSInteger count = 1;
        for (int i = 0; i < passWord.length; i++) {
            NSString *newStr = [passWord substringWithRange:NSMakeRange(i, 1)];
            if ([lastStr isEqualToString:newStr]) {
                count ++;
                if (passWord.length == count) {
                    return NO;
                }
            }else{
                count = 1;
            }
            lastStr = newStr;
        }
    }
    return YES;
}

+ (UserInfoModel *)userInfo {
    NSMutableDictionary *userDict = [[k_UserDefaults dictionaryForKey:@"userInfo"] mutableCopy];
    [userDict setObject:[k_UserDefaults objectForKey:k_LOGIN_NUMBERS] forKey:@"loginNum"];
    
    UserInfoModel *model = [UserInfoModel yy_modelWithDictionary:userDict];
    return model;
}

+ (UserDetailModel *)userDetailInfo {
    
    NSDictionary *userDetailInfo = [k_UserDefaults dictionaryForKey:k_User_Detail_Info];
    UserDetailModel *detailModel = [UserDetailModel yy_modelWithDictionary:userDetailInfo];
    
    return detailModel;
}

/**
 *  check if user allow local notification of system setting
 *
 *  @return YES-allowed,otherwise,NO.
 */
+ (BOOL)isAllowedNotification {
    if (!iOS8) return NO;
    
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (UIUserNotificationTypeNone != setting.types) {
        return YES;
    }
    return NO;
}

// 判断网络连接状况处理
+ (BOOL)isNetworkAvailable {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    
    return (isReachable && !needsConnection) ? YES : NO;
}

+ (BOOL)isNullString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

+ (NSString *)getYYYYmmddDate:(NSDate *)date {
    NSDateFormatter *df = [[NSDateFormatter alloc] init] ;
    df.dateFormat  = @"yyyyMMdd";
    NSString *strYmd = [df stringFromDate:date];
    
    return strYmd;
    
}

// 日期转换处理（Date --> yyyy-MM-dd）
+ (NSString *)getYmdFromDate:(NSDate *)date {
    NSDateFormatter *df = [[NSDateFormatter alloc] init] ;
    df.dateFormat  = @"yyyy-MM-dd";
    NSString *strYmd = [df stringFromDate:date];
    
    return strYmd;
}

+ (NSString *)getDate:(NSDate *)date {
    NSDateFormatter *df = [[NSDateFormatter alloc] init] ;
    df.dateFormat  = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr = [df stringFromDate:date];
    return dateStr;
}

////显示几小时前/几天前/几月前/几年前
+ (NSString *)timeInfoWithDateString:(NSString *)dateString {
    
    /*
     "SYNC_NEVER"="從未";
     "SYNC_NOW"="剛剛";
     "SYNC_HOURS_AGO"="小時前";
     "SYNC_MINIT_AGO"="分鐘前";
     */
    if ([self isNullString:dateString]==YES ) {
        return @"从未获取";
    }
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *constDate = [formater dateFromString:dateString];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    comps = [calendar components:unitFlags fromDate:constDate toDate:now options:0];
    
    NSInteger months = [comps month];
    NSInteger days = [comps day];
    NSInteger hours = [comps hour];
    NSInteger mins = [comps minute];
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    //dateForm.dateFormat = @"MM-dd HH:mm";
    dateForm.dateFormat = @"M月d日";
    if (months == 0)
    {
        if (days == 0)
        {
            if (hours == 0)
            {
                if (mins == 0)
                {
                    return @"刚刚";
                }
                else
                {
                    return [NSString stringWithFormat:@"%ld分钟前",(long)mins];
                }
            }
            else
            {
                return [NSString stringWithFormat:@"%ld小时前",(long)hours];
            }
        }
        else
        {
            return [NSString stringWithFormat:@"%@",[dateForm stringFromDate:constDate]];
        }
    }
    else
    {
        return [NSString stringWithFormat:@"%@",[dateForm stringFromDate:constDate]];
    }
}

+ (NSDate *)dateWithDateStr:(NSString *)dateStr {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formater dateFromString:dateStr];
    return date;
}

+ (NSString *)getTimeStamp {
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSNumber *numInter = [[NSNumber alloc] initWithDouble:interval * 1000];
    long long llInter = numInter.longLongValue;
    return [NSString stringWithFormat:@"%lld",llInter];
}

+ (NSString *)dateStrFromTimeStamp:(NSInteger)timeStamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM-dd HH:mm:ss";
    
    NSString *str = [formatter stringFromDate:date];
    return str;
}

+ (NSString *)dateStrFromDateStr:(NSString *)dateStr {
    NSDate *date = [VHSCommon dateWithDateStr:dateStr];
    return [VHSCommon getYmdFromDate:date];
}

+ (NSInteger)intervalSinceNow:(NSString *)lateDate {
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d = [date dateFromString:lateDate];
    
    NSTimeInterval late = [d timeIntervalSince1970] * 1;
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [dat timeIntervalSince1970] * 1;
    
    NSTimeInterval cha = now - late;
    
    return (int)cha;
}

+ (void)setShouHuanMacAddress:(NSString *)macAddress {
    [self saveUserDefault:macAddress forKey:k_SHOUHUAN_MAC_ADDRESS];
}
+ (void)setShouHuanName:(NSString *)name {
    [self saveUserDefault:name forKey:k_SHOUHUAN_NAME];
}
+ (void)setShouHuanUUID:(NSString *)uuid {
    [self saveUserDefault:uuid forKey:k_SHOUHUAN_UUID];
}
+ (void)setShouHuanBoundTime:(NSString *)time {
    [self saveUserDefault:time forKey:k_SHOUHUAN_BOUND_TIME];
}
+ (void)setShouHuanUnbingTime:(NSString *)time {
    [self saveUserDefault:time forKey:k_SHOUHUAN_UNBING_TIME];
}
+ (void)setShouHuanLastTimeSync:(NSString *)time {
    [self saveUserDefault:time forKey:k_SHOUHUAN_LAST_TIME_SYNC];
}
+ (void)setShouHuanBoundSteps:(NSInteger)steps {
    [self saveUserDefault:@(steps) forKey:k_SHOUHUAN_BOUND_STEPS];
}
+ (void)setShouHuanUnbingSteps:(NSString *)steps {
    [self saveUserDefault:steps forKey:k_SHOUHUAN_UNBING_STEPS];
}
+ (void)setShouHuanLastStepsSync:(NSString *)lastSteps {
    [self saveUserDefault:lastSteps forKey:k_SHOUHUAN_LAST_STEPS_SYNC];
}
+ (void)setUploadServerTime:(NSString *)time {
    [self saveUserDefault:time forKey:k_UPLOAD_TO_SERVER_TIME];
}

+ (NSString *)getShouHuanMacSddress {
    return [self getUserDefautForKey:k_SHOUHUAN_MAC_ADDRESS];
}
+ (NSString *)getShouHuanName {
    return [self getUserDefautForKey:k_SHOUHUAN_NAME];
}
+ (NSString *)getShouHuanUUID {
    return [self getUserDefautForKey:k_SHOUHUAN_UUID];
}
+ (NSString *)getShouHuanBoundTime {
    return [self getUserDefautForKey:k_SHOUHUAN_BOUND_TIME];
}
+ (NSString *)getShouHuanUnbingTime {
    return [self getUserDefautForKey:k_SHOUHUAN_UNBING_TIME];
}
+ (NSString *)getShouHuanLastTimeSync {
    return [self getUserDefautForKey:k_SHOUHUAN_LAST_TIME_SYNC];
}
+ (NSString *)getShouHuanBoundSteps {
    return [self getUserDefautForKey:k_SHOUHUAN_BOUND_STEPS];
}
+ (NSString *)getShouHuanUnbingSteps {
    return [self getUserDefautForKey:k_SHOUHUAN_UNBING_STEPS];
}
+ (NSInteger)getShouHuanLastStepsSync {
    NSInteger lastStepsSync = [[self getUserDefautForKey:k_SHOUHUAN_LAST_STEPS_SYNC] integerValue];
    return lastStepsSync;
}
+ (NSString *)getUploadServerTime {
    return [self getUserDefautForKey:k_UPLOAD_TO_SERVER_TIME];
}

#pragma mark - 数据库相关

+ (void)saveDataBaseVersion {
    [self saveUserDefault:@(k_VHS_DataBase_Version) forKey:k_VHS_DataBase_Version_Key];
}

+ (NSInteger)getDatabaseVersion {
    NSInteger version = [[self getUserDefautForKey:k_VHS_DataBase_Version_Key] integerValue];
    return version;
}

#pragma mark - 启动页相关

+ (void)saveLaunchUrl:(NSString *)url {
    NSString *defineUrl = url ? url : @"";
    [self saveUserDefault:[NSString stringWithFormat:@"%@", defineUrl] forKey:k_LaunchUrl];
}

+ (void)saveLaunchTime:(NSString *)time {
    NSString *defaultTime = time ? time : @"";
    [self saveUserDefault:defaultTime forKey:k_Launch_Time];
}

+ (void)saveDynamicTime:(NSString *)time {
    NSString *defaultTime = time ? time : @"";
    [self saveUserDefault:defaultTime forKey:k_Late_Show_Dynamic_Time];
}

+ (void)saveActivityTime:(NSString *)time {
    NSString *defaultTime = time ? time : @"";
    [self saveUserDefault:defaultTime forKey:k_Late_Show_Activity_Time];
}

+ (void)saveShopTime:(NSString *)time {
    NSString *defaultTime = time ? time : @"";
    [self saveUserDefault:defaultTime forKey:k_Late_Show_Shop_Time];
}

+ (void)saveBPushChannelId:(NSString *)channelId {
    [self saveUserDefault:channelId ? channelId : @"" forKey:k_BPush_Channel_id];
}

+ (NSString *)getChannelId {
    NSString *channelId = [self getUserDefautForKey:k_BPush_Channel_id];
    if (channelId) {
        return channelId;
    }
    return @"";
}

+ (BOOL)isLogined {
    NSString *token = [VHSCommon vhstoken];
    NSInteger logins = [[self getUserDefautForKey:k_LOGIN_NUMBERS] integerValue];
    if (![VHSCommon isNullString:token] && logins > 0) {
        return YES;
    }
    return NO;
}

+ (void)showADPageWithUrl:(NSString *)adUrl duration:(NSInteger)duration {
    
    if (duration == 0) return;
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    UIImageView *adImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:adImageView];
    
    [adImageView sd_setImageWithURL:[NSURL URLWithString:adUrl]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [adImageView removeFromSuperview];
    });
}

@end
