//
//  VHSUntils.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/3.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSUtils.h"
#import "GTMBase64.h"

@implementation VHSUtils

+ (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%c", digest[i]];
    }
    return output;
}

+ (NSString *)md5_base64:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), digest );
    
    NSData * base64 = [[NSData alloc] initWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    base64 = [GTMBase64 encodeData:base64];
    
    NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
    return output;
}

+ (BOOL)validateSimplePhone:(NSString *)phone
{
    NSString *phoneRegex = @"1[3|5|7|8|][0-9]{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//正则判断手机号码格式
+ (BOOL)validatePhone:(NSString *)phone
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:phone] == YES)
        || ([regextestcm evaluateWithObject:phone] == YES)
        || ([regextestct evaluateWithObject:phone] == YES)
        || ([regextestcu evaluateWithObject:phone] == YES))
    {
        if([regextestcm evaluateWithObject:phone] == YES) {
            NSLog(@"China Mobile");
        } else if([regextestct evaluateWithObject:phone] == YES) {
            NSLog(@"China Telecom");
        } else if ([regextestcu evaluateWithObject:phone] == YES) {
            NSLog(@"China Unicom");
        } else {
            NSLog(@"Unknow");
        }
        
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSString *)formatterMobile:(NSString *)mobile {
    if (mobile.length != 10) return mobile;
    
    NSInteger segments = [[mobile componentsSeparatedByString:@"-"] count];
    if (segments > 1) return mobile;
    
    NSMutableString *formatMobile = [NSMutableString string];
    
    NSRange range = NSMakeRange(0, 3);
    for (NSInteger i = 0; i < 3; i++) {
        if (i < 2) {
            [formatMobile appendFormat:@"%@-", [mobile substringWithRange:range]];
        } else {
            [formatMobile appendFormat:@"%@", [mobile substringWithRange:range]];
        }
        range.location = (i + 1) * 3;
        if (i == 1) {
            range.length = 4;
        }
    }
    return [formatMobile copy];
}

+ (NSString *)absolutelyString:(NSString *)originString {
    return [NSString stringWithFormat:@"%@", [originString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}

+ (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  将图片缩放到指定的CGSize大小
 *  UIImage image 原始的图片
 *  CGSize size 要缩放到的大小
 */
+ (UIImage *)image:(UIImage *)image scaleToSize:(CGSize)size {
    // 得到图片上下文，指定绘制范围，会导致图片的的分辨率出现问题
//    UIGraphicsBeginImageContext(size);
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    // 将图片按照指定大小绘制
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前图片上下文中导出图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 当前图片上下文出栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

/**
 *  异步下载图片，存储到沙盒路径汇总
 */
+ (BOOL)saveImageWithPath:(NSString *)urlPath {
    NSString *keyPath = [VHSUtils md5:urlPath];
    
    // 获取沙盒路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *imagePath = [path stringByAppendingPathComponent:keyPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        CLog(@"需要下载的图片文件路径已经存在");
        return YES;
    }
    
    // 异步下载图片
    __block BOOL isSuccess = NO;
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlPath]];
        UIImage *image = [UIImage imageWithData:data];
       
        // 根据图片的地址保存图片
        isSuccess = [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
        
        CLog(@"下载图片 %@ - %@", isSuccess ? @"成功" : @"失败", imagePath);
    });
    return isSuccess;
}

+ (NSString *)getLocalPathWithPath:(NSString *)urlPath {
    NSString *keyPath = [VHSUtils md5:urlPath];
    
    NSString *sandPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [sandPath stringByAppendingPathComponent:keyPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return filePath;
    }
    return @"";
}

+ (NSString *)generateRandomStr16 {
    NSArray *chars = @[@"1",@"q",@"a",@"z",@"2",@"w",@"s",@"x",
                       @"Q",@"A",@"Z",@"W",@"S",@"X",@"E",@"D",
                       @"3",@"e",@"d",@"c",@"4",@"r",@"f",@"v",
                       @"X",@"R",@"F",@"V",@"T",@"G",@"B",@"Y",
                       @"5",@"t",@"g",@"b",@"6",@"y",@"h",@"n",
                       @"J",@"M",@"I",@"K",@"O",@"L",@"P",@"+",
                       @"7",@"u",@"j",@"m",@"8",@"k",@"<",@"9",
                       @"o",@"l",@">",@"!",@"@",@"#",@"$",@"%",@"^",@"&"];
    
    NSMutableArray *desStrList = [NSMutableArray arrayWithCapacity:16];
    for (NSInteger i = 0; i < 16; i++) {
        NSInteger rac = arc4random() % [chars count];
        [desStrList addObject:chars[rac]];
    }
    NSString *res = [desStrList componentsJoinedByString:@""];

    return res;
}

+ (void)smartJumpWithUrlString:(NSString *)urlString completionHandler:(void (^)(NSString *url))urlCompletionHandler {
    NSString *trimmedString = [urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!trimmedString || !trimmedString.length) {
        if (urlCompletionHandler) {
            urlCompletionHandler(nil);
        }
        return;
    }
    
    NSURL *result = nil;
    if ([trimmedString containsString:@"http"] || [trimmedString containsString:@"https"]) {
        result = [NSURL URLWithString:trimmedString];
    } else {
        if (urlCompletionHandler) {
            urlCompletionHandler(nil);
        }
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:result];
    [request setHTTPMethod:@"HEAD"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (urlCompletionHandler) urlCompletionHandler(result.absoluteString);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (urlCompletionHandler) urlCompletionHandler(nil);
            });
        }
    }];
    [task resume];
}

+ (UIViewController *)getCurrentController {
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (YES) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController *)vc).selectedViewController;
        } else if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController *)vc).visibleViewController;
        }
        if ([vc isKindOfClass:[UITabBarController class]] || [vc isKindOfClass:[UINavigationController class]]) {
            continue;
        }
        
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        } else {
            break;
        }
    }
    return vc;
}

@end
