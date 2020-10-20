//
//  EditPersonalInfoView.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/15.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "EditPersonalInfoView.h"
#import "EditPersonalInfoTableViewCell.h"
#import "EditPersonalInfoDetailViewController.h"
#import "EditPasswordViewController.h"
#import "CustomPikcerDateView.h"
#import "DateModel.h"
#import "AreaModel.h"

@interface EditPersonalInfoView()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,EditPersonalInfoTableViewCellDelegate,UIPickerViewDelegate,UIPickerViewDataSource,CustomPikcerDateViewDelegate,EditPersonalInfoDetailViewControllerDelegate>
/** 滚动背景图*/
@property (nonatomic, strong) UIImageView *BgIV;
/** 左侧一根线*/
@property (nonatomic, strong) UIView *leftLineView;
/** 左侧第一个圆*/
@property (nonatomic, strong) UIImageView *leftFirstCircle;
/** 左侧第二个圆*/
@property (nonatomic, strong) UIImageView *leftSecondCircle;


/** 账户信息表*/
@property (nonatomic, strong) UITableView *accountInfoTB;
/** 个人信息表*/
@property (nonatomic, strong) UITableView *personalInfoTB;

/** 账户信息标题数组*/
@property (nonatomic, copy) NSArray *accountInfoTitleArr;
/** 个人信息标题数组*/
@property (nonatomic, copy) NSArray *personalInfoTitleArr;
/** 爱好选择标题数组*/
@property (nonatomic, copy) NSArray *interestTitleArr;
/** 国籍*/
@property (nonatomic, copy) NSArray *countryArr;
/** 地区*/
@property (nonatomic, copy) NSArray *areaArr;
/** 省名数组*/
@property (nonatomic, strong) NSMutableArray *proArr;
/** 城市名数组*/
@property (nonatomic, strong) NSArray *cityArr;
/** 性别*/
@property (nonatomic, copy) NSArray *sexArr;
/** 证件类型*/
@property (nonatomic, copy) NSArray *documentCategoryArr;
/** 职业*/
@property (nonatomic, copy) NSArray *jobArr;
/** 学历*/
@property (nonatomic, copy) NSArray *studyArr;
/** 选择器标题*/
@property (nonatomic, copy) NSArray *pickerViewTitleArr;
/** pickerView出来的灰色背景*/
@property (nonatomic, strong) UIView *pickerViewGrayBgView;
/** pickerView确定那妞*/
@property (nonatomic, strong) UIButton *sureBtn;
@end

@implementation EditPersonalInfoView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.contentSize = CGSizeMake(Screen_width, 826);
        self.bounces = NO;
        [self addSubview:self.BgIV];
        //左侧竖线
        self.leftLineView = [[UIView alloc]initWithFrame:CGRectMake(0.0680*CGRectW(self.BgIV), 30, 1, 780)];
        self.leftLineView.backgroundColor = LH_RGBCOLOR(129, 127, 135);
        [self.BgIV addSubview:self.leftLineView];
        //左侧两个圆
        [self.BgIV addSubview:self.leftFirstCircle];
        [self.BgIV addSubview:self.leftSecondCircle];
        //账户信息 个人信息
        [self initAccountInfoLBAndPersonalInfoLB];
        //账户信息表
        [self initAccountInfoTB];
        //个人信息表
        [self initPersonalInfoTB];
    }
    return self;
}

#pragma mark - lazyLoad
-(UIImageView *)BgIV{
    if (!_BgIV) {
        _BgIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0.91875*Screen_width, self.contentSize.height)];
        _BgIV.image = MImage(@"geran_background_s");
        _BgIV.userInteractionEnabled = YES;
    }
    return _BgIV;
}

-(UIImageView *)leftFirstCircle{
    if (!_leftFirstCircle) {
        _leftFirstCircle = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectX(self.leftLineView)-10, 14.6, 20, 20)];
        _leftFirstCircle.image = MImage(@"geran_red");
    }
    return _leftFirstCircle;
}

