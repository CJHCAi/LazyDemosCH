//
//  AppendServiceViewController.m
//  FamilyTree
//
//  Created by 姚珉 on 16/8/6.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "AppendServiceViewController.h"
#import "GeoTableViewCell.h"

@interface AppendServiceViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

/** 底部滚动视图*/
@property (nonatomic, strong) UIScrollView *backSV;
/** 首块白色背景*/
@property (nonatomic, strong) UIView *firstBackV;
/** 项目类型按钮*/
@property (nonatomic, strong) UIButton *projectTypeBtn;
/** 年按钮*/
@property (nonatomic, strong) UIButton *yearBtn;
/** 月按钮*/
@property (nonatomic, strong) UIButton *monthBtn;
/** 日按钮*/
@property (nonatomic, strong) UIButton *dayBtn;
/** 项目地点文本框*/
@property (nonatomic, strong) UITextField *projectAddressTF;
/** 项目预算按钮*/
@property (nonatomic, strong) UIButton *projectBudgetBtn;
/** 第二个白色背景*/
@property (nonatomic, strong) UIView *secondBackV;
/** 联系人文本*/
@property (nonatomic, strong) UITextField *linkManTF;
/** 电话文本*/
@property (nonatomic, strong) UITextField *telTF;
/** 项目类型表*/
@property (nonatomic, strong) UITableView *projectTypeTB;
/** 年表*/
@property (nonatomic, strong) UITableView *yearTB;
/** 月表*/
@property (nonatomic, strong) UITableView *monthTB;
/** 日表*/
@property (nonatomic, strong) UITableView *dayTB;
/** 项目预算表*/
@property (nonatomic, strong) UITableView *projectBudgetTB;
/** 项目类型数组*/
@property (nonatomic, strong) NSArray *projectTypeArr;
/** 年份数组*/
@property (nonatomic, strong) NSArray *yearArr;
/** 项目预算数组*/
@property (nonatomic, strong) NSArray *projectBudgetArr;
/** 项目类型id*/
@property (nonatomic, assign) NSInteger projectID;
/** 项目预算id*/
@property (nonatomic, assign) NSInteger projectBudgetID;
@end

@implementation AppendServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectID = 0;
    self.projectBudgetID = 0;
    [self initUI];
}

