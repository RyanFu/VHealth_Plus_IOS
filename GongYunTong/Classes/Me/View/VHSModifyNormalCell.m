//
//  VHSModifyNormalCell.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/18.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSModifyNormalCell.h"

@interface VHSModifyNormalCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation VHSModifyNormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textField.delegate = self;
}

- (void)setContent:(NSString *)content {
    _content = content;
    if (_content) {
        self.textField.text = _content;
    }
}

#pragma mark - 

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.content = textField.text;
    
    if (self.callback) {
        self.callback(self.content);
    }
}

@end