-(UIImageView *)leftSecondCircle{
    if (!_leftSecondCircle) {
        _leftSecondCircle = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectX(self.leftLineView)-10, 224, 20, 20)];
        _leftSecondCircle.image = MImage(@"geran_ccc");
    }
    return _leftSecondCircle;
}

-(NSArray *)accountInfoTitleArr{
    if (!_accountInfoTitleArr) {
        _accountInfoTitleArr = @[@"ID",@"账号",@"密码",@"手机",@"邮箱"];
    }
    return _accountInfoTitleArr;
}

-(NSArray *)personalInfoTitleArr{
    if (!_personalInfoTitleArr) {
        _personalInfoTitleArr = @[@"姓名",@"昵称",@"国籍",@"地区",@"性别",@"生日",@"证件",@"证件末6位",@"职业",@"学历",@"爱好",@"个人签名",@"经历"];
    }
    return _personalInfoTitleArr;
}


-(NSArray *)interestTitleArr{
    if (!_interestTitleArr) {
        _interestTitleArr = @[@"运动",@"音乐",@"跳舞",@"游戏",@"电影",@"动漫",@"美术",@"文学",@"美食",@"逛街",@"旅游",@"摄影"];
    }
    return _interestTitleArr;
}

//-(NSArray *)countryArr{
//    if (!_countryArr) {
//        _countryArr = @[@"中国",@"美国",@"英国"];
//    }
//    return _countryArr;
//}

-(NSArray *)areaArr{
    if (!_areaArr) {
        //_areaArr = @[@"安徽-怀宁",@"安徽-合肥",@"安徽-马鞍山"];
        NSString *filePath = [UserDocumentD stringByAppendingPathComponent:@"area.plist"];
        _areaArr = [NSArray arrayWithContentsOfFile:filePath];
    }
    return _areaArr;
}

-(NSArray *)sexArr{
    if (!_sexArr) {
        _sexArr = @[@"女",@"男",@"保密"];
    }
    return _sexArr;
}

-(NSArray *)documentCategoryArr{
    if (!_documentCategoryArr) {
        _documentCategoryArr = @[@"身份证",@"机动车驾驶证",@"营业执照",@"军官证",@"武警警官证"];
    }
    return _documentCategoryArr;
}

-(NSArray *)jobArr{
    if (!_jobArr) {
    NSString *filePath = [UserDocumentD stringByAppendingPathComponent:@"job.plist"];
    
        _jobArr = [NSArray arrayWithContentsOfFile:filePath];
    }
    return _jobArr;
}


-(NSArray *)studyArr{
    if (!_studyArr) {
        _studyArr = @[@"小学",@"初中",@"中专",@"高中",@"大专",@"本科",@"硕士",@"博士"];
    }
    return _studyArr;
}

-(NSArray *)pickerViewTitleArr{
    if (!_pickerViewTitleArr) {
        _pickerViewTitleArr = @[@"",@"",@"国籍",@"地区",@"性别",@"生日",@"证件类型",@"",@"职业",@"学历"];
    }
    return _pickerViewTitleArr;
}

#pragma mark - 视图初始化
-(void)initAccountInfoLBAndPersonalInfoLB{
    UILabel *accountInfoLB = [[UILabel alloc]initWithFrame:CGRectMake(0.1565*CGRectW(self.BgIV), 15, 0.2789*CGRectW(self.BgIV), 25)];
    accountInfoLB.text = @"账户信息";
    [self.BgIV addSubview:accountInfoLB];
    UILabel *PersonalInfoLB = [[UILabel alloc]initWithFrame:CGRectMake(0.1565*CGRectW(self.BgIV), 220, 0.2789*CGRectW(self.BgIV), 25)];
    PersonalInfoLB.text = @"个人信息";
    [self.BgIV addSubview:PersonalInfoLB];
}

