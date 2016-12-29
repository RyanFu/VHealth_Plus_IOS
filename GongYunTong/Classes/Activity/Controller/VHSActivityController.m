//
//  VHSActivityController.m
//  GongYunTong
//
//  Created by vhsben on 16/8/26.
//  Copyright © 2016年 average. All rights reserved.
//

#import "VHSActivityController.h"
#import "PublicWKWebViewController.h"
#import "VHSLocatServicer.h"
#import "MBProgressHUD+VHS.h"

@interface VHSActivityController ()

@property (nonatomic, strong) WKWebView *contentWKWebView;
@property (nonatomic, strong) UIView    *noContentView;

@property (nonatomic, strong) UIView    *progress;

@end

@implementation VHSActivityController

/**
 *  有关使用WKWebView
 *  reference: http://liuyanwei.jumppo.com/2015/10/17/ios-webView.html
 **/

-(void)addAllScriptMsgHandle{
    WKUserContentController *controller = self.contentWKWebView.configuration.userContentController;
    [controller addScriptMessageHandler:self name:@"vhswebview"];
}
-(void)removeAllScriptMsgHandle{
    WKUserContentController *controller = self.contentWKWebView.configuration.userContentController;
    [controller removeScriptMessageHandlerForName:@"vhswebview"];
}

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

- (void)setupRefresh {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    header.lastUpdatedTimeLabel.hidden = NO;
    [header setTitle:@"释放更新" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    self.contentWKWebView.scrollView.mj_header = header;
}

- (void)refreshData {
    [self loadRequest];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    self.navigationItem.title = @"活动";
    self.view.backgroundColor = COLOR_BG_TABLEVIEW;
    
    // 防止navigationBar挡住tableView/scrollView
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self.view addSubview:self.contentWKWebView];
    
    [self setupRefresh];
    [self loadRequest];
    
    self.progress = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                             CGRectGetHeight(self.navigationController.navigationBar.frame) + 0.5,
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
    
    // 监测系统通知
    [k_NotificationCenter addObserver:self selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithFormat:@"%@", @"活动"]];
    [self webViewIfNeededRefresh];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithFormat:@"%@", @"活动"]];
}

- (void)webViewIfNeededRefresh {
    // 超过时间一个小时，自动刷新
    NSString *lateTime = [VHSCommon getUserDefautForKey:k_Late_Show_Activity_Time];
    if ([VHSCommon intervalSinceNow:lateTime] >= k_Late_Duration(1.0)) {
        [self.contentWKWebView.scrollView.mj_header beginRefreshing];
    }
    [VHSCommon saveActivityTime:[VHSCommon getDate:[NSDate date]]];
}

// 加载请求
- (void)loadRequest {
    NSString *url = [NSString stringWithFormat:@"%@", ACTIVITY_MAIN_URL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15.0];
    [self.contentWKWebView loadRequest:request];
}

#pragma mark - 监听

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progress.hidden = self.contentWKWebView.estimatedProgress == 1;
        
        self.progress.frame = CGRectMake(self.progress.frame.origin.x,
                                         self.progress.frame.origin.y,
                                         SCREENW * self.contentWKWebView.estimatedProgress,
                                         self.progress.frame.size.height);
        self.progress.backgroundColor = COLOR_PROGRESS_BAR;
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
    NSString *theTitle = webView.title;
    if ([VHSCommon isNullString:theTitle]) {
//        self.navigationItem.title = @"活动";
    }
    
    [webView.scrollView.mj_header endRefreshing];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    CLog(@"error %@",error.description);
    [webView.scrollView.mj_header endRefreshing];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    CLog(@"error %@",error.description);
    [webView.scrollView.mj_header endRefreshing];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (navigationAction.request.URL.absoluteString.length) {
        decisionHandler(WKNavigationActionPolicyAllow);
        // 百度统计URL请求
        [[BaiduMobStat defaultStat] webviewStartLoadWithRequest:navigationAction.request];
    }
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    // 监测js对native的回调，可以截获message.body参数
    NSDictionary *bodyDict = (NSDictionary *)message.body;
    NSString *method = bodyDict[@"method"];
    
    if ([method isEqualToString:@"getToken"]) {
        NSString *backMethod = bodyDict[@"backMethod"];
        [self getTokenSuccess:^(NSString *token) {
            NSString *jsMethod = [NSString stringWithFormat:@"%@('%@')", backMethod, token];
            [self.contentWKWebView evaluateJavaScript:jsMethod completionHandler:^(id _Nullable any, NSError * _Nullable error) {
                CLog(@"成功");
            }];
        }];
    }
    else if ([method isEqualToString:@"openWebView"]) {
        NSString *url = bodyDict[@"url"];
        PublicWKWebViewController *publicWebVC = [[PublicWKWebViewController alloc] init];
        publicWebVC.urlString = url;
        publicWebVC.showTitle = YES;
        publicWebVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:publicWebVC animated:YES];
    }
}

#pragma mark - UIDelegate
 // js 里面的alert实现，如果不实现，网页的alert函数无效
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"JS-Alert"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
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
            [self loadRequest];
        }
    } else {
        [VHSToast toast:TOAST_NO_NETWORK];
    }
}

#pragma mark - call method by js 

- (void)getTokenSuccess:(void (^)(NSString *token))successBlock {
    NSString *token = [VHSCommon vhstoken];
    if (token) {
        if (successBlock) {
            successBlock(token);
        }
    }
}

#pragma mark - App Notification 

- (void)appWillEnterForeground {
    if (!self.isVisible) {
        return;
    }
    [self webViewIfNeededRefresh];
}

@end
