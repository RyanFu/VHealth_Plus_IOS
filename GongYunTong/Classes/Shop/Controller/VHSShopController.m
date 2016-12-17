//
//  VHSShopController.m
//  GongYunTong
//
//  Created by vhsben on 16/7/20.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSShopController.h"
#import "PublicWKWebViewController.h"
#import "MJRefresh.h"
#import "VHSMyScoreController.h"

@interface VHSShopController ()

@property (nonatomic, strong) UIView                *noContentView;
@property (nonatomic, strong) WKWebView             *contentWKWebView;

@property (nonatomic, strong) UIView                *progress;          // 进度条
@property (nonatomic, strong) UIView                *backView;          // 返回
@property (nonatomic, strong) UIView                *closeView;         // 关闭
@property (nonatomic, assign) BOOL                  didClickGoBack;     // 点击返回按钮
@property (nonatomic, assign) NSInteger             loadTimes;          // 载入次数

@end

@implementation VHSShopController

- (BOOL)isHiddenTabbar {
    return self.tabBarController.tabBar.isHidden;
}

#pragma mark - 自定义导航栏

- (void)customNavigationBar {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6, 18, 18)];
    backImage.image = [UIImage imageNamed:@"icon_back"];
    
    UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(backImage.frame), 0, 40, 30)];
    backLabel.text = @"返回";
    backLabel.textColor = [UIColor colorWithHexString:@"#828282"];
    backLabel.font = [UIFont systemFontOfSize:14.0];
    
    self.backView = backView;
    self.backView.hidden = YES;
    
    [backView addSubview:backImage];
    [backView addSubview:backLabel];
    
    UITapGestureRecognizer *backGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gobackUrl)];
    [backView addGestureRecognizer:backGesture];
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    
    // 关闭
    UIView *closeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 30)];
    UILabel *closeLabel = [[UILabel alloc] initWithFrame:closeView.frame];
    closeLabel.text = @"关闭";
    closeLabel.textColor = [UIColor colorWithHexString:@"#828282"];
    closeLabel.font = [UIFont systemFontOfSize:14];
    [closeView addSubview:closeLabel];
    self.closeView = closeView;
    self.closeView.hidden = YES;
    
    UITapGestureRecognizer *closeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeWebView)];
    [closeView addGestureRecognizer:closeGesture];
    UIBarButtonItem *closeBarItem = [[UIBarButtonItem alloc] initWithCustomView:closeView];
    
    self.navigationItem.leftBarButtonItems = @[backBarItem, closeBarItem];
    
    UIView *fixedSpace = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithCustomView:fixedSpace];
    self.navigationItem.rightBarButtonItems = @[fixed];
}

- (void)gobackUrl {
    if (self.contentWKWebView.canGoBack) {
        [self.contentWKWebView goBack];
    }
    self.didClickGoBack = YES;
}