-(void)initAccountInfoTB{
    self.accountInfoTB = [[UITableView alloc]initWithFrame:CGRectMake(0.1327*CGRectW(self.BgIV), 56, 0.8197*CGRectW(self.BgIV), 130)];
    self.accountInfoTB.bounces = NO;
    self.accountInfoTB.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
    self.accountInfoTB.layer.borderColor = LH_RGBCOLOR(226, 226, 226).CGColor;
    self.accountInfoTB.layer.borderWidth = 1;
    self.accountInfoTB.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.accountInfoTB.dataSource = self;
    self.accountInfoTB.delegate = self;
    self.accountInfoTB.tag = 1001;
    [self.BgIV addSubview:self.accountInfoTB];
}

-(void)initPersonalInfoTB{
    self.personalInfoTB = [[UITableView alloc]initWithFrame:CGRectMake(0.1327*CGRectW(self.BgIV), 265, 0.8197*CGRectW(self.BgIV), 545)];
    self.personalInfoTB.bounces = NO;
    self.personalInfoTB.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
    self.personalInfoTB.layer.borderColor = LH_RGBCOLOR(226, 226, 226).CGColor;
    self.personalInfoTB.layer.borderWidth = 1;
    self.personalInfoTB.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.personalInfoTB.dataSource = self;
    self.personalInfoTB.delegate = self;
    self.personalInfoTB.tag = 1002;
    [self.BgIV addSubview:self.personalInfoTB];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //让已选择的爱好按钮亮起来
        [self judgeInterestStrAndSetHighlight];
    });
    
}

#pragma mark - 数据加载
-(void)reloadEditPersonalInfoData:(QueryModel *)queryModel{
    self.accountInfoDetailArr = [NSMutableArray array];
    [self.accountInfoDetailArr addObject:[NSString stringWithFormat:@"%ld",(long)queryModel.memb.MeId]];
    [self.accountInfoDetailArr addObject:queryModel.memb.MeAccount];
    [self.accountInfoDetailArr addObject:@"******"];
    [self.accountInfoDetailArr addObject: queryModel.memb.MeMobile];
    MYLog(@"%@",queryModel.memb.MeMobile);
    [self.accountInfoDetailArr addObject:queryModel.memb.MeEmail];
    
    
    self.personalInfoDetailArr = [NSMutableArray array];
    [self.personalInfoDetailArr addObject:queryModel.memb.MeName];
    [self.personalInfoDetailArr addObject:queryModel.memb.MeNickname];
    //[self.personalInfoDetailArr addObject:queryModel.area.AreaCountry];
    [self.personalInfoDetailArr addObject:@"中国"];
    if (IsNilString(queryModel.area.AreaProvince) ) {
        [self.personalInfoDetailArr addObject:@"-"];
    }else{
       [self.personalInfoDetailArr addObject:[NSString stringWithFormat:@"%@-%@",queryModel.area.AreaProvince,queryModel.area.AreaCity]];
    }
    
    [self.personalInfoDetailArr addObject:@[@"女",@"男",@"保密"][[queryModel.memb.MeSex intValue]]];
    DateModel *dateModel = [[DateModel alloc]initWithDateStr:queryModel.memb.MeBirthday];
    NSString *MeBirthdayStr = [NSString stringWithFormat:@"%04ld年%02ld月%02ld日%02ld时",(long)dateModel.year,(long)dateModel.month,(long)dateModel.day,(long)dateModel.hour];
    [self.personalInfoDetailArr addObject:MeBirthdayStr];
    [self.personalInfoDetailArr addObject:queryModel.memb.MeCertype];
    [self.personalInfoDetailArr addObject:IsNilString(queryModel.memb.MeCardnum) ?@"":queryModel.memb.MeCardnum];
    [self.personalInfoDetailArr addObject:queryModel.kzxx.Grzy];
    [self.personalInfoDetailArr addObject:queryModel.kzxx.Grxl];
    [self.personalInfoDetailArr addObject:queryModel.kzxx.Grah];
    [self.personalInfoDetailArr addObject:queryModel.kzxx.Grqm];
    [self.personalInfoDetailArr addObject:queryModel.kzxx.Grjl];
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offSetY = scrollView.contentOffset.y;
    if (offSetY > 40) {
        self.leftFirstCircle.image = MImage(@"geran_ccc");
        self.leftSecondCircle.image = MImage(@"geran_red");
    }else{
        self.leftFirstCircle.image = MImage(@"geran_red");
        self.leftSecondCircle.image = MImage(@"geran_ccc");
    }
}


