//
//  VHSScanBraceletController.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/9.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSScanBraceletController.h"
#import "VHSScanDeviceCell.h"
#import "MBProgressHUD+VHS.h"
#import "UIView+animation.h"
#import "VHSFitBraceletStateManager.h"
#import "VHSFitBraceletSettingController.h"
#import "VHSStepAlgorithm.h"
#import "NSDate+VHSExtension.h"
#import "VHSTimeToast.h"
#import "ScanNoDevice.h"
#import "VHSFitBraceletHelpController.h"

@interface VHSScanBraceletController ()<UITableViewDelegate, UITableViewDataSource, VHSScanDeviceCellDelegate>

// data 部分
@property (nonatomic, strong) NSArray<PeripheralModel *> *peripheralArray;
@property (nonatomic, assign) BOOL isBinding;
// UI 部分
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *realTimesLabel;
@property (weak, nonatomic) IBOutlet UILabel *footerViewTip;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (nonatomic, strong) VHSScanDeviceCell *bindCell;
@property (nonatomic, strong) ScanNoDevice *nodevice;

@end

static NSTimeInterval VHS_BLE_BIND_DURATION     = 15;

@implementation VHSScanBraceletController

#pragma mark - override getter method 

- (ScanNoDevice *)nodevice {
    if (!_nodevice) {
        _nodevice = [ScanNoDevice scanNoDeviceFromNib];
    }
    return _nodevice;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    @WeakObj(self);
    [[VHSBraceletCoodinator sharePeripheral] scanBraceletorDuration:5.0 process:^{
        [selfWeak scanBracelet];
    } completion:^(NSArray<PeripheralModel *> *braceletorList) {
        selfWeak.peripheralArray = braceletorList;
        [selfWeak.tableView reloadData];
        
        if ([selfWeak.peripheralArray count] > 0) {
            selfWeak.footerViewTip.hidden = NO;
            selfWeak.footerView.hidden = NO;
        }
    }];
    
    //添加通知，监听连接到手环事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareBindBracelet:) name:DeviceDidConnectedBLEsNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - UITableViewDelegate, DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.peripheralArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VHSScanDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VHSScanDeviceCell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"VHSScanDeviceCell" owner:nil options:nil] firstObject];
    }
    cell.delegate = self;
    PeripheralModel *model = self.peripheralArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 当前没有正在绑定
    self.isBinding = NO;
    tableView.userInteractionEnabled = NO;
    
    self.bindCell = [tableView cellForRowAtIndexPath:indexPath];
    [self.bindCell.waitingIgv startRotateAnimation];
    self.bindCell.bingButton.hidden = YES;
    
    PeripheralModel *model = self.peripheralArray[indexPath.row];
    
    /// 去绑定手环
    [self toSendConnectDevice:model];
}

#pragma mark - 收到外围设备监听消息

- (void)prepareBindBracelet:(NSNotification *)noti {
    //会多次回调此方法，只网络请求判断一次
    if (!self.isBinding) {
        self.isBinding = YES;
        CBPeripheral *peripheral = noti.userInfo[DeviceDidConnectedBLEsUserInfoPeripheral];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self netWorkJudgeIsBindBLE:peripheral];
        });
    }
}

- (void)netWorkJudgeIsBindBLE:(CBPeripheral *)peripheral {
    if (![VHSCommon isNetworkAvailable]) {
        [VHSToast toast:TOAST_BLE_BIND_NO_NOTWORK];
        [[VHSBraceletCoodinator sharePeripheral] disconnectBraceletorWithPeripheral:peripheral];
        return;
    }
    // 预绑定(判断能否绑定手环)
    @WeakObj(self);
    [self bindBleWithActionType:@"2" success:^(NSDictionary *result, BOOL isSuccess) {
        if (isSuccess) {
            // 绑定手环
            [selfWeak bindBracelet];
        } else {
            [[VHSBraceletCoodinator sharePeripheral] disconnectBraceletorWithPeripheral:peripheral];
            [MBProgressHUD hiddenHUD];
            [VHSToast toast:result[@"info"]];
            [selfWeak recoverCell];
        }
    }];
}
// 绑定手环
- (void)bindBracelet {
    
    [self recoverCell];
    
    @WeakObj(self);
    // 已经连接成功,开始绑定
    [[VHSBraceletCoodinator sharePeripheral] braceletorGotoBindWithCallBack:^(int errorCode) {
        CLog(@"----->>>> 手环绑定成功");
        [MBProgressHUD hiddenHUD];
        selfWeak.bindCell.waitingIgv.hidden = YES;
        selfWeak.bindCell.bingButton.hidden = NO;
        selfWeak.tableView.userInteractionEnabled = YES;
        
        // 手环绑定失败
        if (errorCode != SUCCESS) {
            [VHSToast toast:TOAST_BLE_BIND_FAIL];
            [k_UserDefaults removeObjectForKey:k_SHOUHUAN_UUID];
            [selfWeak.bindCell.bingButton setTitle:@"点击绑定" forState:UIControlStateNormal];
            return;
        }
        
        // 手环绑定成功
        ShareDataSdk *shareData = [ShareDataSdk shareInstance];
        [VHSFitBraceletStateManager bleBindSuccessWith:shareData];
        [VHSBraceletCoodinator sharePeripheral].bleName = shareData.peripheral.name;
        
        // 停止手机计步，开始手机计步
        [[VHSStepAlgorithm shareAlgorithm] startBleStepRecord];
        
        [selfWeak.bindCell.bingButton setTitle:@"已绑定" forState:UIControlStateNormal];
        [selfWeak showAlertAfterBind];
        
        // 通知服务器已经绑定成功
        [selfWeak bindBleWithActionType:@"1" success:^(NSDictionary *result, BOOL isSuccess) {
            if (!isSuccess) {
                [VHSToast toast:result[@"info"]];
                [selfWeak recoverCell];
            }
        }];
        
        // 获取绑定时刻手环的数据
        [[VHSBraceletCoodinator sharePeripheral] getBraceletorRealtimeDataWithCallBack:^(ProtocolLiveDataModel *liveData, int errorCode) {
            [VHSCommon setShouHuanLastTimeSync:[VHSCommon getDate:[NSDate date]]];
            
            // 初始化当前绑定时刻的手环数据到数据库
            VHSActionData *action = [[VHSActionData alloc] init];
            action.actionId = [VHSCommon getTimeStamp];
            action.startTime = [VHSCommon getDate:[NSDate date]];
            action.initialStep = @(liveData.step).stringValue;
            action.currentDeviceStep = @(liveData.step).stringValue;
            action.step = @(0).stringValue;
            action.memberId = [VHSCommon userInfo].memberId.stringValue;
            action.actionType = @"1";
            action.recordTime = [VHSCommon getYmdFromDate:[NSDate date]];
            action.upload = 1;
            action.macAddress = liveData.smart_device_id;
            action.seconds = @(liveData.active_time).stringValue;
            action.calorie = @(liveData.calories).stringValue;
            
            action.actionMode = @"0";
            action.distance = @"0";
            action.endTime = [VHSCommon getDate:[NSDate date]];
            action.score = @"0";
            
            [[VHSStepAlgorithm shareAlgorithm] insertAction:action];
        }];
    }];
}

