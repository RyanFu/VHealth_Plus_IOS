//
//  VHSRecordStepController.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/8.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "VHSRecordStepController.h"
#import "VHSScanBraceletController.h"
#import "VHSStepAlgorithm.h"
#import "VHSDataBaseManager.h"
#import "VHSFitBraceletStateManager.h"
#import "VHSFitBraceletSettingController.h"
#import "AppDelegate.h"
#import "VHSAllStepsController.h"
#import "UIView+VHS_animation.h"
#import "MBProgressHUD+VHS.h"
#import "NSDate+VHSExtension.h"

@interface VHSRecordStepController ()

@property (nonatomic, strong) UILabel *allStepLabel;    // 所有步数
@property (nonatomic, strong) UILabel *kilometreLabel;  // 公里数
@property (nonatomic, strong) UILabel *syncTimeLabel;   // 同步时间

@property (nonatomic, strong) UILabel *lastTimeLabel;   // 上次获取手环数据
@property (nonatomic, strong) UILabel *allNumberStepLabel;  // 所有步数
@property (nonatomic, strong) UIImageView *syncRotate;  // 同步按钮

@property (nonatomic, strong) UILabel *stepsLabel;
@property (nonatomic, strong) NSTimer *tm;

@property (nonatomic, assign) NSInteger sumStepsOnDB;   // 已经同步到本地数据库总步数
@property (nonatomic, assign) double kilometre;      // 公里数
@end

@implementation VHSRecordStepController

- (void)setKilometre:(double)kilometre {
    _kilometre = kilometre;
    
    NSString *kilStr = [NSString stringWithFormat:@"%.2f", _kilometre];
    _kilometreLabel.text = [NSString stringWithFormat:@"≈ %@公里", kilStr];
    NSMutableAttributedString *kilo_attributes = [[NSMutableAttributedString alloc] initWithString:_kilometreLabel.text];
    NSRange kiloRange = NSMakeRange([self.kilometreLabel.text rangeOfString:kilStr].location, kilStr.length);
    [kilo_attributes addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:35] range:kiloRange];
    [_kilometreLabel setAttributedText:kilo_attributes];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"计步";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self sumStepsFromDB];
    
    [self initUI];
    
    _stepsLabel.text =  [NSString stringWithFormat:@"%@步",[NSString stringWithFormat:@"%@", @(self.sumSteps)]];
    self.kilometre = [[k_UserDefaults objectForKey:k_Steps_To_Kilometre_Ratio] doubleValue] * self.sumSteps;
    [self setLabel:_stepsLabel labelText:_stepsLabel.text attriText:[NSString stringWithFormat:@"%ld", self.sumSteps]];
    
    // 15分钟，自动同步数据到云端
    [k_NotificationCenter addObserver:self selector:@selector(autosyncStepsToCloud) name:k_NOTI_SYNCSTEPS_TO_NET object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithFormat:@"%@", self.title]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithFormat:@"%@", self.title]];
}

//设置状态栏中字体颜色为白色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // 设置导航栏背景色为透明
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    // 设置导航栏title颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    if ([VHSFitBraceletStateManager nowBLEState] == FitBLEStateDisbind) {
        self.lastTimeLabel.text = @"未绑定";
    } else {
        // 显示上一次同步时间
        self.lastTimeLabel.text = [NSString stringWithFormat:@"上次获取手环数据-%@",[VHSCommon timeInfoWithDateString:[VHSCommon getShouHuanLastTimeSync]]];
    }
    
    // 同步到服务器的时间
    self.syncTimeLabel.text = [NSString stringWithFormat:@"上次同步：%@", [VHSCommon timeInfoWithDateString:[VHSCommon getUploadServerTime]]];
    
    if ([VHSFitBraceletStateManager nowBLEState] == FitBLEStateDisbind) {
        // 使用手机数据
        _tm = [NSTimer scheduledTimerWithTimeInterval:2.0f
                                               target:self
                                             selector:@selector(changeLabelData)
                                             userInfo:nil
                                              repeats:YES];
        [_tm fire];
        
    } else {
        // 使用手环数据
        // 启动监听手环实时数据的监听器
        [[VHSStepAlgorithm shareAlgorithm] fireTimer];
        [[VHSStepAlgorithm shareAlgorithm].stepsData addObserver:self forKeyPath:@"step" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 设置导航栏的背景色不透明
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    // 设置导航栏title颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    if ([VHSFitBraceletStateManager nowBLEState] == FitBLEStateDisbind) {
        if ([_tm isValid]) {
            [_tm invalidate];
        }
    } else {
        // 释放器
        [[VHSStepAlgorithm shareAlgorithm] invalidateTimer];
        [[VHSStepAlgorithm shareAlgorithm].stepsData removeObserver:self forKeyPath:@"step"];
    }
    
    // 界面消失 － 回调修改步数
    if (self.callback) {
        self.callback(self.sumSteps);
    }
}