#pragma mark - UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1001) {
        return 5;
    }
        return 13;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1001) {
        EditPersonalInfoTableViewCell *accountInfoCell = [tableView dequeueReusableCellWithIdentifier:@"accoutInfoCell"];
        if (!accountInfoCell) {
            if (indexPath.row == 0||indexPath.row == 1) {
                accountInfoCell = [[EditPersonalInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"accoutInfoCell" WithCustomStyle:EditPersonalInfoTableViewCellStyleNone];
                
            }else{
                accountInfoCell = [[EditPersonalInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"accoutInfoCell" WithCustomStyle:EditPersonalInfoTableViewCellStyleEdit];
            }
        }
        accountInfoCell.customTitleLB.text = [self.accountInfoTitleArr[indexPath.row] stringByAppendingString:@":"];
        [self labelWidthToFit:accountInfoCell.customTitleLB andFrame:CGRectMake(8, 0, 100, 26)];
        accountInfoCell.customDetailLB.text = self.accountInfoDetailArr[indexPath.row];
        if (indexPath.row == 3) {
            accountInfoCell.customDetailLB.text =[self getLockMobileWithString:self.accountInfoDetailArr[indexPath.row]];
        }
        if (indexPath.row == 4) {
            accountInfoCell.customDetailLB.font = MFont(14);
        }
        accountInfoCell.delegate = self;
        accountInfoCell.editBtn.tag = 333+indexPath.row;
        return accountInfoCell;
    }
    
    EditPersonalInfoTableViewCell *personalInfoCell = [tableView dequeueReusableCellWithIdentifier:@"personalInfoCell"];
        if (!personalInfoCell) {
            switch (indexPath.row) {
                case 0:
                case 1:
                case 7:
                    personalInfoCell = [[EditPersonalInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"personalInfoCell" WithCustomStyle:EditPersonalInfoTableViewCellStyleEdit];
                    break;
                case 3:
                case 4:
                case 5:
                case 6:
                case 8:
                case 9:
                    personalInfoCell = [[EditPersonalInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"personalInfoCell" WithCustomStyle:EditPersonalInfoTableViewCellStyleArrow];
                    break;
                default:
                    personalInfoCell = [[EditPersonalInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"personalInfoCell" WithCustomStyle:EditPersonalInfoTableViewCellStyleNone];
                    break;
            }
        }
    personalInfoCell.customTitleLB.text = [self.personalInfoTitleArr[indexPath.row] stringByAppendingString:@":"];
    [self labelWidthToFit:personalInfoCell.customTitleLB andFrame:CGRectMake(8, 0, 100, 26)];
    if (indexPath.row == 10) {
        //生成12个爱好按钮
        for (int i = 0; i < 12; i++) {
            UIButton *interestBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.1826*CGRectW(self.personalInfoTB)+0.1826*CGRectW(self.personalInfoTB)*(i-4*[@[@0,@1,@2][i/4] intValue]), 6+30*[@[@0,@1,@2][i/4] intValue], 0.1618*CGRectW(self.personalInfoTB), 21.5)];
            [interestBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [interestBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [interestBtn setTitle:self.interestTitleArr[i] forState:UIControlStateNormal];
            [interestBtn setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
            [interestBtn setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateSelected];
            [interestBtn addTarget:self action:@selector(clickInterestBtn:) forControlEvents:UIControlEventTouchUpInside];
            interestBtn.tag = 555+i;
            [personalInfoCell.contentView addSubview:interestBtn];
        }
    }
    if (indexPath.row == 11|| indexPath.row == 12) {
        UITextView *textView = [[UITextView alloc]init];
        textView.backgroundColor = [UIColor clearColor];
        textView.textAlignment = NSTextAlignmentLeft;
        textView.text = self.personalInfoDetailArr[indexPath.row];
        textView.tag = 888 +indexPath.row;
        textView.delegate = self;
        [personalInfoCell.contentView addSubview:textView];
        textView.sd_layout.topSpaceToView(personalInfoCell.customTitleLB,0).leftSpaceToView(personalInfoCell.contentView,8).rightSpaceToView(personalInfoCell.contentView,8).bottomSpaceToView(personalInfoCell.contentView,8);
    }else{
        if (indexPath.row != 10) {
            personalInfoCell.customDetailLB.text = self.personalInfoDetailArr[indexPath.row];
        }
        if (indexPath.row == 7) {
            personalInfoCell.customDetailLB.text = self.personalInfoDetailArr[indexPath.row]?@"******":@"";
        }
        if (indexPath.row == 3) {
            personalInfoCell.customDetailLB.text = [self.personalInfoDetailArr[indexPath.row] isEqualToString:@"-"]?@"":self.personalInfoDetailArr[indexPath.row];
        }
    }
    personalInfoCell.delegate = self;
    personalInfoCell.editBtn.tag = 444+indexPath.row;
    return personalInfoCell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1002 && (indexPath.row == 10 || indexPath.row == 11 || indexPath.row == 12)) {
        return 95;
    }
    return 26;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self endEditing:YES];
}



#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    MYLog(@"将要开始编辑");
    
    if (self.frame.origin.y == 64) {
        [UIView animateWithDuration:1 animations:^{
            CGRect frame =  self.frame;
            frame.origin.y = 64-216;
            self.frame = frame;
        }];
    }
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    MYLog(@"结束编辑");
    if (self.frame.origin.y !=64) {
        [UIView animateWithDuration:1 animations:^{
            CGRect frame =  self.frame;
            frame.origin.y = 64;
            self.frame = frame;
        }];
    }
}

#pragma mark - EditPersonalInfoTableViewCellDelegate
-(void)respondToEditBtn:(UIButton *)sender{
    EditPersonalInfoDetailViewController *editDetaiVC = [[EditPersonalInfoDetailViewController alloc]init];
    if (sender.tag-333 == 2) {
        EditPasswordViewController *editPasswordVC = [[EditPasswordViewController alloc]init];
        editPasswordVC.detailStr = self.accountInfoTitleArr[sender.tag-333];
        //editPasswordVC.TFStr = self.accountInfoDetailArr[sender.tag-333];
        [[self viewController].navigationController pushViewController:editPasswordVC animated:NO];
    }else if(sender.tag < 444){
        MYLog(@"%ld",(long)sender.tag-333);
        editDetaiVC.detailStr = self.accountInfoTitleArr[sender.tag-333];
        editDetaiVC.TFStr = self.accountInfoDetailArr[sender.tag-333];
        editDetaiVC.delegate = self;
        [[self viewController].navigationController pushViewController:editDetaiVC animated:NO];
    }else{
        MYLog(@"%ld",(long)sender.tag-444);
        editDetaiVC.detailStr = self.personalInfoTitleArr[sender.tag-444];
        editDetaiVC.TFStr = self.personalInfoDetailArr[sender.tag-444];
        editDetaiVC.delegate = self;
        [[self viewController].navigationController pushViewController:editDetaiVC animated:NO];
        
    }
}

-(void)respondToPullDownBtn:(UIButton *)sender{
    MYLog(@"下拉%@",self.personalInfoTitleArr[sender.tag-444]);
    //灰色背景
    self.pickerViewGrayBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64)];
    self.pickerViewGrayBgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self viewController].tabBarController.tabBar.hidden = YES;
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPickerViewGrayBgViewForRemove)];
    [self.pickerViewGrayBgView addGestureRecognizer:tap];
    [[self viewController].view addSubview:self.pickerViewGrayBgView];
    //标题视图
    UIView *pickerViewTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.7507*Screen_height-64, Screen_width, 0.0455*Screen_height)];
    pickerViewTitleView.backgroundColor =[UIColor whiteColor];
    [self.pickerViewGrayBgView addSubview:pickerViewTitleView];
    CALayer *border = [CALayer layer];
    float height=pickerViewTitleView.frame.size.height;
    float width=pickerViewTitleView.frame.size.width;
    border.frame = CGRectMake(0, height-1, width, 1.0f);
    border.backgroundColor = [UIColor redColor].CGColor;
    [pickerViewTitleView.layer addSublayer:border];
    
    //标题
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, Screen_width, CGRectH(pickerViewTitleView))];
    label.textColor = [UIColor redColor];
    [pickerViewTitleView addSubview:label];
    self.sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.8*Screen_width, 0, 0.2*Screen_width, CGRectH(pickerViewTitleView))];
    //sureBtn.backgroundColor = [UIColor redColor];
    
    [self.sureBtn addTarget:self action:@selector(clickPickerViewSureBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.sureBtn.tag = 666+(sender.tag-444);
    [pickerViewTitleView addSubview:self.sureBtn];
    //pickerView and datepick
    if (sender.tag-444 != 5) {
        //pickerView
        UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0.7952*Screen_height-64, Screen_width, 0.2048*Screen_height)];
        pickerView.backgroundColor = [UIColor whiteColor];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        pickerView.tag = 222+(sender.tag-444);
        if (sender.tag - 444 == 3) {
            self.proArr = [NSMutableArray array];
            //self.cityArr = [NSMutableArray array];
            for (int i = 0; i < self.areaArr.count; i++) {
                [self.proArr addObject:self.areaArr[i][@"proname"]];
            }
        
            self.cityArr = self.areaArr[0][@"cityname"];
        }
        [self.pickerViewGrayBgView addSubview:pickerView];
        
        
        //[self clearSeparatorWithView:pickerViewTitleView];
        label.text = [NSString stringWithFormat:@"请选择%@",self.pickerViewTitleArr[pickerView.tag-222]];
//        //两条线
//        UIView *pickerViewDidSelectedTopAndBottomBorderView = [[UIView alloc]initWithFrame:CGRectMake(Screen_width/3, 0.8624*Screen_height-64, Screen_width/3, 0.0713*Screen_height)];
//        pickerViewDidSelectedTopAndBottomBorderView.userInteractionEnabled = NO;
//        [self.pickerViewGrayBgView addSubview:pickerViewDidSelectedTopAndBottomBorderView];
//        //画上下边框
//        CALayer *didSelectedTopBorder = [CALayer layer];
//        float didSelectedWidth=pickerViewDidSelectedTopAndBottomBorderView.frame.size.width;
//        float didSelectedHeight=pickerViewDidSelectedTopAndBottomBorderView.frame.size.height;
//        didSelectedTopBorder.frame = CGRectMake(0, -1, didSelectedWidth, 1.0f);
//        didSelectedTopBorder.backgroundColor = [UIColor redColor].CGColor;
//        [pickerViewDidSelectedTopAndBottomBorderView.layer addSublayer:didSelectedTopBorder];
//        CALayer *didSelectedBottomBorder = [CALayer layer];
//        didSelectedBottomBorder.frame = CGRectMake(0, didSelectedHeight, didSelectedWidth, 1.0f);
//        didSelectedBottomBorder.backgroundColor = [UIColor redColor].CGColor;
//        [pickerViewDidSelectedTopAndBottomBorderView.layer addSublayer:didSelectedBottomBorder];
        
    }else{
        CustomPikcerDateView *customPickerDateView  = [[CustomPikcerDateView alloc]initWithFrame:CGRectMake(0, 0.7952*Screen_height-64, Screen_width, 0.2048*Screen_height)];
        customPickerDateView.backgroundColor = [UIColor whiteColor];
        customPickerDateView.delegate = self;
        [self.pickerViewGrayBgView addSubview:customPickerDateView];

        //[self clearSeparatorWithView:datePicker];
        label.text = [NSString stringWithFormat:@"请选择%@",self.pickerViewTitleArr[5]];
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.3*Screen_width, 0, 0.5*Screen_width, CGRectH(pickerViewTitleView))];
        tipLabel.textColor = [UIColor grayColor];
        tipLabel.text = @"(具体时辰请采用进一法)";
        tipLabel.font = MFont(12);
        [pickerViewTitleView addSubview:tipLabel];

    }
}



