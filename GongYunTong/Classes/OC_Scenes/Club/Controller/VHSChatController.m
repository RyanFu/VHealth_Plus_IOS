//
//  ChatController.m
//  CAAdvancedTech
//
//  Created by pingjun lin on 2017/1/10.
//  Copyright © 2017年 pingjun lin. All rights reserved.
//

#import "VHSChatController.h"
#import "VHSReddotButton.h"
#import "PublicWKWebViewController.h"
#import "ChatMoreModel.h"
#import "VHSMoreMenu.h"
#import "VHSCommentController.h"
#import "ClubMember.h"

@interface VHSChatController ()<RCIMGroupMemberDataSource>

@property (nonatomic, strong) NSMutableArray<ChatMoreModel *> *moreMenuItems;
@property (nonatomic, strong) NSArray<NSDictionary *> *clubMemberList;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *latestNoticeMsg;

@property (nonatomic, strong) VHSMoreMenu *moreMenu;

@property (nonatomic, strong) UIView *noticeBoardBg;    // 显示最新公告
@property (nonatomic, assign) BOOL showNotice;         // 点击公告列表

@end

@implementation VHSChatController

#pragma mark - view contrller life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.conversationMessageCollectionView.backgroundColor = [UIColor yellowColor];
    
    /// 超过一个屏幕的显示，右上角显示未读消息数
    self.enableUnreadMessageIcon = YES;
    /// 右下角的未读消息数提示
    self.enableNewComingMessageIcon = NO;
    
    /// 开启消息@提醒功能
    if (self.conversationType == ConversationType_GROUP || self.conversationType == ConversationType_DISCUSSION) {
        
    }
    
    // 消息撤回的功能--默认120s
//    [RCIM sharedRCIM].enableMessageRecall = YES;
    
    [RCIM sharedRCIM].globalNavigationBarTintColor = [UIColor redColor];
    
    /// 自定义输入面板
    [self setupPluginBoardView];
    /// 自定义导航栏
    [self setupNavigationBarBtn];
    
    /// 获取俱乐部成员列表
    [self remoteClubMemberList];
    /// 获取更多列表
    [self remoteMoreInfo];
    // 获取最新公告
    [self remoteLatestNotice];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[RCIM sharedRCIM] setGroupMemberDataSource:self];
    [[RCIM sharedRCIM] setEnableMessageMentioned:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

/// 获取俱乐部成员列表
- (void)remoteClubMemberList {
    /// memberType : 1 管理员，memberType : 2 成员
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_GET_CLUB_MEMBER_LIST;
    message.params = @{@"rongGroupId" : self.club.rongGroupId,
                       @"currentPageNum" : @"1",
                       @"everyPageNum" : @"500"};
    message.httpMethod = VHSNetworkPOST;
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] != 200) return;
        
        self.clubMemberList = [NSArray arrayWithArray:result[@"clubMemberList"]];
        [VHSCommon saveUserDefault:self.clubMemberList forKey:k_CLUB_MEMBERS_LIST];
        
    } fail:^(NSError *error) {
        CLog(@"%@", error.description);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 自定义输入面板

- (void)setupPluginBoardView {
    if ([self.club.memberType isEqualToString:@"1"]) {
        RCPluginBoardView *pluginBoardView = self.chatSessionInputBarControl.pluginBoardView;
        [pluginBoardView insertItemWithImage:[UIImage imageNamed:@"club_chat_board_notice_add"]
                                       title:@"公告"
                                         tag:20000];
    }
}

-(void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag {
    [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];

    // 发公告
    if (tag == 20000) {
        VHSCommentController *commentVC = [[VHSCommentController alloc] init];
        commentVC.title = @"公告";
        commentVC.clubId = _club.clubId;
        commentVC.commentType = VHSCommentOfMomentAnnouncementType;
        [self presentViewController:commentVC animated:YES completion:nil];
    }
}

#pragma mark - 消息将要显示的时候调用

/// 定制消息显示
- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[RCTextMessageCell class]]) {
//        RCTextMessageCell *textMsgCell = (RCTextMessageCell *)cell;
//        textMsgCell.textLabel.textColor = [UIColor redColor];
    }
}