#pragma mark - 视图初始化
-(void)initUI{
    self.view.backgroundColor = LH_RGBCOLOR(235, 236, 237);
    [self.view addSubview:self.backSV];
    [self.backSV addSubview:self.firstBackV];
    //风水鉴定说明
    UITextView *serviceInfoTX = [[UITextView alloc]initWithFrame:CGRectMake(15, 10, Screen_width-30, 55)];
    serviceInfoTX.attributedText = [NSString getLineSpaceStr:@"想要以最合适的价格获得最满意的服务，那么请选择同城家谱。"];
    serviceInfoTX.font = MFont(13);
    serviceInfoTX.editable = NO;
    serviceInfoTX.userInteractionEnabled = NO;
    [self.firstBackV addSubview:serviceInfoTX];
    //项目类型
    UILabel *projectTypeLB = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectYH(serviceInfoTX)+5, 65, 30)];
    projectTypeLB.text = @"项目类型:";
    projectTypeLB.font = MFont(13);
    [self.firstBackV addSubview:projectTypeLB];
    //项目类型按钮
    self.projectTypeBtn = [self creatCustomBtnWithFrame:CGRectMake(CGRectXW(projectTypeLB), CGRectY(projectTypeLB), 90, CGRectH(projectTypeLB))];
    [self.projectTypeBtn setTitle:@"婚庆嫁娶" forState:UIControlStateNormal];
    self.projectTypeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 70, 0, 0);
    self.projectTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    self.projectTypeBtn.tag = 111+0;
    [self.firstBackV addSubview:self.projectTypeBtn];
    //项目时间
    UILabel *projectTimeLB = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectYH(projectTypeLB)+5, 65, 30)];
    projectTimeLB.text = @"项目时间:";
    projectTimeLB.font = MFont(13);
    [self.firstBackV addSubview:projectTimeLB];
    
    //年
    self.yearBtn = [self creatCustomBtnWithFrame:CGRectMake(CGRectXW(projectTimeLB), CGRectY(projectTimeLB), 45, 30)];
    [self.yearBtn setTitle:@"2016" forState:UIControlStateNormal];
    self.yearBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    self.yearBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 35, 0, 0);
    self.yearBtn.tag = 111+1;
    [self.firstBackV addSubview:self.yearBtn];
    
    UILabel *yearLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(self.yearBtn), CGRectY(self.yearBtn), 20, CGRectH(self.yearBtn))];
    yearLB.text = @"年";
    yearLB.font = MFont(13);
    yearLB.textAlignment = NSTextAlignmentCenter;
    [self.firstBackV addSubview:yearLB];
    //月
    self.monthBtn = [self creatCustomBtnWithFrame:CGRectMake(CGRectXW(yearLB), CGRectY(projectTimeLB), 45, 30)];
    [self.monthBtn setTitle:@"1" forState:UIControlStateNormal];
    self.monthBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    self.monthBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 35, 0, 0);
    self.monthBtn.tag = 111+2;
    [self.firstBackV addSubview:self.monthBtn];
    
    UILabel *monthLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(self.monthBtn), CGRectY(self.monthBtn), 20, CGRectH(self.monthBtn))];
    monthLB.text = @"月";
    monthLB.font = MFont(13);
    monthLB.textAlignment = NSTextAlignmentCenter;
    [self.firstBackV addSubview:monthLB];
    //日
    self.dayBtn = [self creatCustomBtnWithFrame:CGRectMake(CGRectXW(monthLB), CGRectY(projectTimeLB), 45, 30)];
    [self.dayBtn setTitle:@"1" forState:UIControlStateNormal];
    self.dayBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    self.dayBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 35, 0, 0);
    self.dayBtn.tag = 111+3;
    [self.firstBackV addSubview:self.dayBtn];
    
    UILabel *dayLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(self.dayBtn), CGRectY(self.dayBtn), 20, CGRectH(self.dayBtn))];
    dayLB.text = @"日";
    dayLB.font = MFont(13);
    dayLB.textAlignment = NSTextAlignmentCenter;
    [self.firstBackV addSubview:dayLB];
    
    //项目地点
    UILabel *projectAddressLB = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectYH(projectTimeLB)+5, 65, 30)];
    projectAddressLB.text = @"项目地点:";
    projectAddressLB.font = MFont(13);
    [self.firstBackV addSubview:projectAddressLB];
    
    self.projectAddressTF = [[UITextField alloc]initWithFrame:CGRectMake(CGRectXW(projectAddressLB), CGRectY(projectAddressLB), CGRectX(dayLB)-CGRectXW(projectTimeLB), 30)];
    self.projectAddressTF.layer.borderColor = LH_RGBCOLOR(215, 215, 215).CGColor;
    self.projectAddressTF.layer.borderWidth = 1;
    [self.firstBackV addSubview:self.projectAddressTF];
    
    //项目预算
    UILabel *projectBudgetLB = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectYH(projectAddressLB)+5, 65, 30)];
    projectBudgetLB.text = @"项目预算:";
    projectBudgetLB.font = MFont(13);
    [self.firstBackV addSubview:projectBudgetLB];
    
    //项目预算按钮
    self.projectBudgetBtn = [self creatCustomBtnWithFrame:CGRectMake(CGRectXW(projectBudgetLB), CGRectY(projectBudgetLB), 90, CGRectH(projectBudgetLB))];
    [self.projectBudgetBtn setTitle:@"0-5" forState:UIControlStateNormal];
    self.projectBudgetBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 70, 0, 0);
    self.projectBudgetBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    self.projectBudgetBtn.tag = 111+4;
    [self.firstBackV addSubview:self.projectBudgetBtn];
    
    //万元
    UILabel *wanyuanLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(self.projectBudgetBtn), CGRectY(self.projectBudgetBtn), 30, 30)];
    wanyuanLB.text = @"万元";
    wanyuanLB.font = MFont(13);
    [self.firstBackV addSubview:wanyuanLB];
    
    [self.secondBackV addSubview:self.linkManTF];
    
    [self.backSV addSubview:self.secondBackV];
    //联系人
    UILabel *linkManLB = [[UILabel alloc]initWithFrame:CGRectMake(30, 20, 55, 30)];
    linkManLB.text = @"联系人:";
    linkManLB.font = MFont(13);
    [self.secondBackV addSubview:linkManLB];
    
    self.linkManTF = [[UITextField alloc]initWithFrame:CGRectMake(CGRectXW(linkManLB), CGRectY(linkManLB), CGRectX(dayLB)-CGRectXW(projectTimeLB), 30)];
    self.linkManTF.layer.borderColor = LH_RGBCOLOR(215, 215, 215).CGColor;
    self.linkManTF.layer.borderWidth = 1;
    self.linkManTF.delegate = self;
    [self.secondBackV addSubview:self.linkManTF];
    //电话
    UILabel *telLB = [[UILabel alloc]initWithFrame:CGRectMake(40, CGRectYH(linkManLB)+15, 45, 30)];
    telLB.text = @"电话:";
    telLB.font = MFont(13);
    [self.secondBackV addSubview:telLB];
    
    self.telTF = [[UITextField alloc]initWithFrame:CGRectMake(CGRectXW(telLB), CGRectY(telLB), CGRectW(self.linkManTF), 30)];
    self.telTF.layer.borderColor = LH_RGBCOLOR(215, 215, 215).CGColor;
    self.telTF.layer.borderWidth = 1;
    self.telTF.delegate = self;
    [self.secondBackV addSubview:self.telTF];
    
    //提交按钮
    UIButton *postBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectYH(self.secondBackV)+10, Screen_width-20, 39)];
    postBtn.backgroundColor = LH_RGBCOLOR(74, 88, 92);
    [postBtn setTitle:@"提交" forState:UIControlStateNormal];
    [postBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    postBtn.titleLabel.font = MFont(15);
    [postBtn addTarget:self action:@selector(clickToPost) forControlEvents:UIControlEventTouchUpInside];
    [self.backSV addSubview:postBtn];
}