#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickerView.tag -222 == 3 ) {
        return 2;
    }
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (pickerView.tag-222) {
        case 2:
            return self.countryArr.count;
            break;
        case 3:
            if (component == 0) {
                return self.proArr.count;
            }else{
                return self.cityArr.count;
            }
            break;
        case 4:
            return self.sexArr.count;
            break;
        case 6:
            return self.documentCategoryArr.count;
            break;
        case 8:
            return self.jobArr.count;
            break;
        case 9:
            return self.studyArr.count;
            break;
        default:
            return 3;
            break;
    }
    
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return CGRectH(pickerView)/3;
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (pickerView.tag-222) {
        case 2:
            return self.countryArr[row];
            break;
        case 3:
        {
            if (component == 0) {
                return self.proArr[row];
            }else{
                return self.cityArr[row];
            }
            break;
        }
        case 4:
            return self.sexArr[row];
            break;
        case 6:
            return self.documentCategoryArr[row];
            break;
        case 8:
            return self.jobArr[row];
            break;
        case 9:
            return self.studyArr[row];
            break;
        default:
            return @"啊啊";
            break;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *pickerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_width/3, Screen_height/3)];
    if (pickerView.tag-222 == 3) {
        switch (component) {
            case 0:
            {
                pickerLabel.frame = CGRectMake(0, Screen_height/3, Screen_width/2, Screen_height/6);
            }
                break;
            case 1:
            {
                pickerLabel.frame = CGRectMake(Screen_width/2, Screen_height/3, Screen_width/2, Screen_height/6);
            }
                break;
            default:
                break;
        }

    }
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.font = MFont(14);
        pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerLabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    UITableView *tableView = (UITableView *)[self viewWithTag:1002];
    switch (pickerView.tag-222) {
            case 2:
                MYLog(@"%@", self.countryArr[row]);
            self.personalInfoDetailArr[2] = self.countryArr[row];
                break;
        case 3:
            
        {
            if (component == 0) {
                self.cityArr = self.areaArr[row][@"cityname"];
                //重点！更新第二个轮子的数据
                [pickerView reloadComponent:1];
            }
            else {
            }
            self.personalInfoDetailArr[3] = [NSString stringWithFormat:@"%@-%@",self.proArr[[pickerView selectedRowInComponent:0]],self.cityArr[[pickerView selectedRowInComponent:1]]];
            }
                break;
            case 4:
                MYLog(@"%@", self.sexArr[row]);
                self.personalInfoDetailArr[4] = self.sexArr[row];
                break;
            case 6:
                MYLog(@"%@", self.documentCategoryArr[row]);
                self.personalInfoDetailArr[6] = self.documentCategoryArr[row];
                break;
            case 8:
                MYLog(@"%@", self.jobArr[row]);
                self.personalInfoDetailArr[8] = self.jobArr[row];
                break;
            case 9:
                MYLog(@"%@", self.studyArr[row]);
                self.personalInfoDetailArr[9] = self.studyArr[row];
                break;
            default:
            return;
                break;
        }
    [tableView reloadData];
}


