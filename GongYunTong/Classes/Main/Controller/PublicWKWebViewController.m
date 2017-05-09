//
//  PublicWebViewController.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/29.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "PublicWKWebViewController.h"
#import "VHSLocatServicer.h"
#import "MBProgressHUD+VHS.h"
#import "OneAlertCaller.h"
#import "VHSCommentController.h"

@interface PublicWKWebViewController ()

@property (nonatomic, strong) WKWebView *contentWKWebView;

@property (nonatomic, strong) UIView    *progress;              // 加载进度条
@property (nonatomic, strong) UIView    *noContentView;         // 网页加载错误提示信息

@property (nonatomic, strong) UIView    *backBarView;           // 自定义返回按钮
@property (nonatomic, strong) UIView    *closeBarView;          // 自定义关闭按钮

@property (nonatomic, assign) BOOL      shouldShowCloseBtn;     // 是否显示关闭按钮

@property (nonatomic, copy) NSString    *loadedRequestUrl;      // 加载成功的URL

@end


@implementation PublicWKWebViewController

- (void)setShouldShowCloseBtn:(BOOL)shouldShowCloseBtn {
    _shouldShowCloseBtn = shouldShowCloseBtn;
    
    self.closeBarView.hidden = !_shouldShowCloseBtn;
}

#pragma mark - 自定义导航栏

- (void)customNavigationBar {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6, 18, 18)];
    backImage.image = [UIImage imageNamed:@"icon_back"];
    
    UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(backImage.frame), 0, 40, 30)];
    backLabel.text = @"返回";
    backLabel.textColor = COLORHex(@"#828282");
    backLabel.font = [UIFont systemFontOfSize:14.0];
    
    self.backBarView = backView;
    
    [backView addSubview:backImage];
    [backView addSubview:backLabel];
    
    UITapGestureRecognizer *backGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAppUrl)];
    [backView addGestureRecognizer:backGesture];
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    
    // 关闭
    UIView *closeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 30)];
    UILabel *closeLabel = [[UILabel alloc] initWithFrame:closeView.frame];
    closeLabel.text = @"关闭";
    closeLabel.textColor = [UIColor colorWithHexString:@"#828282"];
    closeLabel.font = [UIFont systemFontOfSize:14];
    [closeView addSubview:closeLabel];
    closeView.hidden = YES;
    self.closeBarView = closeView;
    
    UITapGestureRecognizer *closeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeWebView)];
    [closeView addGestureRecognizer:closeGesture];
    UIBarButtonItem *closeBarItem = [[UIBarButtonItem alloc] initWithCustomView:closeView];
    
    self.navigationItem.leftBarButtonItems = @[backBarItem, closeBarItem];
}

#pragma mark - 创建WebView

-(void)addAllScriptMsgHandle{
    WKUserContentController *controller = self.contentWKWebView.configuration.userContentController;
    [controller addScriptMessageHandler:self name:@"vhswebview"];
}
-(void)removeAllScriptMsgHandle{
    WKUserContentController *controller = self.contentWKWebView.configuration.userContentController;
    [controller removeScriptMessageHandlerForName:@"vhswebview"];
}

- (void)setupWKWebView {
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *controller = [[WKUserContentController alloc] init];
    configuration.userContentController = controller;
    self.contentWKWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, SCREENW, SCREENH - NAVIAGTION_HEIGHT)
                                               configuration:configuration];
    self.contentWKWebView.UIDelegate = self;
    self.contentWKWebView.navigationDelegate = self;
    self.contentWKWebView.allowsBackForwardNavigationGestures = YES;
    // 监听进度条
    [self.contentWKWebView addObserver:self
                            forKeyPath:@"estimatedProgress"
                               options:NSKeyValueObservingOptionNew context:nil];
    [self addAllScriptMsgHandle];
}

