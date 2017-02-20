//
//  NSString+VHSExtension.m
//  GongYunTong
//
//  Created by pingjun lin on 2016/11/18.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "NSString+extension.h"

@implementation NSString (extension)

- (id)convertObject {
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}

- (CGSize)computerWithSize:(CGSize)size font:(UIFont *)font  {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    CGRect rect = [self boundingRectWithSize:size
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attrs
                                     context:nil];
    return rect.size;
}

@end
