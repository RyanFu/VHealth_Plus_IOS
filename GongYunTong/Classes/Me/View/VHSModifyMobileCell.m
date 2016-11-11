//
//  VHSModifyMobileCell.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/18.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "VHSModifyMobileCell.h"
#import "MBProgressHUD+VHS.h"
#import "UIButton+extension.h"

@interface VHSModifyMobileCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (weak, nonatomic) IBOutlet UIButton *gainAuthCodeBtn;

@end

@implementation VHSModifyMobileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textfield.delegate = self;
    [self.gainAuthCodeBtn addTarget:self action:@selector(gainAuthCodeClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    
    self.title.text = _titleStr;
}

- (void)setContentStr:(NSString *)contentStr {
    _contentStr = contentStr;
    if (_contentStr) {
        self.textfield.text = _contentStr;
    }
}

- (void)setModifyType:(ModifyType)modifyType {
    _modifyType = modifyType;
    
    if (_modifyType == ModifyPhoneType) {
        self.gainAuthCodeBtn.hidden = NO;
        self.title.text = @"手机号:";
        self.textfield.placeholder = @"请输入手机号";
        self.textfield.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if (_modifyType == ModifyAuthCodeType) {
        self.gainAuthCodeBtn.hidden = YES;
        self.title.text = @"验证码:";
        self.textfield.placeholder = @"请输入验证码";
        self.textfield.keyboardType = UIKeyboardTypeNumberPad;
    }
}

#pragma mark - btn click

- (void)gainAuthCodeClick:(UIButton *)authBtn {
    
    if (self.modifyType == ModifyPhoneType) {
        NSString *mobile = self.textfield.text;
        
        VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
        message.params = @{@"mobile" :  mobile};
        message.path = URL_GET_VERCODE;
        message.httpMethod = VHSNetworkPOST;
        [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
            if ([result[@"result"] integerValue] == 200) {
                [authBtn countDownWithSeconds:60];
                [MBProgressHUD showSuccess:@"验证码已经发送"];
            } else {
                [MBProgressHUD showError:result[@"info"]];
            }
        } fail:^(NSError *error) {}];
    }
}

#pragma mark -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.contentStr = textField.text;
    
    if (self.callback) {
        self.callback(self.contentStr);
    }
}

@end
