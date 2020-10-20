//
//  YHomeViewController.m
//  FamilyTree
//
//  Created by 姚珉 on 16/8/9.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "YHomeViewController.h"
#import "BannerView.h"
#import "FortuneTodayViewController.h"
#import "NewsCenterViewController.h"
#import "DivinationViewController.h"
#import "CliffordViewController.h"
#import "BannerModel.h"
#import "QiJieModel.h"

@interface YHomeViewController ()
/** 顶部状态条*/
@property (nonatomic, strong) UIImageView *topStatusIV;
/** banner图*/
@property (nonatomic, strong) BannerView *bannerView;
/** 背景滚动图*/
@property (nonatomic, strong) UIScrollView *backSV;
/** 背景视图*/
@property (nonatomic, strong) UIImageView *backIV;
/** 节气*/
@property (nonatomic, strong) UILabel *jieqiLB;
/** 农历*/
@property (nonatomic, strong) UILabel *chineseCalendarLB;
/** 月份*/
@property (nonatomic, strong) UILabel *monthLB;
/** 日期*/
@property (nonatomic, strong) UILabel *dayLB;
/** 星期*/
@property (nonatomic, strong) UILabel *weekLB;
/** 云朵*/
@property (nonatomic, strong) UIImageView *cloudIV;
@end

@implementation YHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNotifacation];
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initUI];
    [self getBanner];
    [self getJieqi];
}

#pragma mark - 视图初始化
-(void)initUI{
    [self.view addSubview:self.topStatusIV];
    [self.view addSubview:self.bannerView];
    [self.view addSubview:self.backSV];
    [self.backSV addSubview:self.backIV];
    [self.backIV addSubview:self.jieqiLB];
    [self.backIV addSubview:self.chineseCalendarLB];
    [self.backIV addSubview:self.monthLB];
    [self.backIV addSubview:self.dayLB];
    [self.backIV addSubview:self.weekLB];
    [self.backIV addSubview:self.cloudIV];
    NSArray *BtnImageArr = @[@"sy_jp",@"sy_fw",@"sy_ys",@"sy_xw",@"sy_qf",@"sy_qq"];
    self.backSV.contentSize = CGSizeMake(Screen_width, CGRectYH(self.cloudIV)+13+7*(0.21*(Screen_width-20)+9)-20);
    self.backIV.frame = CGRectMake(0, 0, Screen_width, self.backSV.contentSize.height);
    for (int i = 0; i < 6; i++ ) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectYH(self.cloudIV)+13+(0.21*(Screen_width-20)+9)*i, Screen_width-20, 0.21*(Screen_width-20))];
        view.layer.shadowColor = [UIColor grayColor].CGColor;
        view.layer.shadowOffset = CGSizeMake(1, 1);
        view.layer.shadowOpacity = 0.5;
        view.layer.shadowRadius = 1.0;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(-1, -1, CGRectW(view)+3, CGRectH(view)+1)];
        [btn setBackgroundImage:MImage(BtnImageArr[i]) forState:UIControlStateNormal];
        btn.tag = 111+i;
        [btn addTarget:self action:@selector(clickBtnToMove:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        [self.backIV addSubview:view];
    }
    
}


#pragma mark - getData
-(void)getBanner{
    NSDictionary *logDic = @{@"type":@"SY"};
    WK(weakSelf)
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:@"getbanner" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"%@",jsonDic);
        if (succe) {
            NSArray *array = [NSArray modelArrayWithClass:[BannerModel class] json:jsonDic[@"data"]];
            weakSelf.bannerView.modelArr = array;
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)getJieqi{
    NSDictionary *logDic = @{@"userid":@"15"};
    WK(weakSelf)
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:@"getapiindeximg" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"%@",jsonDic);
        if (succe) {
            QiJieModel *model = [QiJieModel modelWithJSON:jsonDic[@"data"]];
            weakSelf.chineseCalendarLB.text = model.rq;
            weakSelf.jieqiLB.text = model.qj;
            if (IsNilString(model.qj)) {
                weakSelf.jieqiLB.backgroundColor = [UIColor clearColor];
                weakSelf.chineseCalendarLB.frame = CGRectMake(CGRectX(self.jieqiLB), CGRectYH(self.jieqiLB)-5, Screen_width/2-30, 15);
            }

        }
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark - 点击方法
-(void)clickBtnToMove:(UIButton *)sender{
    switch (sender.tag-111) {
        case 0:
            self.tabBarController.selectedIndex = 1;
            break;
        case 1:
            self.tabBarController.selectedIndex = 2;
            break;
        case 2:
        {
            FortuneTodayViewController *fort = [[FortuneTodayViewController alloc] initWithTitle:@"今日运势" image:nil];
            [self.navigationController pushViewController:fort animated:YES];
        }
            break;
        case 3:
        {
            NewsCenterViewController *newCenter = [[NewsCenterViewController alloc] initWithTitle:@"新闻中心" image:MImage(@"chec")];
            [self.navigationController pushViewController:newCenter animated:YES];
        }
            break;
        case 4:
        {
            CliffordViewController *cliVC = [[CliffordViewController alloc]initWithTitle:@"祈福" image:nil];
            [self.navigationController pushViewController:cliVC animated:YES];
        }
            break;
        case 5:
        {
            DivinationViewController *divVc = [[DivinationViewController alloc] initWithTitle:@"灵签" image:nil];
            [self.navigationController pushViewController:divVc animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)registerNotifacation{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondsToNotifacationFamService:) name:KNotificationCodeIntoFamSevice object:nil];
}

-(void)respondsToNotifacationFamService:(NSNotification *)info{
    NSDictionary *dic = info.userInfo;
    NSString *title = dic[@"title"];
    
    if ([title isEqualToString:@"商城"]) {
        ShoppingFirestViewController *shop = [[ShoppingFirestViewController alloc] init];
        [self.navigationController pushViewController:shop animated:YES];
        self.tabBarController.selectedIndex = 0;
    }else if ([title isEqualToString:@"新闻中心"]){
        NewsCenterViewController *newCenter = [[NewsCenterViewController alloc] initWithTitle:@"新闻中心" image:MImage(@"chec")];
        [self.navigationController pushViewController:newCenter animated:true];
        self.tabBarController.selectedIndex = 0;
    }
    
}



#pragma mark - lazyLoad
-(UIImageView *)topStatusIV{
    if (!_topStatusIV) {
        _topStatusIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 22)];
        _topStatusIV.image = MImage(@"sy_statusbg");
    }
    return _topStatusIV;
}