#pragma mark - 点击方法
-(void)clickToSelect:(UIButton *)sender{
    sender.selected = !sender.selected;
    UITableView *tableView = (UITableView *)[self.view viewWithTag:sender.tag-111+222];
    if (sender.selected) {
        switch (sender.tag-111) {
                //项目类型
            case 0:
                [self.view addSubview:self.projectTypeTB];
                break;
            case 1:
                [self.view addSubview:self.yearTB];
                break;
            case 2:
                [self.view addSubview:self.monthTB];
                break;
            case 3:
                [self.view addSubview:self.dayTB];
                break;
            case 4:
                [self.view addSubview:self.projectBudgetTB];
                break;
            default:
                break;
        }
    }else{
        [self.dayTB reloadData];
        [tableView removeFromSuperview];
    }
    
}

-(void)clickToPost{
    MYLog(@"提交");
    if (IsNilString(self.linkManTF.text)) {
        [SXLoadingView showAlertHUD:@"联系人不能为空" duration:0.5];
    }else if(IsNilString(self.telTF.text)){
        [SXLoadingView showAlertHUD:@"联系电话不能为空" duration:0.5];
    }else{
        [self postData];
    }
    
}

#pragma mark - 请求
-(void)postData{
    NSString *dateTime = [NSString stringWithFormat:@"%@-%02ld-%02ldT00:00:00",self.yearBtn.currentTitle,[self.monthBtn.currentTitle integerValue],[self.dayBtn.currentTitle integerValue]];
    
    NSNumber *budgetID = @[@98,@99,@100,@101,@102,@103,@104,@105,@106,@107][self.projectBudgetID];
    NSNumber *typeID = @[@95,@96,@112,@113,@114,@115][self.projectID];
    
    NSDictionary *logDic = @{@"PsId":@0,
                             @"PsMemberid":GetUserId,
                             @"PsType":@"ZZFW",
                             @"PsProjecttype":typeID,
                             @"PsProjecttime":dateTime,
                             @"PsAreaid":@0,
                             @"PsContacts":self.linkManTF.text,
                             @"PsTel":self.telTF.text,
                             @"PsBudget":budgetID,
                             @"PsAddress":self.projectAddressTF.text,
                             @"PsState":@"",
                             @"PsCreatetime":@"",
                             @"PsKeepstr01":@"",
                             @"PsKeepstr02":@"",
                             @"PsKeepnum01":@0,
                             @"PsKeepnum02":@0,
                             @"PsKeepdate":@""
                             };
    WK(weakSelf)
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:@"zzfwadd" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        //MYLog(@"%@",jsonDic);
        if (succe) {
            [SXLoadingView showAlertHUD:@"提交成功" duration:0.5];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag-222) {
        case 0:
            return self.projectTypeArr.count;
            break;
        case 1:
            return self.yearArr.count;
            break;
        case 2:
            return 12;
            break;
        case 3:
        {
            switch([self.monthBtn.currentTitle integerValue])
            {
                case 1:
                case 3:
                case 5:
                case 7:
                case 8:
                case 10:
                case 12:
                    return 31;
                    break;
                case 4:
                case 6:
                case 9:
                case 11:
                    return 30;
                    break;
                case 2:
                {
                    if((([self.yearBtn.currentTitle integerValue]%4==0)&&([self.yearBtn.currentTitle integerValue]%100!=0))||([self.yearBtn.currentTitle integerValue]%400==0))
                    {
                        return 29;
                        break;
                    }
                    else
                    {
                        return 28;
                        break;
                    }
                }
                default:
                    break;
            }
        }
            case 4:
            return self.projectBudgetArr.count;
            break;
        default:
            return 0;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GeoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"geoCell"];
    if (!cell) {
        cell = [[GeoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"geoCell"];
    }
    switch (tableView.tag - 222) {
        case 0:
            cell.customLB.text = self.projectTypeArr[indexPath.row];
            cell.customLB.frame = CGRectMake(0, 0, 65, 30);
            break;
        case 1:
            cell.customLB.text = [NSString stringWithFormat:@"%@",self.yearArr[indexPath.row]];
            break;
        case 2:
        case 3:
            cell.customLB.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
            break;
        case 4:
            cell.customLB.text = self.projectBudgetArr[indexPath.row];
            cell.customLB.frame = CGRectMake(0, 0, 65, 30);
            break;
        default:
            break;
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.projectTypeTB]) {
        self.projectID = indexPath.row;
    }
    if ([tableView isEqual:self.projectBudgetTB]) {
        self.projectBudgetID = indexPath.row;
    }
    GeoTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *button = (UIButton *)[self.view viewWithTag:111+tableView.tag-222];
    button.selected = !button.selected;
    [button setTitle:cell.customLB.text forState:UIControlStateNormal];
    [self.dayTB reloadData];
    [tableView removeFromSuperview];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:self.telTF]) {
        return [NSString validateNumber:string];
    }else{
        return YES;
    }
    
}

