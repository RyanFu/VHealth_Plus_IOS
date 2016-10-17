//
//  PublicWebViewController.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/29.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "PublicWKWebViewController.h"
#import "VHSLocatServicer.h"
#import "MBProgressHUD+VHS.h"

@interface PublicWKWebViewController ()

@property (nonatomic, strong) WKWebView *contentWKWebView;

@property (nonatomic, strong) UIView    *progress;
@property (nonatomic, strong) UIView    *noContentView;

@property (nonatomic, strong) UIView    *backBarView;
@property (nonatomic, strong) UIView    *closeBarView;

@property (nonatomic, assign) BOOL      shouldShowCloseBtn;

@property (nonatomic, copy) NSString    *loadedRequestUrl;

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
    backLabel.textColor = [UIColor colorWithHexString:@"#828282"];
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

- (void)customNavigation {
    self.navigationController.navigationBarHidden = YES;
    
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREENW, 44)];
    navigationView.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, navigationView.frame.size.height - 0.3, SCREENW, 0.3)];
    line.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.4];
    [navigationView addSubview:line];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 50, 44)];
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 18, 18)];
    backImage.image = [UIImage imageNamed:@"icon_back"];
    
    UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(backImage.frame), 7, 40, 30)];
    backLabel.text = @"返回";
    backLabel.textColor = [UIColor colorWithHexString:@"#828282"];
    backLabel.font = [UIFont systemFontOfSize:14.0];
    
    self.backBarView = backView;
    
    [backView addSubview:backImage];
    [backView addSubview:backLabel];
    
    UITapGestureRecognizer *backGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAppUrl)];
    [backView addGestureRecognizer:backGesture];
    
    [navigationView addSubview:backView];
    
    [self.view addSubview:navigationView];
}

#pragma mark - 创建WebView

- (WKWebView *)contentWKWebView {
    if (!_contentWKWebView) {
        WKWebViewConfiguration *configration = [[WKWebViewConfiguration alloc] init];
        [configration.userContentController addScriptMessageHandler:self name:@"vhswebview"];
        _contentWKWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, SCREENW, SCREENH - NAVIAGTION_HEIGHT) configuration:configration];
        _contentWKWebView.UIDelegate = self;
        _contentWKWebView.navigationDelegate = self;
        _contentWKWebView.allowsBackForwardNavigationGestures = YES;
        // 监听进度条
        [_contentWKWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _contentWKWebView;
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
    
//    [self customNavigation];
    [self customNavigationBar];
    [self setupRefresh];
    
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
                                                             CGRectGetHeight(self.navigationController.navigationBar.frame) - 2.5,
                                                             self.contentWKWebView.frame.size.width,
                                                             2.5)];
    self.progress.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:self.progress];
    
    if (![VHSCommon connectedToNetwork]) {
        self.noContentView.hidden = NO;
        [self.view bringSubviewToFront:self.noContentView];
        
        if (iOS8) {
            self.contentWKWebView.hidden = YES;
        }
    }
    
    // 监听支付宝支付回调通知
    [k_NotificationCenter addObserver:self selector:@selector(handleAlipayInfo:) name:k_NOTI_ALIPAY_CALLBACK_INFO object:nil];
    [k_NotificationCenter addObserver:self selector:@selector(appEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.contentWKWebView reload];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.progress.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    
    // 关闭音乐播放
    [self.contentWKWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
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
    if (self.showTitle) {
        NSString *webTitle = webView.title;
        if ([VHSCommon isNullString:webTitle] == NO) {
            self.navigationItem.title = webTitle;
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

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSDictionary *bodyDict = (NSDictionary<NSString *, NSString *> *)message.body;
    NSString *method = bodyDict[@"method"];
    
    if ([method isEqualToString:@"pay"]) {
        NSString *value = bodyDict[@"value"];
        [self alipay:value];
    }
    else if ([method isEqualToString:@"getToken"]) {
        NSString *backMethod = bodyDict[@"backMethod"];
        __weak typeof(self) weakSelf = self;
        [self getTokenSuccess:^(NSString *token) {
            NSString *jsMethod = [NSString stringWithFormat:@"%@('%@')", backMethod, token];
            [weakSelf.contentWKWebView evaluateJavaScript:jsMethod completionHandler:^(id _Nullable any, NSError * _Nullable error) {
                NSLog(@"成功");
            }];
        }];
    }
    else if ([method isEqualToString:@"getLocation"]) {
        [[VHSLocatServicer shareLocater] startUpdatingLocation]; // 开启定位服务
        while (1) {
            [MBProgressHUD showMessage:@"正在签到"];
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
    if ([VHSCommon connectedToNetwork]) {
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
    message.path = @"/getPaySign.htm";
    message.httpMethod = VHSNetworkPOST;
    __weak typeof(self) weakSelf = self;
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] == 200) {
            NSString *signUrl = result[@"signUrl"];
            // 启动支付宝
            [weakSelf setupAlipayWithSignUrl:signUrl];
        }
    } fail:^(NSError *error) {}];
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
            NSLog(@"调用成功");
        }];
    }
}

#pragma mark - js call oc 
// 获取token
- (void)getTokenSuccess:(void (^)(NSString *token))successBlock {
    NSString *token = [VHSCommon vhstoken];
    if (token) {
        if (successBlock) {
            successBlock(token);
        }
    }
}

- (void)closeWebView {
    [self.contentWKWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    _contentWKWebView = nil;
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

- (void)dealloc {
    NSLog(@"----publicWKWebView -------------- dealloc");
}

#pragma mark - appEnterBackground

- (void)appEnterBackground {
    NSLog(@"appEnterBackground------------");
}

@end
