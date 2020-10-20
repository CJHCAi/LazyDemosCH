//
//  ExpertRecommendViewController.m
//  FamilyTree
//
//  Created by 姚珉 on 16/8/6.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "ExpertRecommendViewController.h"
#import "ExpertRecommendTableViewCell.h"
#import "ExpertRecommendAddView.h"
#import "ExpertRecommendEditViewController.h"
#import "ExpertRecommendModel.h"

@interface ExpertRecommendViewController ()<UITableViewDataSource,UITableViewDelegate,ExpertRecommendAddViewDelegate,ExpertRecommendEditViewControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
/** 滚动背景*/
@property (nonatomic, strong) UIScrollView *backSV;
/** 首块背景*/
@property (nonatomic, strong) UIView *firstBackV;
/** 说明*/
@property (nonatomic, strong) UITextView *infoTV;
/** 协议按钮*/
@property (nonatomic, strong) UIButton *protocolBtn;
/** 新添记录*/
@property (nonatomic, strong) UIButton *addBtn;
/** 第二块背景*/
@property (nonatomic, strong) UIView *secondBackV;
/** 标题栏*/
@property (nonatomic, strong) UIView *titleView;
/** 详情表*/
@property (nonatomic, strong) UITableView *infoTB;
/** 新增专家模型*/
@property (nonatomic, strong) ExpertRecommendModel *exModel;
/** 称谓选择器*/
@property (nonatomic, strong) UIPickerView *relationPickV;
/** 称谓数组*/
@property (nonatomic, strong) NSArray *relationArr;
/** 日期选择器*/
@property (nonatomic, strong) UIDatePicker *datePick;
/** 记录数组*/
@property (nonatomic, strong) NSArray<ExpertRecommendModel *> *exArr;
@end

@implementation ExpertRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getListData];
    [self initUI];
}

#pragma mark - 视图初始化
-(void)initUI{
    [self.view addSubview:self.backSV];
    [self.backSV addSubview:self.firstBackV];
    [self.firstBackV addSubview:self.infoTV];
    [self.firstBackV addSubview:self.protocolBtn];
    [self.firstBackV addSubview:self.addBtn];
    [self.backSV addSubview:self.secondBackV];
    [self.secondBackV addSubview:self.titleView];
    [self.secondBackV addSubview:self.infoTB];
    self.infoTB.tableFooterView.hidden = YES;
}