-(BannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[BannerView alloc]initWithFrame:CGRectMake(0, 22, Screen_width, Screen_width*0.6)];
        //172
        //Screen_width*0.6
    }
    return _bannerView;
}

-(UIScrollView *)backSV{
    if (!_backSV) {
        _backSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectYH(self.bannerView), Screen_width, Screen_height-CGRectYH(self.bannerView))];
        _backSV.showsVerticalScrollIndicator = NO;
        _backSV.showsHorizontalScrollIndicator = NO;
        _backSV.bounces = NO;
        _backSV.contentSize = CGSizeMake(Screen_width, 550);
    }
    return _backSV;
}

-(UIImageView *)backIV{
    if (!_backIV) {
        _backIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, self.backSV.contentSize.height)];
        UIImage *image = MImage(@"sy_bg");
        UIImage *reImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(100, 0, 550, 0) resizingMode:UIImageResizingModeStretch];
        _backIV.image = reImage;
        _backIV.userInteractionEnabled = YES;
    }
    return _backIV;
}

-(UILabel *)jieqiLB{
    if (!_jieqiLB) {
        _jieqiLB = [[UILabel alloc]initWithFrame:CGRectMake(30, 6, 30, 20)];
        _jieqiLB.text = @"惊蛰";
        _jieqiLB.backgroundColor = [UIColor colorWithHexString:@"ad1e23"];
        _jieqiLB.textColor = [UIColor whiteColor];
        _jieqiLB.font = MFont(13);
        _jieqiLB.textAlignment = NSTextAlignmentCenter;
        _jieqiLB.layer.cornerRadius = 3.0f;
        _jieqiLB.layer.masksToBounds = YES;
//        [_jieqiLB sizeToFit];
    }
    return _jieqiLB;
}

-(UILabel *)chineseCalendarLB{
    if (!_chineseCalendarLB) {
        _chineseCalendarLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectX(self.jieqiLB), CGRectYH(self.jieqiLB)+5, Screen_width/2-30, 15)];
        _chineseCalendarLB.text = @"辛丑年农历二月廿二";
        _chineseCalendarLB.textColor = LH_RGBCOLOR(93, 93, 93);
        _chineseCalendarLB.font = MFont(13);
        
    }
    return _chineseCalendarLB;
}

-(UILabel *)monthLB{
    if (!_monthLB) {
        _monthLB = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width-90, 13, 25, 15)];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *dateComs = [[NSDateComponents alloc] init];
        dateComs = [calendar components:NSCalendarUnitMonth fromDate:[NSDate date]];
        _monthLB.text = [NSString stringWithFormat:@"%ld月",[dateComs month]];
        _monthLB.font = MFont(13);
        _monthLB.textColor = LH_RGBCOLOR(93, 93, 93);
    }
    return _monthLB;
}

-(UILabel *)dayLB{
    if (!_dayLB) {
        _dayLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(self.monthLB), CGRectY(self.monthLB)-8, 50, 45)];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *dateComs = [[NSDateComponents alloc] init];
        dateComs = [calendar components:NSCalendarUnitDay fromDate:[NSDate date]];
        //_dayLB.backgroundColor = [UIColor random];
        _dayLB.text = [NSString stringWithFormat:@"%ld",[dateComs day]];
        _dayLB.font = [UIFont fontWithName:@"HelveticaNeue" size:33];
        _dayLB.textAlignment = NSTextAlignmentLeft;
        //_dayLB.textColor = LH_RGBCOLOR(93, 93, 93);
        _dayLB.textColor = [UIColor grayColor];
    }
    return _dayLB;
}

-(UILabel *)weekLB{
    if (!_weekLB) {
        _weekLB = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width-105, CGRectYH(self.monthLB), 45, 20)];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *dateComs = [[NSDateComponents alloc] init];
        dateComs = [calendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
        _weekLB.text = [NSString stringWithFormat:@"星期%@",[self changeWithComsdateWeek:[dateComs weekday]]];
        _weekLB.font = MFont(13);
        _weekLB.textColor = LH_RGBCOLOR(93, 93, 93);
    }
    return _weekLB;
}

-(UIImageView *)cloudIV{
    if (!_cloudIV) {
        _cloudIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectYH(self.chineseCalendarLB)-5, Screen_width-20, 15)];
        _cloudIV.image = MImage(@"sy_yc");
        _cloudIV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _cloudIV;
}


#pragma mark - 辅助方法
//星期转换
-(NSString *)changeWithComsdateWeek:(NSInteger)week{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle = NSNumberFormatterRoundHalfDown;
    
    NSString *finStr = [formatter stringFromNumber:[NSNumber numberWithInteger:week-1]];
    
    if ([finStr isEqualToString:@"七"]) {
        finStr = @"日";
    }
    
    return finStr;
    
}


@end