- (void)initUI {
    
    self.view.backgroundColor = COLORHex(@"#efeff4");
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_ground"]];
    bgImgView.frame = CGRectMake(0, 0, SCREENW, 1.0 * SCREENW);
    [self.view addSubview:bgImgView];
    bgImgView.userInteractionEnabled = YES;
    
    // 今日
    UILabel *todayLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 66, 100, 20)];
    todayLabel.text = @"今日";
    todayLabel.textColor = RGBCOLOR(255.0, 255.0, 0.0);
    [bgImgView addSubview:todayLabel];
    
    // 步数
    NSString *steps = @"0";
    _stepsLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 150, bgImgView.frame.size.width - 100, 35)];
    _stepsLabel.text = [NSString stringWithFormat:@"%@步", steps];
    _stepsLabel.textColor = [UIColor whiteColor];
    _stepsLabel.textAlignment = NSTextAlignmentCenter;
    [bgImgView addSubview:_stepsLabel];
    
    NSMutableAttributedString *attributes = [[NSMutableAttributedString alloc] initWithString:_stepsLabel.text];
    NSRange stepsRange = NSMakeRange([_stepsLabel.text rangeOfString:steps].location, steps.length);
    [attributes addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:35] range:stepsRange];
    [_stepsLabel setAttributedText:attributes];
    
    // 公里数
    NSString *kilometre = @"0.00";
    UILabel *kilometreLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 195, bgImgView.frame.size.width - 100 , 35)];
    kilometreLabel.textColor = [UIColor whiteColor];
    kilometreLabel.text = [NSString stringWithFormat:@"≈ %@公里", kilometre];
    kilometreLabel.textAlignment = NSTextAlignmentCenter;
    [bgImgView addSubview:kilometreLabel];
    self.kilometreLabel = kilometreLabel;
    
    NSMutableAttributedString *kilo_attributes = [[NSMutableAttributedString alloc] initWithString:kilometreLabel.text];
    NSRange kiloRange = NSMakeRange([kilometreLabel.text rangeOfString:kilometre].location, kilometre.length);
    [kilo_attributes addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:35] range:kiloRange];
    [kilometreLabel setAttributedText:kilo_attributes];
    
    // 同步时间
    UILabel *syncLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, bgImgView.frame.size.height - 48, bgImgView.frame.size.width - 100, 30)];
    syncLabel.text = @"上次同步：2分钟前";
    syncLabel.textColor = [UIColor whiteColor];
    syncLabel.textAlignment = NSTextAlignmentCenter;
    syncLabel.font = [UIFont systemFontOfSize:15];
    [bgImgView addSubview:syncLabel];
    [syncLabel sizeToFit];
    syncLabel.center = CGPointMake(bgImgView.center.x, syncLabel.frame.origin.y);
    CGRect rect = syncLabel.frame;
    syncLabel.frame = CGRectMake(rect.origin.x + 10, rect.origin.y, 200, 30);
    syncLabel.textAlignment = NSTextAlignmentLeft;
    syncLabel.userInteractionEnabled = YES;
    self.syncTimeLabel = syncLabel;
    
    UITapGestureRecognizer *tapRotateCyc = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(syncByManual:)];
    [self.syncTimeLabel addGestureRecognizer:tapRotateCyc];
    
    UIImageView *syncRotate = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(syncLabel.frame) - 25, CGRectGetMinY(syncLabel.frame) + 7, 15, 15)];
    syncRotate.image = [UIImage imageNamed:@"icon_update"];
    syncRotate.userInteractionEnabled = YES;
    self.syncRotate = syncRotate;
    [bgImgView addSubview:syncRotate];
    
    UITapGestureRecognizer *tapRotate = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(syncByManual:)];
    [syncRotate addGestureRecognizer:tapRotate];
    
    // 手环
    UIView *braceletView = [[UIView  alloc] initWithFrame:CGRectMake(0, bgImgView.frame.size.height + 20, bgImgView.frame.size.width, 44)];
    braceletView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:braceletView];
    
    UITapGestureRecognizer *bracTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(braceletTap:)];
    [braceletView addGestureRecognizer:bracTap];
    
    UIImageView *braceletImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10.5, 23, 23)];
    braceletImgView.image = [UIImage imageNamed:@"icon_shouhuan"];
    [braceletView addSubview:braceletImgView];
    
    UILabel *braceletLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(braceletImgView.frame) + 19, 7, 50, 30)];
    braceletLabel.text = @"手环";
    braceletLabel.textColor = COLOR_TEXT;
    [braceletView addSubview:braceletLabel];
    
    NSString *bracSync = @"上次获取手环数据9分钟前";
    UILabel *bracSyncLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(braceletLabel.frame) + 5, 7, CGRectGetWidth(braceletView.frame) - CGRectGetMaxX(braceletLabel.frame) - 45, 30)];
    bracSyncLabel.textAlignment = NSTextAlignmentRight;
    bracSyncLabel.text = bracSync;
    bracSyncLabel.textColor = COLOR_TEXT_PLACEHOLDER;
    [braceletView addSubview:bracSyncLabel];
    self.lastTimeLabel = bracSyncLabel;
    
    UIImageView *bracArrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(braceletView.frame) - 29, 15, 14, 14)];
    bracArrowImgView.image = [UIImage imageNamed:@"icon_next"];
    [braceletView addSubview:bracArrowImgView];
    
    // 手环点击区域内加上两个线条
    UIView *btopLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 0.5)];
    btopLine.backgroundColor = COLORHex(@"#cccccc");
    [braceletView addSubview:btopLine];
    
    UIView *bbottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(braceletView.frame) - 0.5, SCREENW, 0.5)];
    bbottomLine.backgroundColor = COLORHex(@"#cccccc");
    [braceletView addSubview:bbottomLine];

    // 步数cell
    UIView *stepsView = [[UIView  alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(braceletView.frame) + 20, bgImgView.frame.size.width, 44)];
    stepsView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:stepsView];
    
    UITapGestureRecognizer *stepsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stepsTap:)];
    [stepsView addGestureRecognizer:stepsTap];
    
    UIImageView *stepImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10.5, 23, 23)];
    stepImgView.image = [UIImage imageNamed:@"icon_allsteps"];
    [stepsView addSubview:stepImgView];
    
    UILabel *allStepsLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(stepImgView.frame) + 19, 7, 100, 30)];
    allStepsLabel.text = @"所有步数";
    allStepsLabel.textColor = COLOR_TEXT;
    [stepsView addSubview:allStepsLabel];
    
    UIImageView *stepsArrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(stepsView.frame) - 29, 15, 14, 14)];
    stepsArrowImgView.image = [UIImage imageNamed:@"icon_next"];
    [stepsView addSubview:stepsArrowImgView];
    
    // 手环点击区域内加上两个线条
    UIView *stopLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 0.5)];
    stopLine.backgroundColor = COLORHex(@"#cccccc");
    [stepsView addSubview:stopLine];
    
    UIView *sbottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(stepsView.frame) - 0.5, SCREENW, 0.5)];
    sbottomLine.backgroundColor = COLORHex(@"#cccccc");
    [stepsView addSubview:sbottomLine];
}

