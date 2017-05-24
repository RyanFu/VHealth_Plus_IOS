//
//  VHSPersonInfoController.m
//  GongYunTong
//
//  Created by ios-bert on 16/7/22.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "VHSPersonInfoController.h"
#import "VHSDynamicHomeController.h"
#import "VHSLaunchViewController.h"
#import "MBProgressHUD+VHS.h"
#import "VHSModifyInfoController.h"
#import "VHSFitBraceletStateManager.h"
#import "VHSLocatServicer.h"

@interface VHSPersonInfoController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tvPerson;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (nonatomic, strong)NSArray *arrPersonInfo;
@property (nonatomic, strong)UIImageView *ivPhoto;
@property (nonatomic, strong)NSIndexPath *idxPath;
@property (nonatomic, strong)NSMutableDictionary *dicPage;
@property (nonatomic, strong)UIPickerView *pvHeight;
@property (nonatomic, strong)UIPickerView *pvWeight;
@property (nonatomic, strong)UIView *secondaryView;
@property (nonatomic, strong)NSArray *arrHeight;
@property (nonatomic, strong)NSArray *arrWeight;
@property (nonatomic, strong)NSArray *arrSmallWeight;
@property (nonatomic, strong)UIDatePicker *datePicker;
@property (nonatomic, strong)UIImage *headImage;

@end