- (UIView *)noContentView {
    if (!_noContentView) {
        // 无内容时显示视图
        _noContentView = [[UIView alloc] init];
        _noContentView.frame = CGRectMake(0, 0, 120, 82);
        _noContentView.center = self.view.center;
        
        UILabel *lblNoRecord = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, 120, 50)];
        lblNoRecord.backgroundColor = [UIColor clearColor];
        lblNoRecord.textAlignment = NSTextAlignmentCenter;
        lblNoRecord.textColor = [UIColor grayColor];
        lblNoRecord.text = @"暂无内容";
        lblNoRecord.font = [UIFont systemFontOfSize:15.0];
        lblNoRecord.numberOfLines = 2;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noContentViewTaped:)];
        [_noContentView addGestureRecognizer:tap];
        
        [_noContentView addSubview:lblNoRecord];
        
        _noContentView.hidden = YES;
        [self.view addSubview:_noContentView];
    }
    return _noContentView;
}

#pragma mark - reload url

- (void)setupRefresh {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadUrl)];
    header.lastUpdatedTimeLabel.hidden = NO;
    [header setTitle:@"释放更新" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    self.contentWKWebView.scrollView.mj_header = header;
}

- (void)reloadUrl {
    [self.contentWKWebView reload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupWKWebView];
    [self setupRefresh];
    [self customNavigationBar];
    
    NSString *url = nil;
    if (_shouldToken) {
        NSArray *urlArray = [self.urlString componentsSeparatedByString:@"?"];
        if ([urlArray count] >= 2) {
            url = [NSString stringWithFormat:@"%@&vhstoken=%@", self.urlString, [VHSCommon vhstoken]];
        } else {
            url = [NSString stringWithFormat:@"%@?vhstoken=%@", self.urlString, [VHSCommon vhstoken]];
        }
    } else {
        url = self.urlString;
    }
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    
    if (iOS8) {
        [self.contentWKWebView loadRequest:request];
        [self.view addSubview:self.contentWKWebView];
    }
    
    self.progress = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                             CGRectGetHeight(self.navigationController.navigationBar.frame) + 0.5,
                                                             SCREENW * 0.3,
                                                             2.5)];
    self.progress.backgroundColor = COLOR_PROGRESS_BAR;
    [self.navigationController.navigationBar addSubview:self.progress];
    
    if (![VHSCommon isNetworkAvailable]) {
        self.noContentView.hidden = NO;
        [self.view bringSubviewToFront:self.noContentView];
        
        if (iOS8) {
            self.contentWKWebView.hidden = YES;
        }
    }
    
    // 监听支付宝支付回调通知
    [k_NotificationCenter addObserver:self selector:@selector(handleAlipayInfo:) name:k_NOTI_ALIPAY_CALLBACK_INFO object:nil];
    [k_NotificationCenter addObserver:self selector:@selector(refreshAppPage) name:k_NOTI_APP_PAGE_REFRESH object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.progress.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [k_NotificationCenter removeObserver:self name:k_NOTI_ALIPAY_CALLBACK_INFO object:nil];
    [k_NotificationCenter removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

#pragma mark - 监听

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progress.hidden = self.contentWKWebView.estimatedProgress == 1;
        
        self.progress.frame = CGRectMake(self.progress.frame.origin.x,
                                         self.progress.frame.origin.y,
                                         self.contentWKWebView.estimatedProgress,
                                         self.progress.frame.size.height);
        self.progress.backgroundColor = COLOR_PROGRESS_BAR;
    }
}

#pragma mark - WKNavigationDelegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    CLog(@"\n\nwebView url == %@\n\n", webView.URL.absoluteString);
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (self.showTitle) {
        NSString *webTitle = webView.title;
        NSArray *backList = webView.backForwardList.backList;
        // 只有在一级界面显示title
        if (![VHSCommon isNullString:webTitle] && ![backList count]) {
            self.navigationItem.title = webTitle;
        } else if (--self.showTitleLevel == [backList count]) {
            self.navigationItem.title = webTitle;
        } else {
            self.navigationItem.title = @"";
        }
    }
    self.loadedRequestUrl = webView.URL.absoluteString;
    // 加载结束，隐藏导航条
    self.progress.hidden = YES;
    [self.contentWKWebView.scrollView.mj_header endRefreshing];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    _noContentView.hidden = NO;
    [self.view bringSubviewToFront:_noContentView];
    [self.contentWKWebView.scrollView.mj_header endRefreshing];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"2error %@",error.description);
    [self.contentWKWebView.scrollView.mj_header endRefreshing];
}