#pragma mark - 手势点击

- (void)braceletTap:(UIGestureRecognizer *)tap {
    
    if ([VHSFitBraceletStateManager nowBLEState] != FitBLEStateDisbind) {
        VHSFitBraceletSettingController *fitSettingVC = (VHSFitBraceletSettingController *)[StoryboardHelper controllerWithStoryboardName:@"Me" controllerId:@"VHSFitBraceletSettingController"];
        [self.navigationController pushViewController:fitSettingVC animated:YES];
    } else {
        VHSScanBraceletController *scanVC = (VHSScanBraceletController *)[StoryboardHelper controllerWithStoryboardName:@"Me" controllerId:@"VHSScanBraceletController"];
        scanVC.topVC = self;
        __weak typeof(self)weakSelf = self;
        scanVC.getDataBaseDataBlock = ^(){
            weakSelf.sumStepsOnDB = [[VHSStepAlgorithm shareAlgorithm] selecteSumStepsWithMemberId:[[VHSCommon userDetailInfo].memberId stringValue] date:[VHSCommon getYmdFromDate:[NSDate date]]];
        };
        [self.navigationController pushViewController:scanVC animated:YES];
    }
}

- (void)stepsTap:(UIGestureRecognizer *)tap {
    VHSAllStepsController *stepsVC = (VHSAllStepsController *)[StoryboardHelper controllerWithStoryboardName:@"Me" controllerId:@"VHSAllStepsController"];
    [self.navigationController pushViewController:stepsVC animated:YES];
    NSLog(@"点击了所有步数");
}