#pragma mark - 请求
-(void)getListData{
    NSDictionary *logDic = @{@"UserId":GetUserId};
    WK(weakSelf)
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:@"expertlist" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"%@",jsonDic);
        if (succe) {
            weakSelf.exArr = [NSArray modelArrayWithClass:[ExpertRecommendModel class] json:jsonDic[@"data"]];
            [weakSelf.infoTB reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)postNoteData{
    NSDictionary *logDic = @{@"ExId":@0,
                             @"ExMeid":GetUserId,
                             @"ExName":self.exModel.ExName,
                             @"ExCw":self.exModel.ExCw,
                             @"ExDoctortime":self.exModel.ExDoctortime,
                             @"ExCreatetime":@"",
                             @"ExDisease":self.exModel.ExDisease,
                             @"ExMemo":self.exModel.ExMemo
                             };
    WK(weakSelf)
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:@"addzjtj" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            [weakSelf getListData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 点击方法
-(void)agreeProtocol:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected == NO) {
        self.addBtn.selected = NO;
        self.infoTB.tableFooterView.hidden = !sender.selected;
    }
}

-(void)addNote:(UIButton *)sender{
    if (self.protocolBtn.selected == NO) {
        [SXLoadingView showAlertHUD:@"同意保密协议才能添加" duration:0.5];
    }else{
        sender.selected = !sender.selected;
        self.infoTB.tableFooterView.hidden = !sender.selected;
        if (sender.selected == NO) {
            if (IsNilString(self.exModel.ExName)||IsNilString(self.exModel.ExDisease)) {
                [SXLoadingView showAlertHUD:@"请至少填写姓名和疾病" duration:0.5];
            }else{
                [self postNoteData];
            }
        }
    }
    MYLog(@"添加记录");
}

-(void)changeTime:(UIDatePicker *)datePicker{
    NSDate *pickerDate = [datePicker date];
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc]init];
    [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
    UIButton *btn = [self.view viewWithTag:111+2];
    [btn setTitle:[pickerFormatter stringFromDate:pickerDate] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.exModel.ExDoctortime = [NSString stringWithFormat:@"%ld-%ld-%ldT00:00:00",[pickerDate year],[pickerDate month],[pickerDate day]];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.exArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExpertRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"expertRecommendCell"];
    if (!cell) {
        cell = [[ExpertRecommendTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"expertRecommendCell"];
    }
    cell.exModel = self.exArr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.relationArr.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.relationArr[row];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 35;
}

#pragma mark - ExpertRecommendAddViewDelegate
-(void)expertRecommendAddView:(ExpertRecommendAddView *)exView clickBtn:(UIButton *)sender{
    switch (sender.tag - 111) {
        case 0:{
            ExpertRecommendEditViewController *expertEditVC = [[ExpertRecommendEditViewController alloc]initWithTitle:@"姓名" image:nil];
            expertEditVC.delegate = self;
            [self.navigationController pushViewController:expertEditVC animated:YES];
        }
            break;
        case 3:
        {
            ExpertRecommendEditViewController *expertEditVC = [[ExpertRecommendEditViewController alloc]initWithTitle:@"疾病或事件" image:nil];
            expertEditVC.delegate = self;
            [self.navigationController pushViewController:expertEditVC animated:YES];
        }
            break;
        case 4:
        {
            ExpertRecommendEditViewController *expertEditVC = [[ExpertRecommendEditViewController alloc]initWithTitle:@"说明" image:nil];
            expertEditVC.delegate = self;
            [self.navigationController pushViewController:expertEditVC animated:YES];
        }
            break;
        case 1:
            [self.view addSubview:self.relationPickV];
            self.tabBarController.tabBar.hidden = YES;
            break;
        case 2:
            [self.view addSubview:self.datePick];
            self.tabBarController.tabBar.hidden = YES;
            break;
            
        default:
            break;
    }
}

#pragma mark - ExpertRecommendEditViewControllerDelegate
-(void)sureToEdit:(NSString *)str withTitle:(NSString *)title{
    if ([title isEqualToString:@"姓名"]) {
        UIButton *btn = [self.view viewWithTag:111+0];
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.exModel.ExName = str;
    }
    if ([title isEqualToString:@"疾病或事件"]) {
        UIButton *btn = [self.view viewWithTag:111+3];
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.exModel.ExDisease = str;
    }
    if ([title isEqualToString:@"说明"]) {
        UIButton *btn = [self.view viewWithTag:111+4];
        [btn setTitle:@"点击修改" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.exModel.ExMemo = str;
    }
}

#pragma mark - lazyLoad
-(UIScrollView *)backSV{
    if (!_backSV) {
        _backSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-49)];
        _backSV.backgroundColor = LH_RGBCOLOR(235, 236, 237);
        _backSV.contentSize = CGSizeMake(Screen_width, 513);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            self.tabBarController.tabBar.hidden = NO;
            UIButton *button = [self.view viewWithTag:111+1];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitle:self.relationArr[[self.relationPickV selectedRowInComponent:0]] forState:UIControlStateNormal];
            self.exModel.ExCw = button.currentTitle;
            [self.relationPickV removeFromSuperview];
            [self.datePick removeFromSuperview];
                     }];
        [_backSV addGestureRecognizer:tap];
    }
    return _backSV;
}

-(UIView *)firstBackV{
    if (!_firstBackV) {
        _firstBackV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 255)];
        _firstBackV.backgroundColor = [UIColor whiteColor];
    }
    return _firstBackV;
}

-(UITextView *)infoTV{
    if (!_infoTV) {
        _infoTV = [[UITextView alloc]initWithFrame:CGRectMake(15, 15, Screen_width-30, 175)];
        _infoTV.attributedText = [NSString getLineSpaceStr:@"您对祖辈的病史了解的越多，医生就越容易诊断出您可能出现的健康问题。此外，保存好免疫接种记录对于转学、出国旅游以及某些工作来说也非常重要。\n请使用下面的表格记录重大疾病、疫苗接种、手术以及家人逝世等信息。\n本公司会对用户所填写的信息严格保密，用户填写相应信息前，请阅读相关协议。"];
        _infoTV.editable = NO;
    }
    return _infoTV;
}

