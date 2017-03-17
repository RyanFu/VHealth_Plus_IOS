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
#import "MomentPhotoModel.h"

@interface VHSCommentController ()<UITextViewDelegate>

@property (nonatomic, strong)   UILabel     *titleLabel;
@property (nonatomic, copy)     NSArray     *photosMomentItems;

@end

@implementation VHSCommentController

#pragma mark - override getter or setter

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLORHex(@"#EFEFF4");
    
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
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [bgView addSubview:self.titleLabel];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 30, 50, 24)];
    [backBtn setTitleColor:COLORHex(@"#828282") forState:UIControlStateNormal];
    [backBtn setTitle:@"关闭" forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:backBtn];

    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENW - 5 - 50, 30, 50, 24)];
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    if (self.commentType == VHSCommentOfMomentAnnouncementType || self.commentType == VHSCommentOfMomentUpdateAnnouncementType) {
        [rightBtn setTitle:@"发布" forState:UIControlStateNormal];
    } else if (self.commentType == VHSCommentOfMomentReplyPostType) {
        [rightBtn setTitle:@"发送" forState:UIControlStateNormal];
    }
    [rightBtn addTarget:self action:@selector(pulishAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:rightBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIAGTION_HEIGHT - 0.7, SCREENW, 0.7)];
    line.backgroundColor = COLORHex(@"#828282");
    [bgView addSubview:line];
}

- (void)backAction:(UIButton *)btn {
    [self dismissController];
}

- (void)dismissController {
    [self dismissViewControllerAnimated:YES completion:^{
        [k_NotificationCenter postNotificationName:k_NOTI_APP_PAGE_REFRESH object:nil];
    }];
}

- (void)pulishAction:(UIButton *)btn {
    
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    
    // 帖子回复/点赞: addClubbbsReply.htm  参数名:clubId,bbsId, replyType(1文字2点赞),replyContent(回复内容，点赞可不传)
    if (self.commentType == VHSCommentOfMomentReplyPostType) {
        message.path = URL_ADD_CLUB_BBS_REPLY;
        message.params = @{@"clubId" : self.clubId,
                           @"bbsId" : self.bbsId,
                           @"replyType" : @"1",
                           @"replyContent" : self.content};
        message.httpMethod = VHSNetworkPOST;
        
        [MBProgressHUD showMessage:TOAST_CLUB_REPLYING];
    } else if (self.commentType == VHSCommentOfMomentAnnouncementType){
        // 发布公告
        message.path = URL_ADD_CLUB_NOTICE;
        message.params = @{@"clubId" : self.clubId,
                           @"noticeContent" : self.content ? self.content : @""};
        message.httpMethod = VHSNetworkPOST;
        
        [MBProgressHUD showMessage:TOAST_CLUB_NOTICE_POSTING];
    } else if (self.commentType == VHSCommentOfMomentUpdateAnnouncementType) {
        message.path = URL_UP_CLUB_NOTICE;
        message.params = @{@"clubId" : self.clubId,
                           @"noticeId" : self.noticeId,
                           @"noticeContent" : self.content};
        message.httpMethod = VHSNetworkPOST;
    }
    
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        [MBProgressHUD hiddenHUD];
        [VHSToast toast:result[@"info"]];
        
        [self dismissController];
    } fail:^(NSError *error) {
        CLog(@"%@", error.description);
    }];
}

#pragma mark - 文本编辑框

- (void)initCommentView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIAGTION_HEIGHT, SCREENW, 120)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    CGFloat marginx = 10.0;
    
    UITextView *commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(marginx, 0, bgView.frame.size.width - marginx * 2, CGRectGetHeight(bgView.frame))];
    commentTextView.delegate = self;
    commentTextView.font = [UIFont systemFontOfSize:17];
    commentTextView.returnKeyType = UIReturnKeyDone;
    commentTextView.showsVerticalScrollIndicator = NO;
    
    [bgView addSubview:commentTextView];
    
    if (self.content) {
        commentTextView.text = self.content;
    } else {
        commentTextView.text = CONST_CLUB_MOMENT_POST_PLACEHOLDER;
        commentTextView.textColor = COLOR_TEXT_PLACEHOLDER;
    }
}

- (void)initImagePickerView {
    __weak typeof(self) weakSelf = self;
    // 自定义封装的图片选择器
    VHSImagePickerView *imagePickerView = [[VHSImagePickerView alloc] initWithFrame:CGRectMake(0, NAVIAGTION_HEIGHT + 140, SCREENW, 300)];
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
    [MBProgressHUD showMessage:TOAST_CLUB_BBS_POSTING];

    NSMutableArray *momentImageArray = [NSMutableArray new];
    for (MomentPhotoModel *moment in self.photosMomentItems) {
        [momentImageArray addObject:moment.photoImage];
    }
    
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_ADD_CLUB_BBS;
    message.params = @{@"bbsContent" : self.content ? self.content : @"",
                       @"clubId" : self.clubId};
    message.imageArray = momentImageArray;
    message.httpMethod = VHSNetworkUpload;
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        [MBProgressHUD hiddenHUD];
        [VHSToast toast:result[@"info"]];
        
        if ([result[@"result"] integerValue] != 200) return;
        
        [self dismissController];
    } fail:^(NSError *error) {
        CLog(@"%@", error.description);
    }];
}

- (void)handleSingleTouch {
    [self.view endEditing:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSString *text = textView.text;
    if ([CONST_CLUB_MOMENT_POST_PLACEHOLDER isEqualToString:text]) {
        textView.text = @"";
        textView.textColor = COLOR_TEXT;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSString *text = textView.text;
    if ([VHSCommon isNullString:text] || [text isEqualToString:CONST_CLUB_MOMENT_POST_PLACEHOLDER]) {
        textView.text = CONST_CLUB_MOMENT_POST_PLACEHOLDER;
        textView.textColor = COLOR_TEXT_PLACEHOLDER;
    } else {
        self.content = text;
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