#pragma mark - kvo

/// 手环数据变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"step"]) {
        NSInteger dbSteps = [[VHSStepAlgorithm shareAlgorithm] selecteSumStepsWithMemberId:[[VHSCommon userDetailInfo].memberId stringValue] date:[VHSCommon getYmdFromDate:[NSDate date]]];
        NSInteger realtimeSteps = [VHSStepAlgorithm shareAlgorithm].stepsData.step;
        NSInteger lastSyncSteps = [VHSCommon getShouHuanLastStepsSync];
        
        self.sumSteps = dbSteps + realtimeSteps - lastSyncSteps;
        
        NSLog(@"--real-%ld--db-%ld--last-%ld--sum-%ld", realtimeSteps, dbSteps, lastSyncSteps, self.sumSteps);
        
        NSString *stepTotal = [NSString stringWithFormat:@"%@", @(self.sumSteps)];
        // 步数转为公里数据
        self.kilometre = [[k_UserDefaults objectForKey:k_Steps_To_Kilometre_Ratio] doubleValue] * self.sumSteps;
       
        _stepsLabel.text =  [NSString stringWithFormat:@"%@步",stepTotal];

        [self setLabel:_stepsLabel labelText:_stepsLabel.text attriText:stepTotal];
    }
}

/// 从谐处理器中获取数据
- (void)changeLabelData {
    NSInteger steps = [[VHSStepAlgorithm shareAlgorithm] selecteSumStepsWithMemberId:[[VHSCommon userInfo].memberId stringValue] date:[VHSCommon getYmdFromDate:[NSDate date]]];
    self.sumSteps = steps;
    
    // 步数转为公里数据
    self.kilometre = [[k_UserDefaults objectForKey:k_Steps_To_Kilometre_Ratio] doubleValue] * self.sumSteps;
    
    NSString *str = [NSString stringWithFormat:@"%ld",(long)self.sumSteps];
    _stepsLabel.text =  [NSString stringWithFormat:@"%@步",str];

    [self setLabel:_stepsLabel labelText:_stepsLabel.text attriText:str];
}
/// 设置label的属性化
- (void)setLabel:(UILabel *)label labelText:(NSString *)text attriText:(NSString *)attriText {
    label.text =  text;
    NSMutableAttributedString *attributes = [[NSMutableAttributedString alloc] initWithString:label.text];
    NSRange stepsRange = NSMakeRange([label.text rangeOfString:attriText].location, attriText.length);
    [attributes addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:35] range:stepsRange];
    [label setAttributedText:attributes];
}

#pragma mark - 从本地获取一天的的所有步数

- (void)sumStepsFromDB {
    self.sumStepsOnDB = [[VHSStepAlgorithm shareAlgorithm] selecteSumStepsWithMemberId:[[VHSCommon userDetailInfo].memberId stringValue] date:[VHSCommon getYmdFromDate:[NSDate date]]];
}