- (void)closeWebView {
    NSString *url = [NSString stringWithFormat:@"%@?vhstoken=%@", MAIN_SHOP_URL, [VHSCommon vhstoken]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    [self.contentWKWebView loadRequest:request];
}

- (void)shouldShowBottomBar:(BOOL)shouldShow {
    // 不在当前页面
    if (!self.isVisible) {
        return;
    }

    if (!shouldShow) {
        self.tabBarController.tabBar.hidden = YES;
        CGRect tabBarFrame = self.navigationController.tabBarController.tabBar.frame;
        CGRect webFrame = self.contentWKWebView.frame;
        [UIView animateWithDuration:0.1 animations:^{
            self.contentWKWebView.frame = CGRectMake(webFrame.origin.x, webFrame.origin.y, webFrame.size.width, webFrame.size.height + tabBarFrame.size.height);
        }];
    } else {
        CGRect tabBarFrame = self.navigationController.tabBarController.tabBar.frame;
        CGRect webFrame = self.contentWKWebView.frame;
        self.tabBarController.tabBar.hidden = NO;
        [UIView animateWithDuration:0.1 animations:^{
            self.contentWKWebView.frame = CGRectMake(webFrame.origin.x, webFrame.origin.y, webFrame.size.width, webFrame.size.height - tabBarFrame.size.height);
        }];
    }
}

- (void)loadReq {
    NSString *url = [NSString stringWithFormat:@"%@?vhstoken=%@", MAIN_SHOP_URL, [VHSCommon vhstoken]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    [self.contentWKWebView loadRequest:request];
}

#pragma mark - 创建WebVie

- (WKWebView *)contentWKWebView {
    if (!_contentWKWebView) {
        WKWebViewConfiguration *configration = [[WKWebViewConfiguration alloc] init];
        [configration.userContentController addScriptMessageHandler:self name:@"vhswebview"];
        _contentWKWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, SCREENW, SCREENH - NAVIAGTION_HEIGHT - TABBAR_HEIGHT) configuration:configration];
        _contentWKWebView.UIDelegate = self;
        _contentWKWebView.navigationDelegate = self;
        _contentWKWebView.allowsBackForwardNavigationGestures = YES;
        // 监听进度条
        [_contentWKWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _contentWKWebView;
}

- (void)setupRefresh {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    header.lastUpdatedTimeLabel.hidden = NO;
    [header setTitle:@"释放更新" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    self.contentWKWebView.scrollView.mj_header = header;
}

- (void)refreshData {
    if (![VHSCommon isNetworkAvailable]) {
        [self.contentWKWebView.scrollView.mj_header endRefreshing];
        [VHSToast toast:TOAST_NO_NETWORK];
        return;
    }
    [self.contentWKWebView reload];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 防止navigationBar挡住tableView/scrollView
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.loadTimes = 1;
    [self.view addSubview:self.contentWKWebView];
    
    [self customNavigationBar];
    [self setupRefresh];
    
    [self loadReq];
    
    // 进度条
    self.progress = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                             CGRectGetHeight(self.navigationController.navigationBar.frame) - 2.5,
                                                             self.contentWKWebView.frame.size.width,
                                                             2.5)];
    self.progress.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:self.progress];
    
    if (![VHSCommon isNetworkAvailable]) {
        self.noContentView.hidden = NO;
        [self.view bringSubviewToFront:self.noContentView];
        
        if (iOS8) {
            self.contentWKWebView.hidden = YES;
        }
    }
    
    // 监听支付宝支付回调通知
    [k_NotificationCenter addObserver:self
                             selector:@selector(handleAlipayInfo:)
                                 name:k_NOTI_ALIPAY_CALLBACK_INFO
                               object:nil];
    // 监测系统通知
    [k_NotificationCenter addObserver:self
                             selector:@selector(appWillEnterForeground)
                                 name:UIApplicationWillEnterForegroundNotification
                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.contentWKWebView evaluateJavaScript:@"__isIndex()" completionHandler:^(id _Nullable any, NSError * _Nullable error) {
        BOOL res = [any boolValue];
        if (!res && self.loadTimes != 1) {
            [self shouldShowBottomBar:NO];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"福利"];
    [self webViewIfNeededRefresh];
}

- (void)webViewIfNeededRefresh {
    // 超过时间一个小时，自动刷新
    NSString *lateTime = [VHSCommon getUserDefautForKey:k_Late_Show_Shop_Time];
    if ([VHSCommon intervalSinceNow:lateTime] >= k_Late_Duration(1.0)) {
        [self.contentWKWebView.scrollView.mj_header beginRefreshing];
    }
    [VHSCommon saveShopTime:[VHSCommon getDate:[NSDate date]]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"福利"];
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

#pragma mark - 监听

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progress.hidden = self.contentWKWebView.estimatedProgress == 1;
        self.progress.frame = CGRectMake(self.progress.frame.origin.x,
                                         self.progress.frame.origin.y,
                                         SCREENW * self.contentWKWebView.estimatedProgress,
                                         self.progress.frame.size.height);
        self.progress.backgroundColor = [UIColor greenColor];
    }
}

#pragma mark - WKNavigationDelegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    DLog(@"\n\nwebView url == %@\n\n", webView.URL.absoluteString);
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.loadTimes++;
    
    NSString *url = webView.URL.absoluteString;
    NSString *theTitle = webView.title;
    
    if ([VHSCommon isNullString:theTitle] == NO && [theTitle isEqualToString:@"index"] == NO) {
        if ([url containsString:@"vhstoken"]) {
            self.navigationItem.title = @"福利";
        } else {
            self.navigationItem.title = theTitle;
        }
    }
    
    // 页面加载结束后判断是否为主页面
    [self.contentWKWebView evaluateJavaScript:@"__isIndex()" completionHandler:^(id _Nullable any, NSError * _Nullable error) {
        BOOL res = [any boolValue];
        BOOL HiddenTabBar = [self isHiddenTabbar];
        // 主页
        if (res && HiddenTabBar) {
            [self shouldShowBottomBar:YES];
            self.backView.hidden = YES;
            self.closeView.hidden = YES;
            self.didClickGoBack = NO;
        }
        // 不是主页并且没有隐藏标签栏
        else if (!res && !HiddenTabBar) {
            [self shouldShowBottomBar:NO];
            self.backView.hidden = NO;
        }
    }];
    
    if (self.didClickGoBack) {
        self.closeView.hidden = NO;
    }

    [self.contentWKWebView.scrollView.mj_header endRefreshing];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    CLog(@"1error %@",error.description);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    CLog(@"2error %@",error.description);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([VHSCommon isNetworkAvailable]) {
        decisionHandler(WKNavigationActionPolicyAllow);
        [[BaiduMobStat defaultStat] webviewStartLoadWithRequest:navigationAction.request];
    } else {
        if (self.loadTimes != 1) {
            [VHSToast toast:TOAST_NO_NETWORK];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSDictionary *dict = (NSDictionary<NSString *, NSString *> *)message.body;
    NSString *method = dict[@"method"];
    
    if ([method isEqualToString:@"pay"]) {
        NSString *value = dict[@"value"];
        [self alipay:value];
    }
    else if ([method isEqualToString:@"toScoreItem"]) {
        // 跳转到我的积分
        VHSMyScoreController *myScore = (VHSMyScoreController *)[StoryboardHelper controllerWithStoryboardName:@"Me" controllerId:@"VHSMyScoreController"];
        myScore.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myScore animated:YES];
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
            self.noContentView.hidden = YES;
            self.contentWKWebView.hidden = NO;
            [self loadReq];
        }
    } else {
        [VHSToast toast:TOAST_NO_NETWORK];
    }
}

