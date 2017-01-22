//
//  ChatController.m
//  CAAdvancedTech
//
//  Created by pingjun lin on 2017/1/10.
//  Copyright © 2017年 pingjun lin. All rights reserved.
//

#import "VHSChatController.h"
#import "VHSReddotButton.h"
#import "KxMenu.h"
#import "PublicWKWebViewController.h"
#import "ChatMoreModel.h"
#import "VHSMoreMenu.h"

@interface VHSChatController ()

@property (nonatomic, strong) NSMutableArray *moreMenuItems;

@property (nonatomic, strong) VHSMoreMenu *moreMenu;

@end

@implementation VHSChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.conversationMessageCollectionView.backgroundColor = [UIColor yellowColor];
    
    /// 超过一个屏幕的显示，右上角显示未读消息数
    self.enableUnreadMessageIcon = YES;
    /// 右下角的未读消息数提示
    self.enableNewComingMessageIcon = NO;
    
    /// 自定义输入面板
    [self setupPluginBoardView];
    /// 自定义导航栏
    [self setupNavigationBarBtn];

//    [self registerClass:[SimpleMessageCell class] forMessageClass:[SimpleMessage class]];
//    [self registerClass:[SimpleMessageCell class] forCellWithReuseIdentifier:@"SimpleMessageCell"];
    
    /// 显示聊天上方的公告栏
    [self showNoticeBoard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 自定义输入面板

- (void)setupPluginBoardView {
    RCPluginBoardView *pluginBoardView = self.chatSessionInputBarControl.pluginBoardView;
    [pluginBoardView insertItemWithImage:[UIImage imageNamed:@"icon_onlogin"]
                                   title:@"公告"
                                     tag:20000];
}

-(void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag {
    [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];

    if (tag == 20000) {
        NSLog(@"自定义输入面板事件回调");
        
//        RCMessageContent *msgContent = [[RCMessageContent alloc] init];
//        msgContent.senderUserInfo = [[RCUserInfo alloc] initWithUserId:@"10012" name:@"jjjj" portrait:nil];
//        msgContent.mentionedInfo = [[RCMentionedInfo alloc] initWithMentionedType:RC_Mentioned_All
//                                                                       userIdList:@[@"10012"]
//                                                                 mentionedContent:@"起床了"];
//        [self sendMessage:msgContent pushContent:@"啊啊啊啊"];
        
        PublicWKWebViewController *noticeBoardWebVC = [[PublicWKWebViewController alloc] init];
        noticeBoardWebVC.title = @"公告";
        noticeBoardWebVC.urlString = @"https://www.baidu.com/";
        [self.navigationController pushViewController:noticeBoardWebVC animated:YES];
    }
}

#pragma mark - 消息将要显示的时候调用

- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[RCTextMessageCell class]]) {
        RCTextMessageCell *textMsgCell = (RCTextMessageCell *)cell;
        textMsgCell.textLabel.textColor = [UIColor redColor];
    }
}

#pragma mark - 自定义NavigationBarBtn