#pragma mark - CustomPickerDateViewDelegate
-(void)getCustomPickerDateViewYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day andHour:(NSInteger)hour{
    self.personalInfoDetailArr[5] = [NSString stringWithFormat:@"%04ld年%.2ld月%.2ld日%.2ld时",(long)year,(long)month,(long)day,(long)hour];
    UITableView *tableView = (UITableView *)[self viewWithTag:1002];
    [tableView reloadData];
    
}

#pragma mark - EditPersonalInfoDetailViewControllerDelegate
-(void)EditPersonalInfoDetailViewController:(EditPersonalInfoDetailViewController *)editVC withTitle:(NSString *)title withDetail:(NSString *)detail{
    MYLog(@"%@",title);
    if ([title isEqualToString:@"手机"]) {
        self.accountInfoDetailArr[3] = detail;
        [self.accountInfoTB reloadData];

    }
    if ([title isEqualToString:@"邮箱"]) {
        self.accountInfoDetailArr[4] = detail;
        [self.accountInfoTB reloadData];
    }
    
    if ([title isEqualToString:@"姓名"]) {
        self.personalInfoDetailArr[0] = detail;
        [self.personalInfoTB reloadData];
    }
    if ([title isEqualToString:@"昵称"]) {
        self.personalInfoDetailArr[1] = detail;
        [self.personalInfoTB reloadData];
    }
    if ([title isEqualToString:@"证件末6位"]) {
        self.personalInfoDetailArr[7] = detail;
        [self.personalInfoTB reloadData];
    }
    
}