#pragma mark - 自定义NavigationBarBtn

- (void)setupNavigationBarBtn {
    VHSReddotButton *moreBtn = [[VHSReddotButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [moreBtn setBackgroundColor:[UIColor whiteColor]];
    [moreBtn addTarget:self action:@selector(actionRorMore:) forControlEvents:UIControlEventTouchUpInside];
    moreBtn.isShowReddot = NO;
    
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
    msg.params = @{@"clubId" : self.club.clubId};
    msg.path = URL_GET_CLUB_MORE;
    
    [[VHSHttpEngine sharedInstance] sendMessage:msg success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] != 200) return;
        
        for (NSDictionary *dict in result[@"moreList"]) {
            ChatMoreModel *model = [ChatMoreModel yy_modelWithDictionary:dict];
            [self.moreMenuItems addObject:model];
        }
    } fail:^(NSError *error) {
        CLog(@"%@", error.description);
    }];
}

- (NSMutableArray<ChatMoreModel *> *)moreMenuItems {
    if (!_moreMenuItems) {
        _moreMenuItems = [NSMutableArray arrayWithCapacity:5];
    }
    return _moreMenuItems;
}

- (void)showMoreMenu {
    [self.view endEditing:YES];
    
    @WeakObj(self);
    [VHSMoreMenu showMoreMenuWithMenuList:self.moreMenuItems tapItemBlock:^(ChatMoreModel *model) {
        if ([model.moreType isEqualToString:@"url"]) {
            PublicWKWebViewController *webVC = [[PublicWKWebViewController alloc] init];
            webVC.urlString = model.url;
            webVC.showTitle = YES;
            webVC.showTitleLevel = 2;
            [selfWeak.navigationController pushViewController:webVC animated:YES];
            
            if ([model.moreName isEqualToString:@"公告"]) {
                selfWeak.showNotice = NO;
                [selfWeak judgeNeedShowLatestNotice];
            }
        }
        else if ([model.moreType isEqualToString:@"localQuit"]) {
            [VHSAlertController alertMessage:CONST_CLUB_CONFIRM_DO_QUIT title:CONST_PROMPT_MESSAGE confirmHandler:^(UIAlertAction *action) {
                [selfWeak doQuitClub];
            } cancleHandler:^(UIAlertAction *action) {}];
        }
    }];
}

- (void)doQuitClub {
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_DO_CLUB_QUIT;
    message.params = @{@"clubId" : self.club.clubId};
    message.httpMethod = VHSNetworkPOST;
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary  *result) {
        [VHSToast toast:result[@"info"]];
        
        if ([result[@"result"] integerValue] != 200) return;
        
        if (self.clubChatCallBack) self.clubChatCallBack(self.club);
        
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^(NSError *error) {
        CLog(@"%@", error.description);
    }];
}

#pragma mark - 显示"公告"
/// 获取最新公告
- (void)remoteLatestNotice {
    VHSRequestMessage *msg = [[VHSRequestMessage alloc] init];
    msg.path = URL_GET_NEW_CLUB_NOTICE;
    msg.params = @{@"clubId" : self.club.clubId};
    msg.httpMethod = VHSNetworkPOST;
    
    //noticeId,noticeContent,noticeUrl
    [[VHSHttpEngine sharedInstance] sendMessage:msg success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] != 200) return;
        
        self.latestNoticeMsg = [NSMutableDictionary dictionaryWithCapacity:3];
        [self.latestNoticeMsg setObject:result[@"noticeId"] forKey:@"noticeId"];
        [self.latestNoticeMsg setObject:result[@"noticeContent"] forKey:@"noticeContent"];
        [self.latestNoticeMsg setObject:result[@"noticeUrl"] forKey:@"noticeUrl"];
        
        if (![VHSCommon isNullString:result[@"noticeContent"]]) {
            self.showNotice = YES;
        }
        
        [self judgeNeedShowLatestNotice];
    } fail:^(NSError *error) {}];
}