- (void)setupNavigationBarBtn {
    VHSReddotButton *moreBtn = [[VHSReddotButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [moreBtn setBackgroundColor:[UIColor whiteColor]];
    [moreBtn addTarget:self action:@selector(actionRorMore:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
}

- (void)actionRorMore:(UIButton *)navBtn {
    VHSReddotButton *reddotBtn = (VHSReddotButton *)navBtn;
    reddotBtn.isShowReddot = NO;
    
    [self showMoreMenu];
}

#pragma mark - "更多"弹出层

- (void)remoteMoreInfo {
    VHSRequestMessage *msg = [[VHSRequestMessage alloc] init];
    msg.httpMethod = VHSNetworkPOST;
    msg.params = @{};
    msg.path = @"";
    
    [[VHSHttpEngine sharedInstance] sendMessage:msg success:^(id result) {
        
    } fail:^(NSError *error) {
        
    }];
}

- (NSMutableArray *)moreMenuItems {
    if (!_moreMenuItems) {
        _moreMenuItems = [NSMutableArray arrayWithCapacity:4];
        
        for (NSInteger i = 0; i < 5; i++) {
            ChatMoreModel *more = [[ChatMoreModel alloc] init];
            
            switch (i) {
                case 0:
                    more.title = @"公告";
                    more.isRead = NO;
                    break;
                case 1:
                    more.title = @"新成员申请";
                    more.isRead = NO;
                    break;
                case 2:
                    more.title = @"俱乐部简介";
                    more.isRead = YES;
                    break;
                case 3:
                    more.title = @"俱乐部成员";
                    more.isRead = NO;
                    break;
                case 4:
                    more.title = @"退出俱乐部";
                    more.isRead = YES;
                    break;
                    
                default:
                    break;
            }
            
            [_moreMenuItems addObject:more];
        }
    }
    return _moreMenuItems;
}

- (void)showMoreMenu {
    [VHSMoreMenu showMoreMenuWithMenuList:self.moreMenuItems tapItemBlock:^(ChatMoreModel *model) {
        PublicWKWebViewController *webVC = [[PublicWKWebViewController alloc] init];
        webVC.title = model.title;
        webVC.urlString = @"https://www.baidu.com/";
        if (model.moreType == ChatMoreType_Card) {
            // 帖子
        }
        else if (model.moreType == ChatMoreType_NewMemberApply) {
            // 新用户申请
        }
        else if (model.moreType == ChatMoreType_ClubIntro) {
            // 俱乐部简介
        }
        else if (model.moreType == ChatMoreType_ClubMember) {
            // 俱乐部成员
        }
        else if (model.moreType == ChatMoreType_QuitClub) {
            // 退出俱乐部
        }
        [self.navigationController pushViewController:webVC animated:YES];
    }];
}


#pragma mark - 显示"公告"

- (void)remoteNoticeBoard {
    VHSRequestMessage *msg = [[VHSRequestMessage alloc] init];
    msg.path = @"";
    msg.params = @{};
    msg.httpMethod = VHSNetworkPOST;
    
    [[VHSHttpEngine sharedInstance] sendMessage:msg success:^(id result) {
        
    } fail:^(NSError *error) {
        
    }];
}

- (void)showNoticeBoard {
    UIView *noticeBoardBg = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIAGTION_HEIGHT, SCREENW, 35)];
    noticeBoardBg.backgroundColor = COLORHex(@"#99d5fd");
    noticeBoardBg.userInteractionEnabled = YES;
    [self.view addSubview:noticeBoardBg];
    
    UILabel *noticeBoardLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(noticeBoardBg.frame) - 44 - 10, CGRectGetHeight(noticeBoardBg.frame))];
    noticeBoardLabel.text = @"公告:6月1号儿童节，大家都带你的娃娃过来喝稀饭";
    [noticeBoardBg addSubview:noticeBoardLabel];
    
    UIImageView *noticeBoardNav = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(noticeBoardLabel.frame) + 10, (CGRectGetHeight(noticeBoardBg.frame) - 24) / 2.0, 24, 24)];
    noticeBoardNav.image = [UIImage imageNamed:@"discover_club_navigation_arrow_right"];
    [noticeBoardBg addSubview:noticeBoardNav];

    [self.view bringSubviewToFront:noticeBoardBg];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOfNoticeBoard:)];
    [noticeBoardBg addGestureRecognizer:tap];
}

- (void)tapOfNoticeBoard:(UIGestureRecognizer *)tap {
    PublicWKWebViewController *noticeBoardWeb = [[PublicWKWebViewController alloc] init];
    noticeBoardWeb.title = @"公告";
    noticeBoardWeb.urlString = @"https://www.baidu.com/";
    [self.navigationController pushViewController:noticeBoardWeb animated:YES];
}

@end