-(UIButton *)protocolBtn{
    if (!_protocolBtn) {
        _protocolBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectYH(self.infoTV), 250, 50)];
        [_protocolBtn setImage:MImage(@"zjtj_yxwxz") forState:UIControlStateNormal];
        [_protocolBtn setImage:MImage(@"zjtj_yxyxz") forState:UIControlStateSelected];
        [_protocolBtn setTitle:@"阅读并同意《同城家谱专家推荐保密协议》" forState:UIControlStateNormal];
        [_protocolBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _protocolBtn.titleLabel.font = MFont(11);
        [_protocolBtn addTarget:self action:@selector(agreeProtocol:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _protocolBtn;
}

-(UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [[UIButton alloc]initWithFrame:CGRectMake(Screen_width-65, CGRectY(self.protocolBtn)+15, 50, 20)];
        _addBtn.layer.borderWidth = 1;
        _addBtn.layer.borderColor = [UIColor redColor].CGColor;
        _addBtn.layer.cornerRadius = 3.0f;
        [_addBtn setTitle:@"新添记录" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_addBtn setTitle:@"确定添加" forState:UIControlStateSelected];
        _addBtn.titleLabel.font = MFont(12);
        [_addBtn addTarget:self action:@selector(addNote:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

-(UIView *)secondBackV{
    if (!_secondBackV) {
        _secondBackV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectYH(self.firstBackV)+10, Screen_width, 250)];
        _secondBackV.backgroundColor = [UIColor whiteColor];
        
    }
    return _secondBackV;
}

-(UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(15, 10, Screen_width-30, 35)];
        _titleView.layer.borderColor = LH_RGBCOLOR(215, 216, 217).CGColor;
        _titleView.layer.borderWidth = 0.5;
        NSArray *arr = @[@"姓名",@"称谓",@"日期",@"疾病或事件",@"说明"];
        for (int i = 0; i < 5; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((Screen_width-30)/5*i, 0, (Screen_width-30)/5, 35)];
            label.text = arr[i];
            label.font = MFont(11);
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.borderColor = LH_RGBCOLOR(215, 216, 217).CGColor;
            label.layer.borderWidth = 0.5;
            [_titleView addSubview:label];
        }
    }
    return _titleView;
}

-(UITableView *)infoTB{
    if (!_infoTB) {
        _infoTB = [[UITableView alloc]initWithFrame:CGRectMake(15, 45, Screen_width-30, 215-30)];
        _infoTB.dataSource = self;
        _infoTB.delegate = self;
        _infoTB.bounces = NO;
        _infoTB.tableFooterView = [[UIView alloc]init];
        _infoTB.separatorStyle = UITableViewCellSeparatorStyleNone;
        ExpertRecommendAddView *exView = [[ExpertRecommendAddView alloc]initWithFrame:CGRectMake(0, 0, 320, 35)];
        exView.delegate = self;
        _infoTB.tableFooterView = exView;
    }
    return _infoTB;
}

-(ExpertRecommendModel *)exModel{
    if (!_exModel) {
        _exModel = [[ExpertRecommendModel alloc]init];
    }
    return _exModel;
}

-(UIPickerView *)relationPickV{
    if (!_relationPickV) {
        _relationPickV = [[UIPickerView alloc]initWithFrame:CGRectMake(0, Screen_height-200, Screen_width, 200)];
        _relationPickV.dataSource = self;
        _relationPickV.delegate = self;
        _relationPickV.backgroundColor = [UIColor whiteColor];
    }
    return _relationPickV;
}

-(NSArray *)relationArr{
    if (!_relationArr) {
        _relationArr = @[@"祖父",@"祖母",@"父亲",@"母亲",@"伯母",@"兄弟",@"姐妹",@"堂兄弟",@"堂姐妹",@"表兄弟",@"表姐妹",@"丈夫",@"妻子",@"儿子",@"女儿",@"侄子",@"侄女",@"孙子",@"孙女",@"侄孙子",@"侄孙女",@"公公",@"婆婆"];
    }
    return _relationArr;
}

-(UIDatePicker *)datePick{
    if (!_datePick) {
        _datePick = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, Screen_height - 200, Screen_width, 200)];
        _datePick.backgroundColor = [UIColor whiteColor];
        _datePick.datePickerMode = UIDatePickerModeDate;
        [_datePick addTarget:self action:@selector(changeTime:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePick;
}
@end