// 页面加载之前，决定是否需要加载
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (navigationAction.request.URL.absoluteString.length) {
        decisionHandler(WKNavigationActionPolicyAllow);
        // 百度统计URL
        [[BaiduMobStat defaultStat] webviewStartLoadWithRequest:navigationAction.request];
    }
}

#pragma mark - WKScriptMessageHandler

/// JS和Native之间的调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSDictionary *bodyDict = (NSDictionary<NSString *, NSString *> *)message.body;
    NSString *method = bodyDict[@"method"];
    
    if ([method isEqualToString:@"pay"]) {
        NSString *value = bodyDict[@"value"];
        [self alipay:value];
    }
    else if ([method isEqualToString:@"getToken"]) {
        NSString *backMethod = bodyDict[@"backMethod"];
        @WeakObj(self);
        [self getTokenSuccess:^(NSString *token) {
            NSString *jsMethod = [NSString stringWithFormat:@"%@('%@')", backMethod, token];
            [selfWeak.contentWKWebView evaluateJavaScript:jsMethod completionHandler:^(id _Nullable any, NSError * _Nullable error) {}];
        }];
    }
    else if ([method isEqualToString:@"getLocation"]) {
        [[VHSLocatServicer shareLocater] startUpdatingLocation]; // 开启定位服务
        [MBProgressHUD showMessage:@"正在签到"];
        while (1) {
            if ([VHSCommon latitudeLongitude]) {
                [MBProgressHUD hiddenHUD];
                break;
            }
        }
        NSString *backMethod = bodyDict[@"backMethod"];
        NSString *jsMethod = [NSString stringWithFormat:@"%@('%@')", backMethod, [VHSCommon latitudeLongitude]];
        [self.contentWKWebView evaluateJavaScript:jsMethod completionHandler:^(id _Nullable any, NSError * _Nullable error) {}];
    }
    else if ([method isEqualToString:@"closeGps"]) {
        [[VHSLocatServicer shareLocater] stopUpdatingLocation];
    }
    else if ([method isEqualToString:@"playVideo"]) {
        NSString *videoUrl = bodyDict[@"value"];
        PublicWKWebViewController *playVideoVC = [[PublicWKWebViewController alloc] init];
        playVideoVC.urlString = videoUrl;
        [self.navigationController pushViewController:playVideoVC animated:YES];
    }
    else if ([method isEqualToString:@"jsCallTel"]) {
        NSString *phone = bodyDict[@"value"];
        NSString *title = bodyDict[@"title"];
        NSString *content = bodyDict[@"content"];
        OneAlertCaller *caller = [[OneAlertCaller alloc] initWithPhone:phone title:title content:content];
        [caller call];
    }
    else if ([method isEqualToString:@"addClubNote"]) {
        // 俱乐部发帖子
        NSString *clubId = bodyDict[@"clubId"];
        VHSCommentController *commentVC = [[VHSCommentController alloc] init];
        commentVC.title = CONST_CLUB_ADD_BBS;
        commentVC.clubId = clubId;
        commentVC.commentType = VHSCommentOfMomentPublishPostType;
        [self presentViewController:commentVC animated:YES completion:nil];
    }
    else if ([method isEqualToString:@"addClubbbsReply"]) {
        // 帖子回复
        NSString *clubId = bodyDict[@"clubId"];
        NSString *bbsId = bodyDict[@"bbsId"];
        VHSCommentController *commentVC = [[VHSCommentController alloc] init];
        commentVC.title = CONST_COMMENT;
        commentVC.clubId = clubId;
        commentVC.bbsId = bbsId;
        commentVC.commentType = VHSCommentOfMomentReplyPostType;
        [self presentViewController:commentVC animated:YES completion:nil];
    }
    else if ([method isEqualToString:@"editClubNotice"]) {
        // 编辑公告
        NSString *clubId = bodyDict[@"clubId"];
        NSString *noticeId = bodyDict[@"noticeId"];
        NSString *noticeContent = bodyDict[@"noticeContent"];
        VHSCommentController *commentVC = [[VHSCommentController alloc] init];
        commentVC.title = CONST_EDIT_NOTICE;
        commentVC.clubId = clubId;
        commentVC.noticeId = noticeId;
        commentVC.content = noticeContent;
        commentVC.commentType = VHSCommentOfMomentUpdateAnnouncementType;
        [self presentViewController:commentVC animated:YES completion:nil];
    }
}

