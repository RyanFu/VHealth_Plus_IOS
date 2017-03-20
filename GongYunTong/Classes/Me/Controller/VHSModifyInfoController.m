//
//  VHSModifyInfoController.m
//  GongYunTong
//
//  Created by pingjun lin on 16/8/18.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSModifyInfoController.h"
#import "VHSModifyNormalCell.h"
#import "VHSModifyMobileCell.h"
#import "MBProgressHUD+VHS.h"

@interface VHSModifyInfoController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableViewCell *didSelectedCell;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (nonatomic, strong) NSString *mobile;

@end

@implementation VHSModifyInfoController

- (NSMutableDictionary *)contentDict {
    if (!_contentDict) {
        _contentDict = [NSMutableDictionary new];
    }
    return _contentDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    CGRect footerRect = self.footerView.frame;
    if (self.modifyType == VHSModifyInfoMobileType) {
        
        self.headerView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 45);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, self.headerView.frame.size.width - 15, 30)];
        label.text = @"输入新的手机号，并验证";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = RGBCOLOR(129, 129, 129);
        [self.headerView addSubview:label];
    
        self.footerView.frame = CGRectMake(0, footerRect.origin.y, SCREENW, SCREENH - NAVIAGTION_HEIGHT - 60 - 44 * 2);
    } else if (self.modifyType == VHSModifyInfoNormalType) {
        self.footerView.frame = CGRectMake(0, footerRect.origin.y, SCREENW, SCREENH - NAVIAGTION_HEIGHT - 20 - 44);
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fallKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - UITableViewDelegate, Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.modifyType == VHSModifyInfoNormalType) {
        return 1;
    }
    else if (self.modifyType == VHSModifyInfoMobileType) {
        return 2;
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    if (self.modifyType == VHSModifyInfoNormalType) {
        VHSModifyNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VHSModifyNormalCell"];
        self.didSelectedCell = cell;
        cell.content = self.contentStr;
        cell.callback = ^(NSString *destStr) {
            weakSelf.contentStr = destStr;
        };
        return cell;
    }
    else if (self.modifyType == VHSModifyInfoMobileType) {
        VHSModifyMobileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VHSModifyMobileCell"];
        if (indexPath.row == 0) {
            self.didSelectedCell = cell;
            cell.modifyType = ModifyPhoneType;
            cell.titleStr = @"手机号:";
            cell.contentStr = self.contentDict[@"mobile"];
            cell.callback = ^(NSString *phoneNumberStr) {
                if (![VHSCommon isNullString:phoneNumberStr]) {
                    [weakSelf.contentDict setObject:phoneNumberStr forKey:@"mobile"];
                }
            };
        }
        else if (indexPath.row == 1) {
            cell.modifyType = ModifyAuthCodeType;
            cell.titleStr = @"验证码:";
            cell.callback = ^(NSString *vCode) {
                if (![VHSCommon isNullString:vCode]) {
                    [weakSelf.contentDict setObject:vCode forKey:@"verCode"];
                }
            };
        }
        return cell;
    }
    else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - fall download 

- (void)fallKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - 修改个人信息

- (IBAction)confirmClick:(id)sender {
    
    [self.view endEditing:YES];
    
    __weak __typeof(self)weakSelf = self;
    if ([self.didSelectedCell isKindOfClass:[VHSModifyNormalCell class]]) {
        VHSModifyNormalCell *cell = (VHSModifyNormalCell *)self.didSelectedCell;

        NSString *cellContent = cell.content ? cell.content : @"";
        if (self.cellType == VHSCellNickNameType) {
            [self uploadPersonInfo:@{@"nickNamev" : cellContent} uploadSuccess:^{
                if (weakSelf.callBack) {
                    weakSelf.callBack(cellContent);
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
        if (self.cellType == VHSCellEmailType) {
            [self uploadPersonInfo:@{@"emailv" : cellContent} uploadSuccess:^{
                if (weakSelf.callBack) {
                    weakSelf.callBack(cellContent);
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
    }
    else if ([self.didSelectedCell isKindOfClass:[VHSModifyMobileCell class]]) {
        
        NSString *mobile = self.contentDict[@"mobile"];
        NSString *vCode = self.contentDict[@"verCode"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (mobile) {
            [params setObject:mobile forKey:@"mobilev"];
        }
        if (vCode) {
            [params setObject:vCode forKey:@"verCode"];
        }
        if (self.cellType == VHSCellMobileType) {
            [self uploadPersonInfo:params uploadSuccess:^{
                if (weakSelf.callBack) {
                    weakSelf.callBack(weakSelf.contentDict);
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
    }
}

- (void)uploadPersonInfo:(NSDictionary *)uploadInfo uploadSuccess:(void (^)())uploadSuccess {
    
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.params = uploadInfo;
    message.path = URL_UP_MEMBER;
    message.httpMethod = VHSNetworkPOST;
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        if ([result[@"result"] integerValue] == 200) {
            if (uploadSuccess) {
                uploadSuccess();
            }
        }
        [VHSToast toast:result[@"info"]];
    } fail:^(NSError *error) {}];
    
}

@end
