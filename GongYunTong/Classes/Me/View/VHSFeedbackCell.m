//
//  VHSFeedbackCell.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/2.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "VHSFeedbackCell.h"

@interface VHSFeedbackCell ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *questionDecriptionTextView;

@end

@implementation VHSFeedbackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.questionDecriptionTextView.returnKeyType = UIReturnKeyDone;
    self.questionDecriptionTextView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    
    _placeHolder = placeHolder;
    
    if (self.questionDecriptionTextView.text.length == 0) {
        self.questionDecriptionTextView.textColor = COLOR_TEXT_PLACEHOLDER;
        if (_placeHolder == nil || _placeHolder.length == 0) {
            self.questionDecriptionTextView.text = @"问题描述";
        } else {
            self.questionDecriptionTextView.text = _placeHolder;
        }
    }
}

- (void)setContent:(NSString *)content {
    _content = content;
    
    if ([VHSCommon isNullString:_content] || [_content isEqualToString:@"问题描述"]) {
        self.questionDecriptionTextView.text = @"问题描述";
        self.questionDecriptionTextView.textColor = COLOR_TEXT_PLACEHOLDER;
    } else {
        self.questionDecriptionTextView.textColor = COLOR_TEXT;
        self.questionDecriptionTextView.text = _content;
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    textView.textColor = COLOR_TEXT;
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    NSString *text = textView.text;
    NSString *trimString = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([trimString isEqualToString:@"问题描述"]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    NSString *text = textView.text;
    NSString *trimString = [VHSUntils absolutelyString:text];
    if ([trimString length] == 0 || [trimString isEqualToString:@""] || !trimString) {
        if (!_placeHolder) {
            textView.text = @"问题描述";
        } else {
            textView.text = _placeHolder;
        }
        textView.textColor = COLOR_TEXT_PLACEHOLDER;
    }
    
    if (self.callBack) {
        self.callBack(textView.text);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

@end