-(void)closeKeyboard{
    [self.view endEditing:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    MYLog(@"将要开始编辑");
    if ([textField isEqual:self.linkManTF]||[textField isEqual:self.telTF]) {
        if (self.backSV.frame.origin.y == 64) {
            [UIView animateWithDuration:1 animations:^{
                CGRect frame =  self.backSV.frame;
                frame.origin.y = 64-216+20;
                self.backSV.frame = frame;
            }];
        }
    }
}

-(void)textFieldDidEndEditing:(UITextView *)textField{
    MYLog(@"结束编辑");
    if ([textField isEqual:self.linkManTF]||[textField isEqual:self.telTF]){
        if (self.backSV.frame.origin.y !=64) {
            [UIView animateWithDuration:1 animations:^{
                CGRect frame =  self.backSV.frame;
                frame.origin.y = 64;
                self.backSV.frame = frame;
            }];
        }
    }
}


#pragma mark - lazyLoad
-(UIScrollView *)backSV{
    if (!_backSV) {
        _backSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-49)];
        _backSV.backgroundColor = LH_RGBCOLOR(235, 236, 237);
        _backSV.contentSize = CGSizeMake(Screen_width, 460);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
        [_backSV addGestureRecognizer:tap];
    }
    return _backSV;
}

-(UIView *)firstBackV{
    if (!_firstBackV) {
        _firstBackV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 220)];
        _firstBackV.backgroundColor = [UIColor whiteColor];
    }
    return _firstBackV;
}