- (void)showAlertAfterBind {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:CONST_BRACELTE_BIND_SUCESS_TIP delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    //跳转到手环设置页面
    VHSFitBraceletSettingController *settingVC = (VHSFitBraceletSettingController *)[VHSStoryboardHelper controllerWithStoryboardName:@"Me" controllerId:@"VHSFitBraceletSettingController"];
    settingVC.backVC = self.topVC;
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - dealloc

- (void)dealloc {
    CLog(@"%@ be dealloc", NSStringFromClass([self class]));
}

#pragma mark - 绑定三部曲
// 预绑定 type 2 － 绑定前判断是否可以绑定
// 绑定 type 1 － 预绑定为yes，去绑定手环
// 解绑 type 0 － 解除手机和手环绑定

// 绑定手环逻辑: 预绑定(判断手环能否绑定) -> 物理绑定(手环和手机进行蓝牙连接，绑定) -> 服务器绑定(服务器记录手环的mac地址，确定用户已经绑定了手环)

- (void)bindBleWithActionType:(NSString *)type success:(void (^)(id result, BOOL isSuccess))successBlock {
    
    // 网络请求绑定 - 告知后台绑定手环
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_DO_HAND_MAC;
    NSString *handMac = [ShareDataSdk shareInstance].smart_device_id; // 不能使用[VHSCommon getShouHuanMacAddress]，当前还未绑定手环，UserDefault中没有保存手环地址
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:type forKey:@"actionType"];
    if (handMac) {
        [params setObject:handMac forKey:@"handMac"];
    }
    message.params = params;
    message.httpMethod = VHSNetworkPOST;
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] == 200) {
            if (successBlock) {
                successBlock(result, YES);
            }
        } else {
            if (successBlock) {
                successBlock(result, NO);
            }
        }
    } fail:^(NSError *error) {
        CLog(@"%@", error.description);
    }];
}

#pragma mark - VHSScanDeviceCellDelegate - 手环点击绑定

-(void)vhsScanDeviceCellBindClick:(VHSScanDeviceCell *)cell {
    self.isBinding = NO;
    [cell.waitingIgv startRotateAnimation];
    cell.bingButton.hidden = YES;
    self.tableView.userInteractionEnabled = NO;
    
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    PeripheralModel *model = self.peripheralArray[index.row];
    
    // 同发送绑定手环
    [self toSendConnectDevice:model];
}

- (void)toSendConnectDevice:(PeripheralModel *)model {
    [MBProgressHUD showDelay:VHS_BLE_BIND_DURATION];
    [[VHSBraceletCoodinator sharePeripheral] connectBraceletorWithBleUUID:model.UUID];
}
/// 还原Cell的状态
- (void)recoverCell {
    [self.bindCell.bingButton setTitle:@"点击绑定" forState:UIControlStateNormal];
    self.bindCell.waitingIgv.hidden = YES;
    self.bindCell.bingButton.hidden = NO;
    self.tableView.userInteractionEnabled = YES;
}

#pragma mark - 搜索手环
- (void)researchBle {
    [self scanBracelet];
}

- (void)scanBracelet {
    self.nodevice.hidden = YES;
    [VHSTimeToast toastShow:5.0 success:^{
        if ([self.peripheralArray count]) return;
        
        self.nodevice.hidden = NO;
        [self.view addSubview:self.nodevice];
        self.nodevice.center = self.view.center;
        
        @WeakObj(self);
        self.nodevice.getHelpBlock = ^(){
            VHSFitBraceletHelpController *helpVC = [[VHSFitBraceletHelpController alloc] init];
            [selfWeak.navigationController pushViewController:helpVC animated:YES];
        };
        
        UITapGestureRecognizer *tapResearch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(researchBle)];
        [self.view addGestureRecognizer:tapResearch];
    }];
}

@end
