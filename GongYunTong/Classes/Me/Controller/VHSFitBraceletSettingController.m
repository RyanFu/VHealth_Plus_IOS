//
//  VHSFitBraceletSettingController.m
//  VHealth1.6
//
//  Created by vhsben on 16/6/28.
//  Copyright © 2016年 kumoway. All rights reserved.
//

#import "VHSFitBraceletSettingController.h"
#import "VHSFitBraceletSettingModel.h"
#import "VHSSettingBraceletCell.h"
#import "VHSFitBraceletStateManager.h"
#import "MBProgressHUD+VHS.h"
#import "NSDate+VHSExtension.h"
#import "VHSStepAlgorithm.h"


CGFloat const settingHeaderHeight=130;
CGFloat const settingFooterHeight=106;

@interface VHSFitBraceletSettingController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *deviceName;
@property (weak, nonatomic) IBOutlet UIImageView *deviceStatus;
@property (weak, nonatomic) IBOutlet UILabel *batteryFlow;
@property (weak, nonatomic) IBOutlet UIButton *unbindBtn;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation VHSFitBraceletSettingController

- (IBAction)clickToUnbing:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"解绑后手环数据将清零，是否继续解绑？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手环设置";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    
    self.unbindBtn.layer.cornerRadius = 5;
    self.unbindBtn.layer.masksToBounds = YES;
    
    UIBarButtonItem *backBarI = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popUpViewController)];
    self.navigationItem.leftBarButtonItem = backBarI;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.deviceName.text = [ShareDataSdk shareInstance].peripheral.name;
    
    if ([ShareDataSdk shareInstance].peripheral.state == CBPeripheralStateConnected) {
        //设备连接
        self.deviceStatus.hidden = YES;
    } else {
        self.deviceStatus.hidden = NO;
    }
    __weak typeof(self)weakSelf = self;
    // 获取设备信息
    [[VHSBraceletCoodinator sharePeripheral] getBraceletorDeviceInfoWithCallback:^(id object, int errorCode) {
        if (errorCode == SUCCESS) {
            ProtocolDeviceInfoModel *model = object;
            if (model.batt_level) {
                weakSelf.batteryFlow.text = [NSString stringWithFormat:@"%@%%",model.batt_level];
            } else {
                weakSelf.batteryFlow.text = @"--%";
            }
        } else {
            weakSelf.batteryFlow.text = @"--%";
        }
    }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 0) {
        [self bleUndingNotifyByNetwork];
    }
}

- (void)bleUndingNotifyByNetwork {
    //网络未连接
    if (![VHSCommon isNetworkAvailable]) {
        [VHSToast toast:TOAST_NO_NETWORK];
        return;
    }
    // 网络请求绑定 - 告知服务器手环解绑
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    NSString *handmacId = [VHSCommon getUserDefautForKey:k_SHOUHUAN_MAC_ADDRESS];
    message.params = @{@"handMac" : handmacId, @"actionType" : @"0"};
    message.path = URL_DO_HAND_MAC;
    message.httpMethod = VHSNetworkPOST;
    
    __weak __typeof(self)weakSelf = self;
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] == 200) {
            [weakSelf unbindBracelet];
        } else {
            [VHSToast toast:result[@"info"]];
        }
    } fail:^(NSError *error) {
        [VHSToast toast:TOAST_NETWORK_SUSPEND];
    }];
}

- (void)unbindBracelet {
    __weak VHSFitBraceletSettingController *weakSelf = self;

    if ([ShareDataSdk shareInstance].peripheral.state == CBPeripheralStateConnected) {
        [MBProgressHUD showMessage:nil];
        
        NSInteger lastSyncSteps = [VHSCommon getShouHuanLastStepsSync];
        [[VHSBraceletCoodinator sharePeripheral] getBraceletorRealtimeDataWithCallBack:^(ProtocolLiveDataModel *liveData, int errorCode) {
            NSInteger step = liveData.step - lastSyncSteps;
            if (step > 0) {
                // 同步数据到本地
                VHSActionData *action = [[VHSActionData alloc] init];
                action.actionId = [VHSCommon getTimeStamp];
                action.memberId = [[VHSCommon userInfo].memberId stringValue];
                action.actionType = @"1";
                action.recordTime = [VHSCommon getYmdFromDate:[NSDate date]];
                action.step = [NSString stringWithFormat:@"%@", @(step)];
                action.upload = 0;
                action.endTime = [VHSCommon getDate:[NSDate date]];
                action.macAddress = liveData.smart_device_id;
                [[VHSStepAlgorithm shareAlgorithm] insertOrUpdateBleAction:action];
            }
            
            [[VHSBraceletCoodinator sharePeripheral] braceletorGotoUnbindWithCallBack:^(int errorCode) {
                [MBProgressHUD hiddenHUD];
                if (errorCode == SUCCESS) {
                    [VHSToast toast:TOAST_BLE_UNBIND_SUCCESS];
                    [VHSFitBraceletStateManager BLEUnbindSuccess]; // 解绑成功后本地存储
                    [weakSelf popUpViewController]; // 返回到前一个页面
                    // 解绑后开启手机记步服务
                    [[VHSStepAlgorithm shareAlgorithm] setupStepRecorder];
                } else {
                    [VHSToast toast:TOAST_BLE_UNBIND_FAIL];
                }
            }];
        }];
    } else {
        [self popUpViewController];
    }
}

#pragma mark --tableView协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VHSSettingBraceletCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VHSSettingBraceletCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"VHSSettingBraceletCell" owner:nil options:nil]firstObject];
    }
    VHSFitBraceletSettingModel *model = [[VHSFitBraceletSettingModel alloc] initWithImageName:@"icon_update_date" settingOperation:CONST_GET_DATA_FROM_BRACELET operationTime:[VHSBraceletCoodinator sharePeripheral].recentlySyncTime];
    cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        VHSSettingBraceletCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.isDisBinding = YES;
        
        NSInteger lastSyncSteps = [VHSCommon getShouHuanLastStepsSync];
        [[VHSBraceletCoodinator sharePeripheral] getBraceletorRealtimeDataWithCallBack:^(ProtocolLiveDataModel *liveData, int errorCode) {
            // 同步数据到本地
            VHSActionData *action = [[VHSActionData alloc] init];
            action.actionId = [VHSCommon getTimeStamp];
            action.memberId = [[VHSCommon userInfo].memberId stringValue];
            action.recordTime = [VHSCommon getYmdFromDate:[NSDate date]];
            action.actionType = @"1";
            action.step = [NSString stringWithFormat:@"%ld", liveData.step - lastSyncSteps];
            action.upload = 0;
            action.endTime = [VHSCommon getDate:[NSDate date]];
            [[VHSStepAlgorithm shareAlgorithm] insertOrUpdateBleAction:action];
            
            // 更新本地的标志信息
            [VHSCommon setShouHuanLastTimeSync:[VHSCommon getDate:[NSDate date]]];
            [VHSCommon setShouHuanLastStepsSync:[NSString stringWithFormat:@"%u", liveData.step]];
            
            cell.isDisBinding = NO;
            [VHSToast toast:TOAST_UPLOAD_STEPS_SUCCESS];
        }];
    }
}

#pragma mark - Pop View Controller

// 返回 和 解绑成功后返回
- (void)popUpViewController {
    if (self.backVC) {
        [self.navigationController popToViewController:self.backVC animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dealloc
{
    CLog(@"解绑页面释放");
}

@end
