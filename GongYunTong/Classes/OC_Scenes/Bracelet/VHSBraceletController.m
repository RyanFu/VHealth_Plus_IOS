//
//  VHSBraceletController.m
//  GongYunTong
//
//  Created by pingjun lin on 2017/2/24.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import "VHSBraceletController.h"
#import "VHSBraceletCoodinator.h"


@interface VHSBraceletController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *bleTableView;

@property (nonatomic, strong) NSArray<VHSBraceletModel *> *braceletList;

@end

@implementation VHSBraceletController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.bleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH) style:UITableViewStylePlain];
    [self.view addSubview:self.bleTableView];
    
    self.bleTableView.delegate = self;
    self.bleTableView.dataSource = self;
    
    // 测试手环模块
    VHSBraceletCoodinator *bleCoodinator = [VHSBraceletCoodinator shareBraceletCoodinator];
    [bleCoodinator scanBraceletorDuration:8.0 completion:^(NSArray<VHSBraceletModel *> *braceletorList) {
        self.braceletList = braceletorList;
        [self.bleTableView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.braceletList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VHSBraceletModel *ble = self.braceletList[indexPath.row];
    
    static NSString *const reuse_identifier = @"VHSBraceletCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse_identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@--%@", ble.name, @(ble.RSSI)];
    
    return cell;
}

@end
