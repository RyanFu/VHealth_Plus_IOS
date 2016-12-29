//
//  OnekeyCall.m
//  GongYunTong
//
//  Created by pingjun lin on 2016/12/10.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "OneAlertCaller.h"
#import "XLAlertController.h"

@interface OneAlertCaller ()

@property (nonatomic, strong) UIAlertController *alerter;

@end

static NSString *onekeyTitle = @"好人生健康专家热线";
static NSString *onekeyContent = @"饮食 养生 运动 疾病防治 就医 用药 康复";

@implementation OneAlertCaller

- (instancetype)initWithPhone:(NSString *)phone {
    self = [super init];
    if (self) {
        [self setupWithPhone:phone title:onekeyTitle content:onekeyContent];
    }
    return self;
}

- (instancetype)initWithPhone:(NSString *)phone title:(NSString *)title content:(NSString *)content {
    self = [super init];
    if (self) {
        [self setupWithPhone:phone title:title content:content];
    }
    return self;
}

- (void)setupWithPhone:(NSString *)aphone title:(NSString *)atitle content:(NSString *)acontent {
    if ([VHSCommon isNullString:aphone]) {
        aphone = @"";
    }
    
    NSString *attriPhone = [NSString stringWithFormat:@"\n%@\n",aphone];
    NSMutableAttributedString *phone = [[NSMutableAttributedString alloc] initWithString:attriPhone];
    [phone addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:28],
                           NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#4ec7ee"]}
                   range:NSMakeRange(0, phone.length)];
    
    NSMutableAttributedString *message;
    
    if (![VHSCommon isNullString:atitle] && ![VHSCommon isNullString:acontent]) {
        NSString *dmessage = [NSString stringWithFormat:@"\n%@", atitle];
        message = [[NSMutableAttributedString alloc] initWithString:dmessage
                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#212121"]}];
        
        NSString *dconent = [NSString stringWithFormat:@"\n\n%@", acontent];
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:dconent
                                                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:COLORHex(@"#828282")}];
        [message appendAttributedString:content];
        
    }
    else if (![VHSCommon isNullString:atitle] && [VHSCommon isNullString:acontent]) {
        NSString *dmessage = [NSString stringWithFormat:@"\n%@", atitle];
        message = [[NSMutableAttributedString alloc] initWithString:dmessage
                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#212121"]}];
    }
    else if ([VHSCommon isNullString:atitle] && ![VHSCommon isNullString:acontent]) {
        NSString *dmessage = [NSString stringWithFormat:@"\n%@", acontent];
        message = [[NSMutableAttributedString alloc] initWithString:dmessage
                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#212121"]}];
    }
    else {
        message = [[NSMutableAttributedString alloc] initWithString:@""];
    }
    
    XLAlertController *alert = [XLAlertController alertControllerWithAttributedTitle:phone attributedMessage:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak typeof(self) weakSelf = self;
    XLAlertAction *call = [XLAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIApplication *app = [UIApplication sharedApplication];
        NSString *telUrl = [NSString stringWithFormat:@"tel://%@", aphone];
        if ([app canOpenURL:[NSURL URLWithString:telUrl]]) {
            [app openURL:[NSURL URLWithString:telUrl]];
            
            [weakSelf recordWithPhoneNumber:aphone];
        }
    }];
    XLAlertAction *cancel = [XLAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    call.titleColor = COLORHex(@"#212121");
    cancel.titleColor = COLORHex(@"#212121");
    [alert addAction:call];
    [alert addAction:cancel];
    
    self.alerter = alert;
}

- (instancetype)initWithContent:(NSString *)content forceUpgrade:(BOOL)isForce {
    self = [super init];
    if (self) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"版本更新" message:content preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不更新" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (isForce) { exit(0); }
        }];
        [alertVC addAction:cancelAction];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"马上更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 跳转到appStore
            [VHSCommon toAppStoreForUpgrade];
        }];
        [alertVC addAction:confirmAction];
        
        self.alerter = alertVC;
    }
    return self;
}

- (instancetype)initWithNormalPhone:(NSString *)phone {
    if (self = [super init]) {
        UIAlertController *callPhoneSheet = [UIAlertController alertControllerWithTitle:@"点击拨打客服电话"
                                                                                message:nil
                                                                         preferredStyle:UIAlertControllerStyleActionSheet];
        
        __weak typeof(self) weakSelf = self;
        UIAlertAction *callAction = [UIAlertAction actionWithTitle:phone style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *servicePhoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]];
            if ([[UIApplication sharedApplication] canOpenURL:servicePhoneUrl]) {
                [[UIApplication sharedApplication] openURL:servicePhoneUrl];
                
                [weakSelf recordWithPhoneNumber:phone];
            }
        }];
        UIAlertAction *cancleActionn = [UIAlertAction actionWithTitle:@"取消"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  CLog(@"取消");
                                                              }];
        [callPhoneSheet addAction:callAction];
        [callPhoneSheet addAction:cancleActionn];
        
        self.alerter = callPhoneSheet;
    }
    return self;
}

- (void)call {
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    [controller presentViewController:self.alerter animated:YES completion:nil];
}


#pragma mark - 记录拨打的电话号码

/// 记录拨打的电话号码
- (void)recordWithPhoneNumber:(NSString *)phoneNumber {
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_ADD_PHONE_CALL;
    message.params = @{@"callNo" : phoneNumber};
    message.httpMethod = VHSNetworkPOST;
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        CLog(@"%@", result);
    } fail:^(NSError *error) {
        CLog(@"%@", error.description);
    }];
}

#pragma mark - dalloc 

- (void)dealloc {
    CLog(@"delloc of OnekeyCall");
}

@end