#pragma mark - 手动同步到服务段

- (void)syncByManual:(UIGestureRecognizer *)tap {
    
    // 只能点击一次
    self.syncTimeLabel.userInteractionEnabled = NO;
    self.syncRotate.userInteractionEnabled = NO;
    
    UIView *tapView = tap.view;
    if ([tapView isKindOfClass:[UIImageView class]]) {
        tapView = (UIImageView *)tap.view;
    }
    else if ([tapView isKindOfClass:[UILabel class]]) {
        tapView = self.syncRotate;
    }
    [tapView startRotateAnimation];

    if ([VHSFitBraceletStateManager nowBLEState] == FitBLEStatebindConnected) {
        BOOL isToday = [[VHSCommon dateWithDateStr:[VHSCommon getShouHuanLastTimeSync]] isToday];
        if (!isToday) {
            // 先同步手环跨天的数据到自建的数据表中
            [[VHSStepAlgorithm shareAlgorithm] asynDataFromBraceletToMobileDB:^{
                [self uploadStepsWithFlagView:tapView];
            }];
        } else {
            // 直接获取手环实时数据到自建数据表中
            NSLog(@"我走了这里");
            
            NSInteger lastSyncSteps = [VHSCommon getShouHuanLastStepsSync];
            // 同步数据到本地
            VHSActionData *action = [[VHSActionData alloc] init];
            action.actionId = [VHSCommon getTimeStamp];
            action.memberId = [[VHSCommon userInfo].memberId stringValue];
            action.recordTime = [VHSCommon getYmdFromDate:[NSDate date]];
            action.actionType = @"1";
            action.step = [VHSStepAlgorithm shareAlgorithm].stepsData.step - lastSyncSteps;
            action.upload = 0;
            action.endTime = [VHSCommon getDate:[NSDate date]];
            [[VHSStepAlgorithm shareAlgorithm] insertOrUpdateBleAction:action];
            
            // 更新本地的标志信息
            [VHSCommon setShouHuanLastTimeSync:[VHSCommon getDate:[NSDate date]]];
            [VHSCommon setShouHuanLastStepsSync:[VHSStepAlgorithm shareAlgorithm].stepsData.step];
            
            [self uploadStepsWithFlagView:tapView];
        }
    } else {
        [self uploadStepsWithFlagView:tapView];
    }
}

- (void)uploadStepsWithFlagView:(UIView *)tapView {
    // 手动同步本地数据库到服务端
    [[VHSStepAlgorithm shareAlgorithm] uploadAllUnuploadActionData:^(BOOL isSuccess) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tapView.layer removeAllAnimations];
            if (isSuccess) {
                // 同步到服务器的时间
                self.syncTimeLabel.text = [NSString stringWithFormat:@"上次同步：%@", [VHSCommon timeInfoWithDateString:[VHSCommon getUploadServerTime]]];
            } else {
                [VHSToast toast:TOAST_UPLOAD_SETPS_FAIL];
            }
            
            self.syncTimeLabel.userInteractionEnabled = YES;
            self.syncRotate.userInteractionEnabled = YES;
        });
    }];
}

#pragma mark - 自动同步步数至网络端

- (void)autosyncStepsToCloud {
    // 使用GCD的定时器触发在其他线程，对UI处理需要在主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.syncRotate startRotateAnimation];
        self.syncRotate.userInteractionEnabled = NO;
        self.syncTimeLabel.userInteractionEnabled = NO;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.syncRotate.layer removeAllAnimations];
        self.syncTimeLabel.text = [NSString stringWithFormat:@"上次同步：%@", [VHSCommon timeInfoWithDateString:[VHSCommon getUploadServerTime]]];
        self.syncRotate.userInteractionEnabled = YES;
        self.syncTimeLabel.userInteractionEnabled = YES;
    });
}

#pragma mark - dealloc

- (void)dealloc {
    [k_NotificationCenter removeObserver:self name:k_NOTI_SYNCSTEPS_TO_NET object:nil];
    NSLog(@"record-step %s", __FUNCTION__);
}

@end