@implementation VHSPersonInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人信息";
    
    self.dicPage = [[NSMutableDictionary alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tvPerson.delegate = self;
    self.tvPerson.dataSource = self;
    
    // tableView 的头部视图
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 15)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    self.tvPerson.tableHeaderView = headerView;
    
    CALayer *deadlineLayer = [[CALayer alloc] init];
    deadlineLayer.frame = CGRectMake(0, CGRectGetHeight(headerView.frame) - 0.5, SCREENW, 0.5);
    deadlineLayer.backgroundColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    [headerView.layer addSublayer:deadlineLayer];
    
    // footerView 添加线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.footerView addSubview:line];
    
    self.ivPhoto = [[UIImageView  alloc] init];
    self.ivPhoto.frame = CGRectMake(SCREENW - 65, 7, 30, 30);
    self.ivPhoto.layer.masksToBounds = YES;
    self.ivPhoto.backgroundColor = [UIColor clearColor];
    self.ivPhoto.layer.cornerRadius = 5;
    
    // 画面下方视图
    self.secondaryView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height , self.view.frame.size.width, self.view.frame.size.height / 2)];
    self.secondaryView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.secondaryView];
    self.secondaryView.hidden = YES;
    
    // 下方的取消按钮
    UIButton *btnCancel = [[UIButton alloc] init];
    btnCancel.layer.cornerRadius = 6;
    btnCancel.layer.masksToBounds = YES;
    btnCancel.frame = CGRectMake(0, 0, 60, 30);
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(btnCancelClicked) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel setTitleColor:COLORHex(@"#007aff") forState:UIControlStateNormal];
    btnCancel.backgroundColor = [UIColor clearColor];
    [self.secondaryView addSubview:btnCancel];
    
    // 下方的确定按钮
    UIButton *btnSelect = [[UIButton alloc] init];
    btnSelect.layer.cornerRadius = 6;
    btnSelect.layer.masksToBounds = YES;
    btnSelect.frame = CGRectMake(self.secondaryView.frame.size.width - 60, 0, 60, 30);
    [btnSelect setTitle:@"确定" forState:UIControlStateNormal];
    [btnSelect addTarget:self action:@selector(btnSelectClicked) forControlEvents:UIControlEventTouchUpInside];
    [btnSelect setTitleColor:COLORHex(@"#007aff") forState:UIControlStateNormal];
    btnSelect.backgroundColor = [UIColor clearColor];
    [self.secondaryView addSubview:btnSelect];
    
    // 身高数组
    NSMutableArray *arrHeightTmp = [[NSMutableArray alloc] init];
    for (int i = 120; i <= 250; i++) {
        NSString *strHeight = [NSString stringWithFormat:@"%d",i];
        [arrHeightTmp addObject:strHeight];
    }
    self.arrHeight = [[NSArray alloc] initWithArray:(NSArray *)arrHeightTmp];
    
    
    // 体重
    NSMutableArray *arrWeightTmp = [[NSMutableArray alloc] init];
    for (int j = 30; j<= 200; j++) {
        NSString *strWeight = [NSString stringWithFormat:@"%d",j];
        [arrWeightTmp addObject:strWeight];
    }
    self.arrWeight = [[NSArray alloc] initWithArray:(NSArray *)arrWeightTmp];
    self.arrSmallWeight = [NSArray arrayWithObjects:@".0",@".5", nil];
    
    // 身高选择器
    self.pvHeight = [[UIPickerView alloc] init];
    self.pvHeight.frame = CGRectMake(0, 37, self.secondaryView.frame.size.width, SCREENH/2-37);
    self.pvHeight.tag = 10001;
    self.pvHeight.backgroundColor = [UIColor clearColor];
    self.pvHeight.delegate = self;
    self.pvHeight.dataSource = self;
    self.pvHeight.hidden = YES;
    [self.pvHeight selectRow:50 inComponent:0 animated:YES];
    [self.secondaryView addSubview:self.pvHeight];
    
    
    // 体重选择器
    self.pvWeight = [[UIPickerView alloc] init];
    self.pvWeight.frame = CGRectMake(0, 37, self.secondaryView.frame.size.width, SCREENH/2-37);
    self.pvWeight.tag = 10002;
    self.pvWeight.backgroundColor = [UIColor clearColor];
    self.pvWeight.delegate = self;
    self.pvWeight.dataSource = self;
    self.pvWeight.hidden = YES;
  
    [self.pvWeight selectRow:40 inComponent:0 animated:NO];
    [self.pvWeight selectRow:0 inComponent:1 animated:NO];
    [self.secondaryView addSubview:self.pvWeight];
    
    
    // 出生年月选择器
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.frame = CGRectMake(0, 37, self.secondaryView.frame.size.width, SCREENH/2-37);
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.backgroundColor = [UIColor clearColor];
    self.datePicker.hidden = YES;
    NSDate *date = [NSDate date];
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents *components;
    
    NSString *userBirthday=[self.dicPage objectForKey:@"birth"];
    
    
    if (userBirthday == nil || userBirthday.length < 2) {
        components =[calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                fromDate:date];
        NSInteger year = [components year];
        NSInteger month = [components month];
        NSInteger day = [components day];
        [components setDay:day];
        [components setMonth:month];
        [components setYear:year - 30];
    } else {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd";
        NSDate *dateStr = [format dateFromString:userBirthday];
        if (dateStr==nil) {
            components =[calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                    fromDate:date];
            NSInteger year = [components year];
            NSInteger month = [components month];
            NSInteger day = [components day];
            [components setDay:day];
            [components setMonth:month];
            [components setYear:year - 30];
        }else{
            components =[calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                    fromDate:dateStr];
        }
    }
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *dateNew = [gregorian dateFromComponents:components];
    [self.datePicker setDate:dateNew animated:YES];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    
    NSDateFormatter *formatMM = [[NSDateFormatter alloc] init];
    formatMM.dateFormat = @"MM-dd";
    NSString *str = [NSString stringWithFormat:@"1961-%@",[formatMM stringFromDate:date]];
    
    self.datePicker.minimumDate = [format dateFromString:str];
    self.datePicker.maximumDate = date;
    
    [self.secondaryView addSubview:self.datePicker];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (NSArray *)arrPersonInfo {
    if (!_arrPersonInfo) {

        _arrPersonInfo = @[@"头像",
                           @"昵称",
                           @"手机号",
                           @"邮箱",
                           @"员工号",
                           @"性别",
                           @"身高",
                           @"体重",
                           @"出生年月",
                           @"企业",
                           @"层级二",
                           @"层级三",
                           @"层级四"];
    }
    return _arrPersonInfo;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    switch (section) {
        case 0:
            num = 5;
            
            break;
        case 1:
            num = 4;
            
            break;
        case 2:
            num = [self.detailModel.depts count] + 1;
            break;
        default:
            break;
    }
    
    return num;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    // 行点击时无背景
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#212121"];
    cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#828282"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section) {
        case 0:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (indexPath.row == 0) {
                [cell.contentView addSubview:self.ivPhoto];
                if (!self.headImage) {
                    [self.ivPhoto sd_setImageWithURL:[NSURL URLWithString:self.detailModel.headerUrl]];
                } else {
                    self.ivPhoto.image = self.headImage;
                }
            }
            else if (indexPath.row == 1) {
                cell.detailTextLabel.text = self.detailModel.nickName;
            }
            else if (indexPath.row == 2) {
                cell.detailTextLabel.text = self.detailModel.mobile;
            }
            else if (indexPath.row == 3) {
                cell.detailTextLabel.text = self.detailModel.email;
            }
            else if (indexPath.row == 4) {
                cell.detailTextLabel.text = self.detailModel.workNo;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            cell.textLabel.text = self.arrPersonInfo[indexPath.row];
            break;
        case 1:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = self.arrPersonInfo[indexPath.row+5];
            if (indexPath.row == 0) {
                if ([self.detailModel.gender intValue] == 1) {
                    cell.detailTextLabel.text = @"男";
                } else if ([self.detailModel.gender intValue] == 0) {
                    cell.detailTextLabel.text = @"女";
                }
            }
            else if (indexPath.row == 1) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ cm", self.detailModel.height ? self.detailModel.height : @(0)];
            }
            else if (indexPath.row == 2) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ kg", self.detailModel.weight ? self.detailModel.weight : @(0)];
            }
            else if (indexPath.row == 3) {
                cell.detailTextLabel.text = self.detailModel.birthday;
            }
            break;
        case 2:
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            if (indexPath.row == 0) {
                // 公司名
                cell.textLabel.text = _arrPersonInfo[indexPath.row + 9];
                cell.detailTextLabel.text = self.detailModel.companyName;
            } else {
                NSDictionary *deptDic = self.detailModel.depts[indexPath.row - 1];
                cell.textLabel.text = deptDic[@"levelName"];
                cell.detailTextLabel.text = deptDic[@"deptName"];
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:
            self.idxPath = indexPath;
            if (indexPath.row == 0) {
                UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
                [action showInView:self.view];
            }
            else if (indexPath.row == 1) {
                // 昵称
                cell = [tableView cellForRowAtIndexPath:indexPath];
                VHSModifyInfoController *modifyVC = (VHSModifyInfoController *)[VHSStoryboardHelper controllerWithStoryboardName:@"Me" controllerId:@"VHSModifyInfoController"];
                modifyVC.modifyType = VHSModifyInfoNormalType;
                modifyVC.cellType = VHSCellNickNameType;
                modifyVC.callBack = ^(NSString *str) {
                    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    cell.detailTextLabel.text = str;
                    if (self.updateNickNameBlock) self.updateNickNameBlock(str);
                };
                modifyVC.title = @"昵称";
                modifyVC.contentStr = cell.detailTextLabel.text;
                [self.navigationController pushViewController:modifyVC animated:YES];
            }
            else if (indexPath.row == 2) {
                // 手机号
                cell = [tableView cellForRowAtIndexPath:indexPath];
                VHSModifyInfoController *modifyVC = (VHSModifyInfoController *)[VHSStoryboardHelper controllerWithStoryboardName:@"Me" controllerId:@"VHSModifyInfoController"];
                modifyVC.modifyType = VHSModifyInfoMobileType;
                modifyVC.cellType = VHSCellMobileType;
                modifyVC.callBack = ^(NSDictionary *dict) {
                    NSString *mobile = dict[@"mobile"];
                    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    cell.detailTextLabel.text = mobile;
                    self.detailModel.mobile = mobile;
                };
                modifyVC.title = @"手机号";
                modifyVC.contentDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:cell.detailTextLabel.text, @"mobile", nil];
                [self.navigationController pushViewController:modifyVC animated:YES];
            }
            else if (indexPath.row == 3) {
                // 邮箱
                cell = [tableView cellForRowAtIndexPath:indexPath];
                VHSModifyInfoController *modifyVC = (VHSModifyInfoController *)[VHSStoryboardHelper controllerWithStoryboardName:@"Me" controllerId:@"VHSModifyInfoController"];
                modifyVC.cellType = VHSCellEmailType;
                modifyVC.modifyType = VHSModifyInfoNormalType;
                modifyVC.callBack = ^(NSString *str) {
                    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    cell.detailTextLabel.text = str;
                    self.detailModel.email = str;
                };
                modifyVC.title = @"邮箱";
                modifyVC.contentStr = cell.detailTextLabel.text;
                [self.navigationController pushViewController:modifyVC animated:YES];
            }
            break;
        case 1:
            self.idxPath = indexPath;
            if (indexPath.row == 0) {
                UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"性别选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
                action.actionSheetStyle = UIActionSheetStyleAutomatic;
                [action showInView:self.view];
            }
            else {
                [self showDataPicker];
            }
            break;

        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 20.0;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 20)];
    view.backgroundColor = [UIColor clearColor];
    
    UIView *headline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 0.5)];
    headline.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    [view addSubview:headline];
    
    UIView *footerline = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(view.frame) - 0.5, SCREENW, 0.5)];
    footerline.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    [view addSubview:footerline];
    
    return view;
}

