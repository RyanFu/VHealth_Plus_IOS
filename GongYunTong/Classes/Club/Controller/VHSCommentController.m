//
//  VHSCommentController.m
//  GongYunTong
//
//  Created by pingjun lin on 2017/2/6.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import "VHSCommentController.h"
#import "VHSImagePickerView.h"
#import "MBProgressHUD+VHS.h"

@interface VHSCommentController ()<UITextViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) NSArray *photosMomentItems;

@end

@implementation VHSCommentController

#pragma mark - override getter or setter

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self pretendNavigationBar];
    [self initCommentView];
    
    if (self.commentType == VHSCommentOfMomentPublishPostType) {
        [self initImagePickerView];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTouch)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 假扮Navigation Bar

- (void)pretendNavigationBar {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, NAVIAGTION_HEIGHT)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, SCREENW - 200, 44)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.text = self.title;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [bgView addSubview:self.titleLabel];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 60, 24)];
    [backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backBtn setTitleColor:COLORHex(@"#828282") forState:UIControlStateNormal];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:backBtn];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENW - 15 - 60, 30, 60, 24)];
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"发布" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(pulishAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:rightBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIAGTION_HEIGHT - 0.7, SCREENW, 0.7)];
    line.backgroundColor = COLORHex(@"#828282");
    [bgView addSubview:line];
}

- (void)backAction:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pulishAction:(UIButton *)btn {
    [VHSToast toast:@"发布"];
    CLog(@"-----%@", self.photosMomentItems);
}

#pragma mark - 文本编辑框

- (void)initCommentView {
    CGFloat marginx = 10.0;
    
    UITextView *commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(marginx, NAVIAGTION_HEIGHT, SCREENW - marginx * 2, 200)];
    commentTextView.delegate = self;
    commentTextView.font = [UIFont systemFontOfSize:17];
    commentTextView.returnKeyType = UIReturnKeyDone;
    commentTextView.showsVerticalScrollIndicator = NO;
    [commentTextView becomeFirstResponder];
    
    [self.view addSubview:commentTextView];
    
    commentTextView.text = CLUB_MOMENT_POST_PLACEHOLDER;
    commentTextView.textColor = COLOR_TEXT_PLACEHOLDER;
}

- (void)initImagePickerView {
    __weak typeof(self) weakSelf = self;
    // 自定义封装的图片选择器
    VHSImagePickerView *imagePickerView = [[VHSImagePickerView alloc] initWithFrame:CGRectMake(0, 210, SCREENW, 300)];
    imagePickerView.fatherController = self;
    imagePickerView.imagePickerCompletionHandler = ^(NSArray *photoMomentItems){
        weakSelf.photosMomentItems = photoMomentItems;
    };
    [self.view addSubview:imagePickerView];
    
    UIButton *publishBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREENH - 50, SCREENW, 50)];
    [publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    [publishBtn setBackgroundColor:COLORHex(@"#de5454")];
    [publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [publishBtn addTarget:self action:@selector(publishPostAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:publishBtn];
}

// 帖子发布按钮
- (void)publishPostAction:(UIButton *)btn {
    // 网络请求
    [MBProgressHUD showMessage:@"帖子发送中"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hiddenHUD];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)handleSingleTouch {
    [self.view endEditing:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSString *text = textView.text;
    if ([CLUB_MOMENT_POST_PLACEHOLDER isEqualToString:text]) {
        textView.text = @"";
        textView.textColor = COLOR_TEXT;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSString *text = textView.text;
    if ([VHSCommon isNullString:text] || [text isEqualToString:CLUB_MOMENT_POST_PLACEHOLDER]) {
        textView.text = CLUB_MOMENT_POST_PLACEHOLDER;
        textView.textColor = COLOR_TEXT_PLACEHOLDER;
    }
}

// 实现点击回车收起键盘
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)dealloc {
    CLog(@"VHSCommentController be dealloc");
}

@end