#pragma mark - alipay

- (void)alipay:(NSString *)payParam {
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.params = @{@"pay" : payParam};
    message.path = URL_GET_PAY_SIGN;
    message.httpMethod = VHSNetworkPOST;
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] == 200) {
            NSString *signUrl = result[@"signUrl"];
            // 启动支付宝
            [self setupAlipayWithSignUrl:signUrl];
        }
    } fail:^(NSError *error) {
        
    }];
}
// 发起支付
- (void)setupAlipayWithSignUrl:(NSString *)signUrl {
    //应用注册scheme,在Info.plist定义URL types
    NSString *appScheme = ALIPAY_APP_SCHEME;
    
    if (signUrl && signUrl.length > 0) {
        [[AlipaySDK defaultService] payOrder:signUrl fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            if (6001 == [[resultDic objectForKey:@"resultStatus"] intValue]) {}
            else if (9000 == [[resultDic objectForKey:@"resultStatus"] intValue]) {}
            else {}
        }];
    }
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
    
    if (status == 0) {
        // wkWebView调用js代码
        [self.contentWKWebView evaluateJavaScript:@"js_method()" completionHandler:^(id _Nullable any, NSError * _Nullable error) {
            CLog(@"any == %@", any);
        }];
    }
    else if (status == 4000) {
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
        [self.contentWKWebView evaluateJavaScript:@"backPay('success')" completionHandler:^(id _Nullable any, NSError * _Nullable error) {
            CLog(@"调用成功");
        }];
    }
}

- (void)dealloc {
    [k_NotificationCenter removeObserver:self name:k_NOTI_ALIPAY_CALLBACK_INFO object:nil];
}

#pragma mark - App Notification

- (void)appWillEnterForeground {
    if (!self.isVisible) {
        return;
    }
    [self webViewIfNeededRefresh];
}

@end