-(UIView *)secondBackV{
    if (!_secondBackV) {
        _secondBackV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectYH(self.firstBackV)+10, Screen_width, 105)];
        _secondBackV.backgroundColor = [UIColor whiteColor];
    }
    return _secondBackV;
}

-(UITableView *)projectTypeTB{
    if (!_projectTypeTB) {
        _projectTypeTB = [[UITableView alloc]initWithFrame:CGRectMake(CGRectX(self.projectTypeBtn), CGRectYH(self.projectTypeBtn)+64, CGRectW(self.projectTypeBtn), 100)];
        _projectTypeTB.dataSource = self;
        _projectTypeTB.delegate = self;
        _projectTypeTB.tag = 222+0;
        _projectTypeTB.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _projectTypeTB;
}

-(UITableView *)yearTB{
    if (!_yearTB) {
        _yearTB = [[UITableView alloc]initWithFrame:CGRectMake(CGRectX(self.yearBtn), CGRectYH(self.yearBtn)+64, CGRectW(self.yearBtn), 100)];
        _yearTB.dataSource = self;
        _yearTB.delegate = self;
        _yearTB.tag = 222+1;
        _yearTB.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _yearTB;
}

-(UITableView *)monthTB{
    if (!_monthTB) {
        _monthTB = [[UITableView alloc]initWithFrame:CGRectMake(CGRectX(self.monthBtn), CGRectYH(self.monthBtn)+64, CGRectW(self.monthBtn), 100)];
        _monthTB.dataSource = self;
        _monthTB.delegate = self;
        _monthTB.tag = 222+2;
        _monthTB.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _monthTB;
}

-(UITableView *)dayTB{
    if (!_dayTB) {
        _dayTB = [[UITableView alloc]initWithFrame:CGRectMake(CGRectX(self.dayBtn), CGRectYH(self.dayBtn)+64, CGRectW(self.dayBtn), 100)];
        _dayTB.dataSource = self;
        _dayTB.delegate = self;
        _dayTB.tag = 222+3;
        _dayTB.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _dayTB;
}

-(UITableView *)projectBudgetTB{
    if (!_projectBudgetTB) {
        _projectBudgetTB = [[UITableView alloc]initWithFrame:CGRectMake(CGRectX(self.projectBudgetBtn), CGRectYH(self.projectBudgetBtn)+64, CGRectW(self.projectBudgetBtn), 100)];
        _projectBudgetTB.dataSource = self;
        _projectBudgetTB.delegate = self;
        _projectBudgetTB.tag = 222+4;
        _projectBudgetTB.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _projectBudgetTB;
}


-(NSArray *)projectTypeArr{
    if (!_projectTypeArr) {
        _projectTypeArr = @[@"婚庆嫁娶",@"生日寿宴",@"白事丧葬",@"祭祀法事",@"家族团购",@"户外拓展"];
    }
    return _projectTypeArr;
}

-(NSArray *)yearArr{
    if (!_yearArr) {
        NSMutableArray *array = [@[] mutableCopy];
        for (int i = 0; i < 20; i++) {
            [array addObject:[NSString stringWithFormat:@"%d",2016+i]];
        }
        _yearArr = [array copy];
    }
    return _yearArr;
}

-(NSArray *)projectBudgetArr{
    if (!_projectBudgetArr) {
        _projectBudgetArr = @[@"0-5",@"5-10",@"10-15",@"15-20",@"20-25",@"25-30",@"30-35",@"35-40",@"40-45",@"45-50"];
    }
    return _projectBudgetArr;
}

//重写个button方法
-(UIButton *)creatCustomBtnWithFrame:(CGRect)frame{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    button.layer.borderColor = LH_RGBCOLOR(215, 215, 215).CGColor;
    button.layer.borderWidth = 1;
    button.titleLabel.font = MFont(13);
    [button setImage:MImage(@"wdhz_jiantou") forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickToSelect:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end





