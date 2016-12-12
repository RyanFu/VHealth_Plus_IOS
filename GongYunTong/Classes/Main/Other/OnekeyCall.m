//
//  OnekeyCall.m
//  GongYunTong
//
//  Created by pingjun lin on 2016/12/10.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "OnekeyCall.h"
#import "XLAlertController.h"

@interface OnekeyCall ()

@property (nonatomic, strong) XLAlertController *alerter;

@end

@implementation OnekeyCall

- (instancetype)initWithPhone:(NSString *)phone {
    self = [super init];
    if (self) {
        NSString *attriPhone = [NSString stringWithFormat:@"\n%@\n",phone];
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:attriPhone];
        [title addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:28],
                               NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#4ec7ee"]}
                       range:NSMakeRange(0, title.length)];
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"\n好人生健康专家热线"
                                                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#212121"]}];
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"\n\n饮食 养生 运动 疾病防治 就医 用药 康复" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:COLORHex(@"#828282")}];
        [message appendAttributedString:content];
        
        XLAlertController *alert = [XLAlertController alertControllerWithAttributedTitle:title attributedMessage:message preferredStyle:UIAlertControllerStyleActionSheet];
        self.alerter = alert;
        
        XLAlertAction *call = [XLAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIApplication *app = [UIApplication sharedApplication];
            NSString *telUrl = [NSString stringWithFormat:@"tel://%@", phone];
            if ([app canOpenURL:[NSURL URLWithString:telUrl]]) {
                [app openURL:[NSURL URLWithString:telUrl]];
                
                [self recordPhoneCallWithPhoneNumber:phone];
            }
        }];
        XLAlertAction *cancel = [XLAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        call.titleColor = COLORHex(@"#212121");
        cancel.titleColor = COLORHex(@"#212121");
        [alert addAction:call];
        [alert addAction:cancel];
    }
    return self;
}

- (void)call {
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    [controller presentViewController:self.alerter animated:YES completion:nil];
}


#pragma mark - 记录拨打的电话号码

/// 记录拨打的电话号码
- (void)recordPhoneCallWithPhoneNumber:(NSString *)phoneNumber {
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
