//
//  VHSLoginPersonalViewController.m
//  GongYunTong
//
//  Created by ios-bert on 16/7/28.
//  Copyright © 2016年 lucky. All rights reserved.
//

#import "VHSLoginPersonalViewController.h"
#import "VHSLoginPersonCell.h"
#import "MBProgressHUD+VHS.h"
#import "UserInfoModel.h"
#import "VHSTabBarController.h"

@interface VHSLoginPersonalViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tvFirstPerson;

@property(nonatomic,strong)NSArray *arrInfo;
@property(nonatomic,strong)NSIndexPath *idxPath;

@property(nonatomic,strong)NSMutableDictionary *dicPage;
@property(nonatomic,strong)UIPickerView *pvHeight;
@property(nonatomic,strong)UIPickerView *pvWeight;
@property(nonatomic,strong)UIView *secondaryView;
@property(nonatomic,strong)NSArray *arrHeight;
@property(nonatomic,strong)NSArray *arrWeight;
@property(nonatomic,strong)NSArray *arrSmallWeight;
@property(nonatomic,strong)UIDatePicker *datePicker;

@end

@implementation VHSLoginPersonalViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dicPage = [[NSMutableDictionary alloc] init];
    UIView *headerView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tvFirstPerson.bounds.size.width, 70)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 30)];
    lb.backgroundColor = [UIColor clearColor];
    lb.text = @"初次使用请完善以下信息";
    lb.textColor = [UIColor colorWithHexString:@"#212121"];
    lb.font = [UIFont boldSystemFontOfSize:18];
    lb.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:lb];
    self.tvFirstPerson.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tvFirstPerson.tableFooterView = footerView;
    self.tvFirstPerson.backgroundColor = [UIColor clearColor];
    
    UIButton *btnLogin= [UIButton buttonWithType:UIButtonTypeCustom];
    btnLogin.layer.cornerRadius = 6;
    btnLogin.layer.masksToBounds = YES;
    btnLogin.frame = CGRectMake(10, 10, SCREEN_WIDTH - 100, 50);
    btnLogin.center = CGPointMake(SCREEN_WIDTH / 2, 30);
    [btnLogin setImage:[UIImage imageNamed:@"btn_startuse_s"] forState:UIControlStateNormal];
    [btnLogin addTarget:self action:@selector(btnLoginClicked) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btnLogin];

    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downKyboard)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [self.tvFirstPerson addGestureRecognizer:tableViewGesture];

    // 画面下方视图
    self.secondaryView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height , SCREEN_WIDTH, self.view.frame.size.height / 2)];
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
    [btnCancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnCancel.backgroundColor = [UIColor clearColor];
    [self.secondaryView addSubview:btnCancel];
    
    // 下方的确定按钮
    UIButton *btnSelect = [[UIButton alloc] init];
    btnSelect.layer.cornerRadius = 6;
    btnSelect.layer.masksToBounds = YES;
    btnSelect.frame = CGRectMake(self.secondaryView.frame.size.width - 60, 0, 60, 30);
    [btnSelect setTitle:@"确定" forState:UIControlStateNormal];
    [btnSelect addTarget:self action:@selector(btnSelectClicked) forControlEvents:UIControlEventTouchUpInside];
    [btnSelect setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
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
    self.pvHeight.frame = CGRectMake(0, 37, self.secondaryView.frame.size.width, SCREEN_HEIGHT/2-37);
    self.pvHeight.tag = 10001;
    self.pvHeight.backgroundColor = [UIColor clearColor];
    self.pvHeight.delegate = self;
    self.pvHeight.dataSource = self;
    self.pvHeight.hidden = YES;
    [self.pvHeight selectRow:50 inComponent:0 animated:YES];
    [self.secondaryView addSubview:self.pvHeight];
    
    // 体重选择器
    self.pvWeight = [[UIPickerView alloc] init];
    self.pvWeight.frame = CGRectMake(0, 37, self.secondaryView.frame.size.width, SCREEN_HEIGHT/2-37);
    self.pvWeight.tag = 10002;
    self.pvWeight.backgroundColor = [UIColor clearColor];
    self.pvWeight.delegate = self;
    self.pvWeight.dataSource = self;
    self.pvWeight.hidden = YES;
   
    [self.pvWeight selectRow:30 inComponent:0 animated:NO];
    [self.pvWeight selectRow:0 inComponent:1 animated:NO];
    [self.secondaryView addSubview:self.pvWeight];
    
    
    // 出生年月选择器
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.frame = CGRectMake(0, 37, self.secondaryView.frame.size.width, SCREEN_HEIGHT/2-37);
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.backgroundColor = [UIColor clearColor];
    self.datePicker.hidden = YES;
    NSDate *date = [NSDate date];
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents *components;
    
    NSString *userBirthday=[self.dicPage objectForKey:@"birthdayv"];
    
    
    if (userBirthday==nil || userBirthday.length<2) {
        components =[calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                fromDate:date];
        NSInteger year = [components year];
        NSInteger month = [components month];
        NSInteger day = [components day];
        [components setDay:day];
        [components setMonth:month];
        [components setYear:year - 30];
        
    }else{
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd";
        
        NSDate *dateStr = [format dateFromString:userBirthday];
        
        NSLog(@"dateStr %@ ",dateStr);
        
        
        if (dateStr==nil) {
            components =[calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay)
                                    fromDate:date];
            NSInteger year = [components year];
            NSInteger month = [components month];
            NSInteger day = [components day];
            [components setDay:day];
            [components setMonth:month];
            [components setYear:year - 30];
        }else{
            components =[calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay)
                                    fromDate:dateStr];
        }
    }
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *dateNew = [gregorian dateFromComponents:components];
    [self.datePicker setDate:dateNew animated:YES];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    self.datePicker.minimumDate = [format dateFromString:@"1916-01-01"];
    self.datePicker.maximumDate = date;
    
    [self.secondaryView addSubview:self.datePicker];
}