#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.idxPath.section == 0) {
        if (buttonIndex == 0) {
            [self takePhoto];
        }
        else if(buttonIndex == 1){
            [self choosePhoto];
        }
        else {
            [self.tvPerson deselectRowAtIndexPath:[self.tvPerson indexPathForSelectedRow] animated:YES];
        }
    } else {
        if( buttonIndex == 0){
            [self uploadPersonInfo:@{@"genderv" : @"1"} uploadSuccess:^{
                UITableViewCell *cell = (UITableViewCell *)[self.tvPerson cellForRowAtIndexPath:self.idxPath];
                cell.detailTextLabel.text = @"男";
                self.detailModel.gender = @(1);
            }];
        }
        else if(buttonIndex == 1){
            [self uploadPersonInfo:@{@"genderv" : @"0"} uploadSuccess:^{
                UITableViewCell *cell = (UITableViewCell *)[self.tvPerson cellForRowAtIndexPath:self.idxPath];
                cell.detailTextLabel.text = @"女";
                self.detailModel.gender = @(0);
            }];
        }
        [self.tvPerson deselectRowAtIndexPath:[self.tvPerson indexPathForSelectedRow] animated:YES];
    }
}

#pragma mark - UIPicker delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView.tag == 10002) {
        return 2;
    }
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 10001) {
        return self.arrHeight.count;
    }
    else if (pickerView.tag == 10002){
        if(component == 0){
            return [self.arrWeight count];
        }
        else {
            return [self.arrSmallWeight count];
        }
    }
    return 2;
    
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 10001) {
        return [self.arrHeight objectAtIndex:row];
    }
    else if (pickerView.tag == 10002){
        if(component == 0){
            return [self.arrWeight objectAtIndex:row];
        }
        else {
            return [self.arrSmallWeight objectAtIndex:row];
        }
    }
    
    return [self.arrHeight objectAtIndex:row];
}


