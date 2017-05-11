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
    @WeakObj(self);
    // 获取设备信息
    [[VHSBraceletCoodinator sharePeripheral] getBraceletorDeviceInfoWithCallback:^(id object, int errorCode) {
        if (errorCode == SUCCESS) {
            ProtocolDeviceInfoModel *model = object;
            if (model.batt_level) {
                selfWeak.batteryFlow.text = [NSString stringWithFormat:@"%@%%",model.batt_level];
            } else {
                selfWeak.batteryFlow.text = @"--%";
            }
        } else {
            selfWeak.batteryFlow.text = @"--%";
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
    NSString *handmacId = [VHSCommon getShouHuanMacAddress];
    message.params = @{@"handMac" : handmacId, @"actionType" : @"0"};
    message.path = URL_DO_HAND_MAC;
    message.httpMethod = VHSNetworkPOST;
    
    @WeakObj(self);
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] == 200) {
            [selfWeak unbindBracelet];
        } else {
            [VHSToast toast:result[@"info"]];
        }
    } fail:^(NSError *error) {
        [VHSToast toast:TOAST_NETWORK_SUSPEND];
    }];
}

- (void)unbindBracelet {
    @WeakObj(self);
    if ([ShareDataSdk shareInstance].peripheral.state == CBPeripheralStateConnected) {
        [MBProgressHUD showMessage:nil];
        
        [[VHSBraceletCoodinator sharePeripheral] getBraceletorRealtimeDataWithCallBack:^(ProtocolLiveDataModel *liveData, int errorCode) {
            NSInteger realStep = liveData.step;
            if (realStep > 0) {
                // 同步数据到本地
                VHSActionData *action = [[VHSActionData alloc] init];
                action.actionId = [VHSCommon getTimeStamp];
                action.memberId = [[VHSCommon userInfo].memberId stringValue];
                action.actionType = @"1";
                action.recordTime = [VHSCommon getYmdFromDate:[NSDate date]];
                action.step = [NSString stringWithFormat:@"%@", @(realStep)];
                action.upload = 0;
                action.endTime = [VHSCommon getDate:[NSDate date]];
                action.macAddress = [VHSCommon getShouHuanMacAddress];
                action.currentDeviceStep = @(realStep).stringValue;
                action.seconds = @(liveData.active_time).stringValue;
                action.distance = @(liveData.distances).stringValue;
                action.calorie = @(liveData.calories).stringValue;
                action.initialStep = @"0";
                
                [[VHSStepAlgorithm shareAlgorithm] updateAction:action];
            }
            
            [[VHSBraceletCoodinator sharePeripheral] braceletorGotoUnbindWithCallBack:^(int errorCode) {
                [MBProgressHUD hiddenHUD];
                if (errorCode == SUCCESS) {
                    [VHSToast toast:TOAST_BLE_UNBIND_SUCCESS];
                    [VHSFitBraceletStateManager bleUnbindSuccess]; // 解绑成功后本地存储
                    [selfWeak popUpViewController]; // 返回到前一个页面
                    // 解绑后开启手机记步服务
                    [[VHSStepAlgorithm shareAlgorithm] startMobileStepRecord];
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
    
    if ([VHSCommon isBetweenZeroMomentFiveMinute]) {
        return;
    }
    
    if (indexPath.section == 0) {
        VHSSettingBraceletCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.isDisBinding = YES;
        cell.userInteractionEnabled = NO;
        
        [[VHSBraceletCoodinator sharePeripheral] getBraceletorRealtimeDataWithCallBack:^(ProtocolLiveDataModel *liveData, int errorCode) {
            // 同步数据到本地
            NSInteger realStep = liveData.step;
            if (realStep > 0) {
                VHSActionData *action = [[VHSActionData alloc] init];
                action.actionId = [VHSCommon getTimeStamp];
                action.startTime = [VHSCommon getDate:[NSDate date]];
                action.memberId = [[VHSCommon userInfo].memberId stringValue];
                action.recordTime = [VHSCommon getYmdFromDate:[NSDate date]];
                action.actionType = @"1";
                action.step = @(realStep).stringValue;
                action.upload = 0;
                action.endTime = [VHSCommon getDate:[NSDate date]];
                action.macAddress = [VHSCommon getShouHuanMacAddress];
                action.initialStep = @"0";
                action.currentDeviceStep = @(realStep).stringValue;
                [[VHSStepAlgorithm shareAlgorithm] updateAction:action];
                
                // 更新本地的标志信息
                [VHSCommon setShouHuanLastTimeSync:[VHSCommon getDate:[NSDate date]]];
            }
            cell.isDisBinding = NO;
            [VHSToast toast:TOAST_UPLOAD_STEPS_SUCCESS];
            cell.userInteractionEnabled = YES;
        }];
        
        // 2秒之后可以同步点击
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!cell.userInteractionEnabled) {
                cell.userInteractionEnabled = YES;
            }
        });
    } else {
        [VHSToast toast:TOAST_BLE_DISCONNECTION_CANT_SYNC];
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
