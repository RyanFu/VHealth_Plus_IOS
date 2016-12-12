//
//  VHSQuestionPhoneCell.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/2.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSQuestionPhoneCell.h"

@interface VHSQuestionPhoneCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *feedbackPhoneTextField;

@end

@implementation VHSQuestionPhoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.feedbackPhoneTextField.delegate = self;
    
}

- (void)setPhoneNumberStr:(NSString *)phoneNumberStr {
    _phoneNumberStr = phoneNumberStr;
    
    self.feedbackPhoneTextField.text = _phoneNumberStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.callBack) {
        self.callBack(textField.text);
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

@end
