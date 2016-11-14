//
//  VHSScanBraceletController.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/9.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "VHSScanBraceletController.h"
#import "VHSScanDeviceCell.h"
#import "SharePeripheral.h"
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
@property (nonatomic, strong) NSMutableArray *peripheralArray;
@property (nonatomic, strong) ASDKSetting *setting;
@property (nonatomic, strong) ASDKGetHandringData *handingData;

@property (nonatomic, assign) BOOL isBinding;

// UI 部分
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *realTimesLabel;
@property (weak, nonatomic) IBOutlet UILabel *footerViewTip;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (nonatomic, strong) VHSScanDeviceCell *bindCell;
@property (nonatomic, strong) ScanNoDevice *nodevice;

@end

@implementation VHSScanBraceletController

#pragma mark - override getter method 

- (NSMutableArray *)peripheralArray {
    if (!_peripheralArray) {
        _peripheralArray = [NSMutableArray new];
    }
    return _peripheralArray;
}

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
    
    // 初始化手环
    [[VHSStepAlgorithm shareAlgorithm] shareBLE];
    self.setting = [[ASDKSetting alloc] init];
    self.handingData = [[ASDKGetHandringData alloc] init];
    
    AppDelegate *delegate = APP_DELEGATE;
    [delegate initConnectPeripheralSuccess:^{
        [self scanDevice:nil];
    }];
    
    // 监听扫描到外围设备
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didScanDevice:) name:DeviceDidScanBLEsNotification object:nil];
    //添加通知，监听连接到手环事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bindDevice:) name:DeviceDidConnectedBLEsNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithFormat:@"%@", self.title]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithFormat:@"%@", self.title]];
}

-(void)scanDevice:(UIButton *)button {
    // 倒计时结束判断
    self.nodevice.hidden = YES;
    [VHSTimeToast toastShow:5.0 success:^{
        if (![self.peripheralArray count]) {
            self.nodevice.hidden = NO;
            [self.view addSubview:self.nodevice];
            self.nodevice.center = self.view.center;
            
            __weak typeof(self) weakSelf = self;
            self.nodevice.getHelpBlock = ^(){
                VHSFitBraceletHelpController *helpVC = [[VHSFitBraceletHelpController alloc] init];
                [weakSelf.navigationController pushViewController:helpVC animated:YES];
            };
            
            UITapGestureRecognizer *tapResearch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(researchBle)];
            [self.view addGestureRecognizer:tapResearch];
        }
    }];
    //先断开正在连接的设备
    if ([ShareDataSdk shareInstance].peripheral.state == CBPeripheralStateConnected) {
        [[SharePeripheral sharePeripheral].bleMolue ASDKSendDisConnectDevice:[ShareDataSdk shareInstance].peripheral];
    }
    [[SharePeripheral sharePeripheral].bleMolue ASDKSendScanDevice];
    
    [self performSelector:@selector(stopScanPeripheral) withObject:nil afterDelay:30.0];
}

// 停止扫描外围设备
- (void)stopScanPeripheral {
    [MBProgressHUD hiddenHUD];
    [[SharePeripheral sharePeripheral].bleMolue ASDKSendStopScanDevice];
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
        cell=[[[NSBundle mainBundle]loadNibNamed:@"VHSScanDeviceCell" owner:nil options:nil]firstObject];
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
    [[SharePeripheral sharePeripheral].bleMolue ASDKSendConnectDevice:model.UUID];
    
}

#pragma mark - 收到外围设备监听消息

- (void)didScanDevice:(NSNotification *)noti {
    self.peripheralArray = noti.userInfo[DeviceDidScanBLEsUserInfoKey];
    if ([self.peripheralArray count] > 0) {
        self.footerViewTip.hidden = NO;
        self.footerView.hidden = NO;
    }
    [self.tableView reloadData];
}

- (void)bindDevice:(NSNotification *)noti {
    //会多次回调此方法，只网络请求判断一次
    if (!self.isBinding) {
        self.isBinding = YES;
        [MBProgressHUD showMessage:nil];
        CBPeripheral *peripheral = noti.userInfo[DeviceDidConnectedBLEsUserInfoPeripheral];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self netWorkJudgeIsBindBLE:peripheral];
        });
    }
}