// 显示下方选择器视图
- (void)showDataPicker
{
    self.tvPerson.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.secondaryView.hidden = NO;
        self.pvHeight.hidden = YES;
        self.pvWeight.hidden = YES;
        self.datePicker.hidden = YES;
        if (self.idxPath.section == 1) {
            switch (self.idxPath.row) {
                case 1:
                    self.pvHeight.hidden = NO;
                    break;
                    
                case 2:
                    self.pvWeight.hidden = NO;
                    break;
                    
                case 3:
                    self.datePicker.hidden = NO;
                    self.datePicker.date = [VHSCommon dateWithDateStr:@"1990-01-01 00:00:00"];
                    break;
                    
                default:
                    break;
            }
        }
        self.secondaryView.frame = CGRectMake(0, self.view.frame.size.height / 2, SCREENW, self.view.frame.size.height / 2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            
        }];
    }];
}

// 下方取消按钮点击时
- (void)btnCancelClicked
{
    // 隐藏下方选择器视图
    [self hiddenDataPicker];
}

// 下方确定按钮点击时
- (void)btnSelectClicked
{
    UITableViewCell *cell = (UITableViewCell *)[self.tvPerson cellForRowAtIndexPath:self.idxPath];
    
    if (self.idxPath.section == 1) {
        switch (self.idxPath.row) {
            case 1:
            {
                NSInteger row = [self.pvHeight selectedRowInComponent:0];
                NSString *value = [NSString stringWithFormat:@"%@",[self.arrHeight objectAtIndex:row]];
                [self uploadPersonInfo:@{@"heightv" : value} uploadSuccess:^{
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ cm", value];
                    self.detailModel.height = [NSNumber numberWithInteger:[value integerValue]];
                }];
                [self.dicPage setObject:[self.arrHeight objectAtIndex:row] forKey:@"height"];
            }
                break;
                
            case 2:
            {
                NSInteger row = [self.pvWeight selectedRowInComponent:0];
                NSInteger rowSmall = [self.pvWeight selectedRowInComponent:1];
                NSString *strWeight = [NSString stringWithFormat:@"%@%@",[self.arrWeight objectAtIndex:row],[self.arrSmallWeight objectAtIndex:rowSmall]];
                [self uploadPersonInfo:@{@"weightv" : strWeight} uploadSuccess:^{
                    NSString *value = [NSString stringWithFormat:@"%@ kg",strWeight];
                    cell.detailTextLabel.text = value;
                    self.detailModel.weight = [NSNumber numberWithDouble:[strWeight doubleValue]];
                }];
                [self.dicPage setObject:strWeight forKey:@"weight"];
            }
                break;
                
            case 3:
            {
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
                [format setDateFormat:@"yyyy-MM-dd"];
                NSString *strDate = [format stringFromDate:[self.datePicker date]];
                [self uploadPersonInfo:@{@"birthdayv" : strDate} uploadSuccess:^{
                    cell.detailTextLabel.text = strDate;
                    self.detailModel.birthday = strDate;
                }];
                [self.dicPage setObject:strDate forKey:@"birth"];
            }
                break;
                
            default:
                break;
        }
    }
    // 隐藏下方选择器视图
    [self hiddenDataPicker];
}