#pragma mark - UIDelegate
// js 里面的alert实现，如果不实现，网页的alert函数无效
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
    
}

//  js 里面的alert实现，如果不实现，网页的alert函数无效
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler(YES);
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action){
                                                          completionHandler(NO);
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
    
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler {
    completionHandler(@"Client Not handler");
}

#pragma mark - no content view tap

- (void)noContentViewTaped:(UIGestureRecognizer *)tap {
    if ([VHSCommon isNetworkAvailable]) {
        if (iOS8) {
            _noContentView.hidden = YES;
            self.contentWKWebView.hidden = NO;
            [self.contentWKWebView reload];
        }
    }
}

#pragma mark - alipay

- (void)alipay:(NSString *)payParam {
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    if (![VHSCommon isNullString:payParam]) {
        message.params = @{@"pay" : payParam};
    }
    message.path = URL_GET_PAY_SIGN;
    message.httpMethod = VHSNetworkPOST;
    @WeakObj(self);
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] == 200) {
            NSString *signUrl = result[@"signUrl"];
            // 启动支付宝
            [selfWeak setupAlipayWithSignUrl:signUrl];
        }
    } fail:^(NSError *error) {}];
}
// 发起支付
- (void)setupAlipayWithSignUrl:(NSString *)signUrl {

    if (!signUrl || !signUrl.length) return;
    
    //应用注册scheme,在Info.plist定义URL types
    NSString *appScheme = [VHSCommon appSecheme];
    [[AlipaySDK defaultService] payOrder:signUrl fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        if (6001 == [[resultDic objectForKey:@"resultStatus"] intValue]) {}
        else if (9000 == [[resultDic objectForKey:@"resultStatus"] intValue]) {}
        else {}
    }];
}

#pragma mark - 支付信息回调处理

// 支付宝支付回调信息处理
// 9000	订单支付成功
// 8000	正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
// 4000	订单支付失败
// 6001	用户中途取消
// 6002	网络连接出错
// 6004	支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
// 其它	其它支付错误
- (void)handleAlipayInfo:(NSNotification *)noti {
    NSDictionary *alipyInfo = noti.userInfo;
    NSInteger status = [alipyInfo[@"resultStatus"] integerValue];
    
    if (status == 4000) {
        [self.contentWKWebView evaluateJavaScript:@"backPay('订单支付失败')" completionHandler:nil];
    }
    else if (status == 6001) {
        [self.contentWKWebView evaluateJavaScript:@"backPay('用户中途取消')" completionHandler:nil];
    }
    else if (status == 6002) {
        [self.contentWKWebView evaluateJavaScript:@"backPay('网络连接出错')" completionHandler:nil];
    }
    else if (status == 6004) {
        [self.contentWKWebView evaluateJavaScript:@"backPay('支付结果未知')" completionHandler:nil];
    }
    else if (status == 8000) {
        [self.contentWKWebView evaluateJavaScript:@"backPay('正在处理中')" completionHandler:nil];
    }
    else if (status == 9000) {
        [self.contentWKWebView evaluateJavaScript:@"backPay('支付成功')" completionHandler:^(id _Nullable any, NSError * _Nullable error) {
            CLog(@"支付宝支付成功");
        }];
    }
}

#pragma mark - js call oc
// 获取token
- (void)getTokenSuccess:(void (^)(NSString *token))successBlock {
    NSString *token = [VHSCommon vhstoken];
    if (!token) return;
    
    if (successBlock) {
        successBlock(token);
    }
}

- (void)closeWebView {
    [self.contentWKWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self removeAllScriptMsgHandle];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - oc call js

// 调用js返回URL的上一级
- (void) backAppUrl {
    if (self.contentWKWebView.canGoBack) {
        [self.contentWKWebView goBack];
        self.shouldShowCloseBtn = YES;
    } else {
        [self closeWebView];
    }
}

// 刷新Web Url
- (void)refreshAppPage {
    [self.contentWKWebView evaluateJavaScript:@"refreshAppPage()" completionHandler:^(id _Nullable res, NSError * _Nullable error) {
        CLog(@"evaluateJavaScript success");
    }];
}

- (void)dealloc {
    [self.contentWKWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    CLog(@"----publicWKWebView -------------- dealloc");
}


@end