#pragma mark - 点击方法
//点击爱好
-(void)clickInterestBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
}


//关键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

//pickerView确定按钮
-(void)clickPickerViewSureBtn:(UIButton *)sender{
    MYLog(@"%ld",(long)sender.tag - 666);
    
    [self.pickerViewGrayBgView removeFromSuperview];
    [self viewController].tabBarController.tabBar.hidden = NO;
}
//关pickerView
-(void)clickPickerViewGrayBgViewForRemove{
    [self.pickerViewGrayBgView removeFromSuperview];
    [self viewController].tabBarController.tabBar.hidden = NO;
}
//判断哪些按钮是被选中状态，并拼接字符串
-(NSMutableString *)getInterestStr{
    NSMutableString *interestStr = [NSMutableString string];
    for (int i = 0; i < 12; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:555+i];
        if (button.selected) {
            [interestStr appendFormat:@"%@,",self.interestTitleArr[i]];
        }
    }
    if (!IsNilString(interestStr)) {
       [interestStr deleteCharactersInRange:NSMakeRange(interestStr.length-1, 1)];
    }
    return interestStr;
}

//判断个人爱好有哪些并设置齐高亮
-(void)judgeInterestStrAndSetHighlight{
    for (int i = 0; i < 12; i++) {
        UIButton *interestBtn = [self viewWithTag:555+i];
        if ([self.personalInfoDetailArr[10] rangeOfString:self.interestTitleArr[i]].location != NSNotFound) {
            interestBtn.selected = YES;
        }else{
            interestBtn.selected = NO;
        }
    }
}