- (UIView *)noticeBoardBg {
    if (!_noticeBoardBg) {
        _noticeBoardBg = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIAGTION_HEIGHT, SCREENW, 35)];;
    }
    return _noticeBoardBg;
}

/// 显示最新公告
- (void)judgeNeedShowLatestNotice {
    if (self.showNotice) {
        self.noticeBoardBg.backgroundColor = COLORHex(@"#99d5fd");
        self.noticeBoardBg.userInteractionEnabled = YES;
        [self.view addSubview:self.noticeBoardBg];
        
        UILabel *noticeBoardLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(_noticeBoardBg.frame) - 44 - 10, CGRectGetHeight(self.noticeBoardBg.frame))];
        NSString *noticeContent = self.latestNoticeMsg[@"noticeContent"];
        if (noticeContent) {
            noticeContent = [NSString stringWithFormat:@"公告: %@", noticeContent];
        } else {
            noticeContent = [NSString stringWithFormat:@"公告: 暂无"];
        }
        noticeBoardLabel.text = noticeContent;
        [self.noticeBoardBg addSubview:noticeBoardLabel];
        
        UIImageView *noticeBoardNav = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(noticeBoardLabel.frame) + 20, (CGRectGetHeight(self.noticeBoardBg.frame) - 20) / 2.0, 11, 20)];
        noticeBoardNav.image = [UIImage imageNamed:@"discover_club_navigation_arrow_right"];
        [self.noticeBoardBg addSubview:noticeBoardNav];
        
        [self.view bringSubviewToFront:self.noticeBoardBg];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLatestNotice:)];
        [self.noticeBoardBg addGestureRecognizer:tap];
        
        CGRect frame = self.conversationMessageCollectionView.frame;
        CGFloat nowY = NAVIAGTION_HEIGHT + 35;
        CGFloat nowX = frame.origin.x;
        CGFloat nowW = frame.size.width;
        CGFloat nowH = SCREENH - NAVIAGTION_HEIGHT - 35 - TABBAR_HEIGHT;
        
        self.conversationMessageCollectionView.frame = CGRectMake(nowX, nowY, nowW, nowH);
    } else {
        [self.noticeBoardBg removeFromSuperview];
        
        CGRect frame = self.conversationMessageCollectionView.frame;
        CGFloat nowX = frame.origin.x;
        CGFloat nowY = NAVIAGTION_HEIGHT;
        CGFloat nowW = frame.size.width;
        CGFloat nowH = SCREENH - NAVIAGTION_HEIGHT - TABBAR_HEIGHT;
        
        self.conversationMessageCollectionView.frame = CGRectMake(nowX, nowY, nowW, nowH);
    }
}

// 公告列表 -> 编辑公告
- (void)tapLatestNotice:(UIGestureRecognizer *)tap {
    PublicWKWebViewController *webVC = [[PublicWKWebViewController alloc] init];
    webVC.urlString = self.latestNoticeMsg[@"noticeUrl"];
    self.showNotice = NO;
    [self judgeNeedShowLatestNotice];
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - dealloc 

- (void)dealloc {
    CLog(@"\n%@ be dealloc", NSStringFromClass([self class]));
}

#pragma mark - RCIMGroupMemberDataSource 实现@功能

- (void)getAllMembersOfGroup:(NSString *)groupId result:(void (^)(NSArray<NSString *> *))resultBlock {
    NSMutableArray<NSString *> *memberIdList = [NSMutableArray arrayWithCapacity:self.clubMemberList.count];
    
    for (NSDictionary *userDict in self.clubMemberList) {
        NSString *memberId = [userDict[@"memberId"] stringValue];
        [memberIdList addObject:memberId];
    }
    
    if (resultBlock) {
        resultBlock(memberIdList);
    }
}

@end