-(void)netWorkJudgeIsBindBLE:(CBPeripheral *)peri {
    if (![VHSCommon isNetworkAvailable]) {
        [VHSToast toast:TOAST_BLE_BIND_NO_NOTWORK];
        [[SharePeripheral sharePeripheral].bleMolue ASDKSendDisConnectDevice:[ShareDataSdk shareInstance].peripheral];
        return;
    }
    // 预绑定
    __weak __typeof(self)weakSelf = self;
    [self bindBleWithActionType:@"2" Success:^(NSDictionary *result, BOOL isSuccess) {
        if (isSuccess) {
            // 预绑定成功
            [weakSelf bindBleWithActionType:@"1" Success:^(NSDictionary *result, BOOL isSuccess) {
                if (isSuccess) {
                    [weakSelf bindBracelet];
                } else {
                    [VHSToast toast:result[@"info"]];
                    [weakSelf recoverCell];
                }
            }];
        } else {
            [[SharePeripheral sharePeripheral].bleMolue ASDKSendDisConnectDevice:peri];
            [MBProgressHUD hiddenHUD];
            [VHSToast toast:result[@"info"]];
            [weakSelf recoverCell];
        }
    }];
}
// 绑定手环
- (void)bindBracelet {
    NSLog(@"准备震动－－－开始绑定");
    
    [self recoverCell];
    
    __weak VHSScanBraceletController *weakSelf = self;
    // 已经连接成功,开始绑定
    [self.setting ASDKSendDeviceBindingWithCMDType:ASDKDeviceBinding withUpdateBlock:^(int errorCode) {
        NSLog(@"已经震动");
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hiddenHUD];
            if (errorCode == SUCCESS) {
                [weakSelf.bindCell.bingButton setTitle:@"已绑定" forState:UIControlStateNormal];
                [weakSelf showAlertAfterBind];
                // 绑定成功后本地存储
                ShareDataSdk *shareData = [ShareDataSdk shareInstance];
                [SharePeripheral sharePeripheral].bleName = shareData.peripheral.name;
                [VHSFitBraceletStateManager BLEbindSuccessWithBLEName:shareData.peripheral.name UUID:shareData.uuidString macAddress:shareData.smart_device_id];

                // 获取绑定时刻手环的数据
                [[VHSStepAlgorithm shareAlgorithm] realtimeBraceletDataBlock:^(ProtocolLiveDataModel *liveData) {
                    [VHSCommon setShouHuanBoundSteps:liveData.step];
                    [VHSCommon setShouHuanLastStepsSync:liveData.step];
                    [VHSCommon setShouHuanLastTimeSync:[VHSCommon getDate:[NSDate date]]];
                }];
                
                if (weakSelf.getDataBaseDataBlock) {
                    weakSelf.getDataBaseDataBlock();
                }
                
            } else {
                [VHSToast toast:TOAST_BLE_BIND_FAIL];
                [k_UserDefaults removeObjectForKey:k_SHOUHUAN_UUID];
                [weakSelf.bindCell.bingButton setTitle:@"点击绑定" forState:UIControlStateNormal];
            }
            weakSelf.bindCell.waitingIgv.hidden = YES;
            weakSelf.bindCell.bingButton.hidden = NO;
            weakSelf.tableView.userInteractionEnabled = YES;
        });
    }];
}

- (void)showAlertAfterBind {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"绑定手环后，手环数据将作为计步数据的唯一来源" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    //跳转到手环设置页面
    VHSFitBraceletSettingController *settingVC = (VHSFitBraceletSettingController *)[StoryboardHelper controllerWithStoryboardName:@"Me" controllerId:@"VHSFitBraceletSettingController"];
    settingVC.backVC = self.topVC;
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - dealloc

- (void)dealloc {
    
}

#pragma mark - 绑定三部曲
// 预绑定 type 2 － 绑定前判断是否可以绑定
// 绑定 type 1 － 预绑定为yes，去绑定手环
// 解绑 type 0 － 解除手机和手环绑定

- (void)bindBleWithActionType:(NSString *)type Success:(void (^)(id result, BOOL isSuccess))successBlock {
    
    // 网络请求绑定 - 告知后台绑定手环
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_DO_HAND_MAC;
    NSString *handMac = [ShareDataSdk shareInstance].smart_device_id;
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (handMac) {
        [params setObject:handMac forKey:@"handMac"];
    } else {
        NSLog(@".......");
    }
    if (type) {
        [params setObject:type forKey:@"actionType"];
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
        NSLog(@"%@", error.description);
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
    [[SharePeripheral sharePeripheral].bleMolue ASDKSendConnectDevice:model.UUID];
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
    [self scanDevice:nil];
}

@end
