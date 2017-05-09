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

static NSString *const onekeyTitle = @"好人生健康专家热线";
//static NSString *const onekeyContent = @"饮食 养生 运动 疾病防治 就医 用药 康复";
static NSString *const onekeyContent = @"由好人生健康风险管理专家解答饮食、养生、运动、疾病防治、就医、用药、康复等方面的健康困惑，或预约好人生心理咨询专家，共同应对职场压力、婚恋情感、情绪管理、人际关系、亲子家庭等各类心理困惑。";

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
        aphone = @"400-620-1800";
    }
    
    NSString *attriPhone = [NSString stringWithFormat:@"\n%@\n",aphone];
    NSMutableAttributedString *phone = [[NSMutableAttributedString alloc] initWithString:attriPhone];
    [phone addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:28],
                           NSForegroundColorAttributeName:COLORHex(@"#4ec7ee")}
                   range:NSMakeRange(0, phone.length)];
    
    NSMutableAttributedString *message;
    
    if (![VHSCommon isNullString:atitle] && ![VHSCommon isNullString:acontent]) {
        NSString *dmessage = [NSString stringWithFormat:@"\n%@", atitle];
        message = [[NSMutableAttributedString alloc] initWithString:dmessage
                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:COLORHex(@"#212121")}];
        
        NSString *dconent = [NSString stringWithFormat:@"\n\n%@", acontent];
        NSMutableAttributedString *attributedContent = [[NSMutableAttributedString alloc] initWithString:dconent
                                                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:COLORHex(@"#828282")}];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8.0];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        [attributedContent addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [dconent length])];
        
        [message appendAttributedString:attributedContent];
        
    }
    else if (![VHSCommon isNullString:atitle] && [VHSCommon isNullString:acontent]) {
        NSString *dmessage = [NSString stringWithFormat:@"\n%@", atitle];
        message = [[NSMutableAttributedString alloc] initWithString:dmessage
                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:COLORHex(@"212121")}];
    }
    else if ([VHSCommon isNullString:atitle] && ![VHSCommon isNullString:acontent]) {
        NSString *dmessage = [NSString stringWithFormat:@"\n%@", acontent];
        message = [[NSMutableAttributedString alloc] initWithString:dmessage
                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:COLORHex(@"#212121")}];
    }
    else {
        message = [[NSMutableAttributedString alloc] initWithString:@""];
    }
    
    XLAlertController *alert = [XLAlertController alertControllerWithAttributedTitle:phone attributedMessage:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    @WeakObj(self);
    XLAlertAction *call = [XLAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIApplication *app = [UIApplication sharedApplication];
        NSString *telUrl = [NSString stringWithFormat:@"tel://%@", aphone];
        if ([app canOpenURL:[NSURL URLWithString:telUrl]]) {
            [app openURL:[NSURL URLWithString:telUrl]];
            
            [selfWeak recordWithPhoneNumber:aphone];
        }
    }];
    XLAlertAction *cancel = [XLAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    call.titleColor = COLORHex(@"#2292DD");
    cancel.titleColor = COLORHex(@"#828282");
    [alert addAction:call];
    [alert addAction:cancel];
    
    self.alerter = alert;
}

- (instancetype)initWithContent:(NSString *)content forceUpgrade:(BOOL)isForce downloadUrl:(NSString *)loadUrl {
    self = [super init];
    if (self) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"版本更新" message:content preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不更新" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (isForce) exit(0);
        }];
        [alertVC addAction:cancelAction];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"马上更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [VHSCommon openWindowWithUrl:loadUrl];
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
        
        @WeakObj(self);
        UIAlertAction *callAction = [UIAlertAction actionWithTitle:phone style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *servicePhoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]];
            if ([[UIApplication sharedApplication] canOpenURL:servicePhoneUrl]) {
                [[UIApplication sharedApplication] openURL:servicePhoneUrl];
                
                [selfWeak recordWithPhoneNumber:phone];
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