-(void)downKyboard
{
    [self.view endEditing:YES];
}

-(NSArray *)arrInfo
{
    if (!_arrInfo) {
        _arrInfo=@[@"性别 *",@"身高 *",@"体重 *",@"出身年月 *"];
    }
    return _arrInfo;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int num = 0;
    switch (section) {
        case 0:
            num = 1;
            
            break;
        case 1:
            num = 4;
            
            break;
        default:
            break;
    }
    
    return num;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        VHSLoginPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VHSLoginPersonCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.txtLoginPerson.delegate = self;
        
        return cell;
    } else {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *tvCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        tvCell.backgroundColor = [UIColor whiteColor];
        tvCell.textLabel.font = [UIFont systemFontOfSize:16];
        tvCell.textLabel.textColor = [UIColor colorWithHexString:@"#212121"];
        tvCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        tvCell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        tvCell.textLabel.text = self.arrInfo[indexPath.row];
        tvCell.detailTextLabel.text = @"请选择";
        
        if (indexPath.row == 0) {
            if (self.model.gender == 1) {
                tvCell.detailTextLabel.text = @"男";
            } else if (self.model.gender == 0) {
                tvCell.detailTextLabel.text = @"女";
            }
            [self.dicPage setObject:[NSNumber numberWithInteger:self.model.gender] forKey:@"genderv"];
        }
        else if (indexPath.row == 1 && self.model.height > 0) {
            tvCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ CM", @(self.model.height)];
            [self.dicPage setObject:[NSNumber numberWithInteger:self.model.height] forKey:@"heightv"];
        }
        else if (indexPath.row == 2 && self.model.weight > 0) {
            tvCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ KG", @(self.model.weight)];
            [self.dicPage setObject:[NSNumber numberWithInteger:self.model.weight] forKey:@"weightv"];
        }
        else if (indexPath.row == 3 && ![VHSCommon isNullString:self.model.birthday]) {
            tvCell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.model.birthday];
            [self.dicPage setObject:self.model.birthday forKey:@"birthdayv"];
        }
        
        return tvCell;
    }

    return nil;

}
#pragma mark - UITableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        self.idxPath = indexPath;
        if (indexPath.row == 0) {
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"性别选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
            [action showInView:self.view];
        }
        else{
            [self showDataPicker];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"修改密码";
    }
    if (section == 1) {
        return @"以下信息只用于计算运动成绩,对外保密";
    }
    return NULL;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 20.0;
    }
    else if (section == 1) {
        return 30.0;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
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
    self.tvFirstPerson.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.secondaryView.hidden = NO;
        self.pvHeight.hidden = YES;
        self.pvWeight.hidden = YES;
        self.datePicker.hidden = YES;
        if (self.idxPath.section == 1) {
            switch (self.idxPath.row) {
                case 1:
                    self.pvHeight.hidden = NO;
                    //                    [self.tvPerson setContentOffset:CGPointMake(0, 165)];
                    break;
                    
                case 2:
                    self.pvWeight.hidden = NO;
                    break;
                    
                case 3:
                    self.datePicker.hidden = NO;
                    [self.datePicker setDate:[VHSCommon dateWithDateStr:@"1990-01-01 00:00:00"]];
                    break;
                    
                default:
                    break;
            }
        }
        self.secondaryView.frame = CGRectMake(0, self.view.frame.size.height / 2, SCREEN_WIDTH, self.view.frame.size.height / 2);
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
    UITableViewCell *cell = (VHSLoginPersonCell *)[self.tvFirstPerson cellForRowAtIndexPath:self.idxPath];
    
    if (self.idxPath.section == 1) {
        switch (self.idxPath.row) {
            case 1:
            {
                NSInteger row = [self.pvHeight selectedRowInComponent:0];
                NSString *value = [NSString stringWithFormat:@"%@ cm ",[self.arrHeight objectAtIndex:row]];
                cell.detailTextLabel.text = value;
                [self.dicPage setObject:[self.arrHeight objectAtIndex:row] forKey:@"heightv"];
            }
                break;
                
            case 2:
            {
                NSInteger row = [self.pvWeight selectedRowInComponent:0];
                NSInteger rowSmall = [self.pvWeight selectedRowInComponent:1];
                NSString *strWeight = [NSString stringWithFormat:@"%@%@",[self.arrWeight objectAtIndex:row],[self.arrSmallWeight objectAtIndex:rowSmall]];
                NSString *value = [NSString stringWithFormat:@"%@ kg",strWeight];
                cell.detailTextLabel.text = value;
                [self.dicPage setObject:strWeight forKey:@"weightv"];
            }
                break;
                
            case 3:
            {
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
                [format setDateFormat:@"yyyy-MM-dd"];
                NSString *strDate = [format stringFromDate:[self.datePicker date]];
                cell.detailTextLabel.text = strDate;
                [self.dicPage setObject:strDate forKey:@"birthdayv"];
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
        
        self.secondaryView.frame = CGRectMake(0, self.tvFirstPerson.frame.size.height, self.secondaryView.frame.size.width, self.secondaryView.frame.size.height);
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
    
    [self.tvFirstPerson deselectRowAtIndexPath:[self.tvFirstPerson indexPathForSelectedRow] animated:YES];
    self.tvFirstPerson.userInteractionEnabled = YES;
}

-(void)btnLoginClicked{
    
    // 校验数据是否填写完全
    if ([[self.dicPage allKeys] count] < 5) {
        [VHSToast toast:TOAST_UNFINISH_USER_INFO];
        return;
    }
    
    // 网络上传数据
    VHSRequestMessage *message = [[VHSRequestMessage alloc] init];
    message.path = URL_ADD_BMI;
    message.params = self.dicPage;
    message.httpMethod = VHSNetworkPOST;
    
    [MBProgressHUD showMessage:nil];
    [[VHSHttpEngine sharedInstance] sendMessage:message success:^(NSDictionary *result) {
        [MBProgressHUD hiddenHUD];
        if ([result[@"result"] integerValue] != 200) {
            [VHSToast toast:result[@"info"]];
            return;
        }
        
        // 修改身高体重，性别，产生新的步幅
        float stride = [result[@"stride"] floatValue];
        if (stride) {
            [k_UserDefaults setObject:result[@"stride"] forKey:k_Steps_To_Kilometre_Ratio];
        }
        
        NSInteger loginNums = [[k_UserDefaults objectForKey:k_LOGIN_NUMBERS] integerValue] + 1;
        ++loginNums;
        [k_UserDefaults setObject:[NSNumber numberWithInteger:loginNums] forKey:k_LOGIN_NUMBERS];
        [k_UserDefaults synchronize];
        
        VHSTabBarController *tabBarVC = (VHSTabBarController *)[StoryboardHelper controllerWithStoryboardName:@"Main" controllerId:@"VHSTabBarController"];
        [self.navigationController pushViewController:tabBarVC animated:YES];

    } fail:^(NSError *error) {
        [MBProgressHUD hiddenHUD];
        [VHSToast toast:TOAST_NETWORK_SUSPEND];
    }];
}

#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if( buttonIndex == 0){
        UITableViewCell *cell = (UITableViewCell *)[self.tvFirstPerson cellForRowAtIndexPath:self.idxPath];
        cell.detailTextLabel.text = @"男";
        [self.dicPage setObject:@"1" forKey:@"genderv"];
    }
    else if(buttonIndex == 1){
        UITableViewCell *cell = (UITableViewCell *)[self.tvFirstPerson cellForRowAtIndexPath:self.idxPath];
        [self.dicPage setObject:@"0" forKey:@"genderv"];
        cell.detailTextLabel.text = @"女";
    }
    [self.tvFirstPerson deselectRowAtIndexPath:[self.tvFirstPerson indexPathForSelectedRow] animated:YES];
}
    

#pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.dicPage setObject:textField.text forKey:@"password"];
    [textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"登录信息页"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"登录信息页"];
}

@end
