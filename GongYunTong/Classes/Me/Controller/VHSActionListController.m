//
//  VHSActionListController.m
//  GongYunTong
//
//  Created by pingjun lin on 2017/5/3.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import "VHSActionListController.h"
#import "VHSActionCell.h"
#import "VHSDataBaseManager.h"

@interface VHSActionListController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *actionList;

@end

@implementation VHSActionListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"数据库运动信息显示";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.actionList = [NSMutableArray new];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSArray *actionList = [[VHSDataBaseManager shareInstance] queryStepWithMemberId:[VHSCommon userInfo].memberId.stringValue];
    [self.actionList addObjectsFromArray:actionList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.actionList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VHSActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VHSActionCell"];
    
    VHSActionData *action = self.actionList[indexPath.row];
    cell.action = action;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 290;
}

@end
