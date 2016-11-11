//
//  VHSPhoneNumberCell.m
//  GongYunTong
//
//  Created by ios-bert on 16/7/21.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "VHSPhoneNumberCell.h"
#import "MBProgressHUD+VHS.h"
#import "UIButton+extension.h"

@interface VHSPhoneNumberCell () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField  *phoneTextField;
@property (strong, nonatomic) IBOutlet UILabel      *phoneLabel;

@end

@implementation VHSPhoneNumberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.phoneTextField.delegate = self;

}
-(void)setModel:(VHSForgetInfo *)model
{
    _model = model;
    self.phoneLabel.text = model.title;
    self.phoneTextField.placeholder = model.placeholder;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)obtainVCode:(UIButton *)sender {
    
    if (![VHSCommon isNetworkAvailable]) {
        [VHSToast toast:TOAST_NO_NETWORK];
        return;
    }
    
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_GET_VERCODE;
    message.params = @{@"mobile" : self.phoneTextField.text};
    message.httpMethod = VHSNetworkPOST;
    
    if (self.callBack) {
        self.callBack(self.phoneTextField.text);
    }
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary * result) {
        if ([result[@"result"] integerValue] == 200){
            [sender countDownWithSeconds:60];
        } else {
             [MBProgressHUD showError:result[@"info"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"error = %@", error);
    }];
}

@end