// 隐藏下方选择器视图
- (void)hiddenDataPicker{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.secondaryView.frame = CGRectMake(0, self.tvPerson.frame.size.height, self.secondaryView.frame.size.width, self.secondaryView.frame.size.height);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.secondaryView.hidden = YES;
            if (self.idxPath.section == 1) {
                switch (self.idxPath.row) {
                    case 1:
                        self.pvHeight.hidden = YES;
                        break;
                        
                    case 2:
                        self.pvWeight.hidden = YES;
                        break;
                        
                    case 3:
                        self.datePicker.hidden = YES;
                        break;
                        
                    default:
                        break;
                }
            }
        }];
    }];
    
    [self.tvPerson deselectRowAtIndexPath:[self.tvPerson indexPathForSelectedRow] animated:YES];
    self.tvPerson.userInteractionEnabled = YES;
}


#pragma mark - UIImagePickerController  Delegate
// 拍照处理
-(void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
        imagepicker.delegate = self;
        imagepicker.allowsEditing = YES;
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagepicker animated:YES completion:^{}];
    }
}

// 选取照片处理
- (void)choosePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:^{}];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __block UIImage *photoImage = nil;
    [picker dismissViewControllerAnimated:YES completion:^{
        // 设置照片按钮信息
        self.headImage = [VHSUtils image:[info objectForKey:UIImagePickerControllerEditedImage] scaleToSize:CGSizeMake(62, 62)];
        self.ivPhoto.image = self.headImage;
        photoImage = self.headImage;
        
        VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
        if (photoImage) {
            message.imageMap = @{@"pictrueFile" : photoImage};
        }
        message.path = URL_ADD_HEADER;
        message.httpMethod = VHSNetworkUpload;
        
        [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
            [VHSToast toast:result[@"info"]];
            
            if ([result[@"result"] integerValue] != 200) return;
            
            NSString *headerUrl = result[@"headerUrl"];
            if (self.uploadHeadBlock) self.uploadHeadBlock(headerUrl);
            
        } fail:^(NSError *error) {}];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 修改个人信息

- (void)uploadPersonInfo:(NSDictionary *)uploadInfo uploadSuccess:(void (^)())uploadSuccess {
    
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.params = uploadInfo;
    message.path = URL_UP_MEMBER;
    message.httpMethod = VHSNetworkPOST;
    
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        
        [VHSToast toast:result[@"info"]];
        
        if ([result[@"result"] integerValue] != 200) return;
        
        if (uploadSuccess) {
            uploadSuccess();
        }
        
        // 修改身高体重，性别，产生新的步幅
        float stride = [result[@"stride"] floatValue];
        if (stride) {
            [VHSCommon saveUserDefault:result[@"stride"] forKey:k_Steps_To_Kilometre_Ratio];
        }

    } fail:^(NSError *error) {}];
    
}

@end