//宽度自适应
-(void)labelWidthToFit:(UILabel *)label andFrame:(CGRect)frame{
    label.numberOfLines = 1;//根据最大行数需求来设置
    label.textAlignment = NSTextAlignmentLeft;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake(400, 26);//labelsize的最大值
    //关键语句
    CGSize expectSize = [label sizeThatFits:maximumLabelSize];
    label.frame = CGRectMake(frame.origin.x,frame.origin.y,expectSize.width, frame.size.height);
    
}

//电话号码加*处理
-(NSString *)getLockMobileWithString:(NSString *)str{
    if (!IsNilString(str)) {
        NSMutableString *mutableStr = [NSMutableString stringWithString:str];
        [mutableStr replaceCharactersInRange:NSMakeRange(4, 4) withString:@"****"];
        return [mutableStr copy];

    }
    return @"";
}

- (void)clearSeparatorWithView:(UIView * )view
{
    if(view.subviews != 0  )
    {
        if(view.bounds.size.height < 10)
        {
            view.backgroundColor = [UIColor clearColor];
        }
        
        [view.subviews enumerateObjectsUsingBlock:^( UIView *  obj, NSUInteger idx, BOOL *  stop) {
            [self clearSeparatorWithView:obj];
        }];
    }
    
}

@end
