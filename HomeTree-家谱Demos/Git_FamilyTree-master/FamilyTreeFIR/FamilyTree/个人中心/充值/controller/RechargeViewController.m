//
//  RechargeViewController.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/3.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "RechargeViewController.h"
#import "CommonNavigationViews.h"

@interface RechargeViewController()<UITextFieldDelegate>
/** 背景图*/
@property (nonatomic, strong) UIImageView *bgImageView;
/** 白色背景*/
@property (nonatomic, strong) UIView *bgView;
/** 选中钱数组*/
@property (nonatomic, strong) NSArray *moneyArr;
/** 选中钱的按钮数组*/
@property (nonatomic, strong) NSMutableArray<UIButton *> *moneyBtnArr;
/** 额外金钱文本*/
@property (nonatomic, strong) UITextField *textField;
/** 圆形选择按钮*/
@property (nonatomic, strong) UIButton *circleBtn;
/** 支付方式数组*/
@property (nonatomic, strong) NSArray  *payArr;
@end



@implementation RechargeViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    CommonNavigationViews *navi = [[CommonNavigationViews alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 64) title:@"充值" image:MImage(@"chec")];
    [self.view addSubview:navi];
    self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-49)];
    self.bgImageView.image = MImage(@"bg");
    [self.view addSubview:self.bgImageView];
    //设置白色背景
    [self.view addSubview:self.bgView];
    _moneyArr = @[@"10",@"50",@"100",@"200",@"500",@"1000"];
    [self initChooseMoney];
    
    //支付
    [self initPay];
}

#pragma mark - lazyLoad
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectY(self.bgImageView)+10, Screen_width-20, CGRectH(self.bgImageView)-60)];
        _bgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
        
    }
    return _bgView;
}


-(void)initChooseMoney{
    //金额选择
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectX(self.bgView)+20, CGRectY(self.bgView)+10, 70, 20)];
    label1.text = @"金额选择";
    label1.textAlignment = NSTextAlignmentLeft;
    label1.font = MFont(16);
    [self.view addSubview:label1];

    for (int i = 0; i < 6; i++) {
        CGFloat btnWidth = (Screen_width-20-50-30*2)/3;
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(CGRectX(self.bgView)+25+(btnWidth+30)*(i/3?(i-3):i),CGRectY(self.bgView)+30+20+(i/3?55:0), btnWidth, 40)];
        NSString *buttonStr = [NSString stringWithFormat:@"%@元",self.moneyArr[i]];
        button.backgroundColor = LH_RGBCOLOR(219, 220, 220);
        button.layer.cornerRadius = 2.0;
        [button setTitle:buttonStr forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickChooseMoneyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.tag = 1+i;
        [self.moneyBtnArr addObject:button];
        [self.view addSubview:button];
        
    }
    
    //其他金额圆按钮
    self.circleBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectX(label1), CGRectYH(label1)+2*40+20+15+20+15, 15, 15)];
    self.circleBtn.layer.cornerRadius = 7.5;
    self.circleBtn.backgroundColor = [UIColor whiteColor];
    [self.circleBtn addTarget:self action:@selector(clickOtherMoneyBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.circleBtn];
    
    //其他金额文本
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(self.circleBtn)+5, CGRectY(self.circleBtn)-8, 60, 30)];
    label2.text = @"其他金额";
    label2.font = MFont(14);
    [self.view addSubview:label2];
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectXW(label2), CGRectY(label2)-5, 60, 30)];
    self.textField.keyboardType = UIKeyboardTypePhonePad;
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
    //画单边边框
    CALayer *bottomBorder = [CALayer layer];
    float height=self.textField.frame.size.height-1.0f;
    float width=self.textField.frame.size.width;
    bottomBorder.frame = CGRectMake(0.0f, height, width, 1.0f);
    bottomBorder.backgroundColor = [UIColor blackColor].CGColor;
    [self.textField.layer addSublayer:bottomBorder];
    //元
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(self.textField), CGRectY(label2), 20, 30)];
    label3.text = @"元";
    label3.font = MFont(14);
    [self.view addSubview:label3];
}

-(void)initPay{
    //请选择以下方式支付
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectX(self.circleBtn), CGRectY(self.bgView)+CGRectH(self.bgView)/2, 200, 40)];
    label.text = @"请选择以下方式支付:";
    label.font = MFont(14);
    [self.view addSubview:label];
    self.payArr = @[@"支付宝",@"微信支付",@"银联支付"];
    for (int i = 0; i < 3; i++) {
        CGFloat buttonHeight = (CGRectH(self.bgView)/2-40-10-15*2-20)/3;
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(CGRectX(label), CGRectYH(label)+10+(buttonHeight+15)*i, CGRectW(self.bgView)-20*2, buttonHeight)];
        [button setTitle:self.payArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.backgroundColor = LH_RGBCOLOR(219, 220, 220);
        button.tag = 101+i;
        [button addTarget:self action:@selector(clickToPay:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
}

-(void)clickChooseMoneyBtn:(UIButton *)sender{
    MYLog(@"选中%@元", self.moneyArr[sender.tag-1]);
    //让选中的金额变色，其他返回未选中状态
    for (int i = 0 ; i < 6; i++) {
        UIButton *button =(UIButton *)[self.view viewWithTag:1+i];
        button.selected = NO;
        sender.selected = YES;
        button.backgroundColor = button.selected?LH_RGBCOLOR(75, 88, 91):LH_RGBCOLOR(219, 220, 220);
    }
}

-(void)clickOtherMoneyBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
    MYLog(@"选择其他金额");
    sender.backgroundColor = sender.selected?[UIColor blackColor]:[UIColor whiteColor];
    for (int i = 0; i < self.moneyBtnArr.count; i++) {
        self.moneyBtnArr[i].userInteractionEnabled = !sender.selected;
        if (self.moneyBtnArr[i].selected == YES) {
            self.moneyBtnArr[i].selected = NO;
            self.moneyBtnArr[i].backgroundColor = LH_RGBCOLOR(219, 220, 220);
        }
    }
}

-(void)clickToPay:(UIButton *)sender{
    switch (sender.tag) {
        case 101:
            MYLog(@"支付宝支付");
            break;
        case 102:
            MYLog(@"微信支付");
            break;
        default:
            MYLog(@"银联支付");
            break;
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.circleBtn.selected = YES;
    self.circleBtn.backgroundColor = self.circleBtn.selected?[UIColor blackColor]:[UIColor whiteColor];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    self.circleBtn.selected = NO;
    self.circleBtn.backgroundColor = self.circleBtn.selected?[UIColor blackColor]:[UIColor whiteColor];

    return NO;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    return [self validateNumber:string];
    return [NSString validateNumber:string];
}

////判断只能输入数字
//- (BOOL)validateNumber:(NSString*)number {
//    BOOL res = YES;
//    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
//    int i = 0;
//    while (i < number.length) {
//        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
//        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
//        if (range.length == 0) {
//            res = NO;
//            break;
//        }
//        i++;
//    }
//    return res;
//}

#pragma mark - lazyLoad
-(NSMutableArray<UIButton *> *)moneyBtnArr{
    if (!_moneyBtnArr) {
        _moneyBtnArr = [@[] mutableCopy];
    }
    return _moneyBtnArr;
}
@end
