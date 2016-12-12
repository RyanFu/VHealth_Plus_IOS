//
//  VHSPasswordCell.m
//  GongYunTong
//
//  Created by ios-bert on 16/7/21.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSPasswordCell.h"

@interface VHSPasswordCell ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lbPassword;
@property (strong, nonatomic) IBOutlet UITextField *txfPassword;

@end

@implementation VHSPasswordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.txfPassword.delegate = self;
}
-(void)setModel:(VHSForgetInfo *)model
{
    _model = model;
    self.txfPassword.placeholder = model.placeholder;
    self.lbPassword.text = model.title;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *descsionString = @"";
    if ([VHSCommon isNullString:string]) {
        if ([VHSCommon isNullString:textField.text]) return NO;
        descsionString = [textField.text substringToIndex:textField.text.length - 1];
    } else {
        descsionString = [textField.text stringByAppendingString:string];
    }
    
    if (self.callBack) {
        self.callBack(descsionString);
    }
    return YES;
}

@end
