//
//  HkK_IncomeController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HkK_IncomeController.h"
#import "HK_BaseRequest.h"
#import "Hk_walletCell.h"
#import "HK_tradeViewController.h"
#import "HK_IncomeDetailController.h"
#import "HK_MyIncomeModel.h"
#import "JHChartHeader.h"
#define k_PointColor [UIColor colorWithRed:214 / 255.0 green:238 / 255.0 blue:255 / 255.0 alpha:1.0]
@interface HkK_IncomeController ()<UITableViewDelegate,UITableViewDataSource>
//上部信息视图
@property (nonatomic, strong)UIView * topInfoView;
//切换选择时间
@property (nonatomic, strong)UIView * segmentBtnView;
//交易天数
@property (nonatomic, strong)UILabel * dayIncomLabel;
//交易收入
@property (nonatomic, strong)UILabel * incomeLabel;
@property (nonatomic, strong)UIImageView * incomV;
@property (nonatomic, strong)UITableView * listTableView;
@property (nonatomic, strong)HK_MyIncomeModel * models;
/** 7天收入模型数据*/
@property (nonatomic, strong)NSMutableArray * sevenDaysArr;
/** 一个月收入*/
@property (nonatomic, strong)NSMutableArray * monthArr;
@property (nonatomic, strong)NSMutableArray *btnArr;
@property(nonatomic,strong)JHLineChart* lineChart;
@property (nonatomic, strong)NSMutableArray *monthsTitlesArr;
@property (nonatomic, strong)NSMutableArray *daysTitlesArr;

@end

@implementation HkK_IncomeController

-(NSMutableArray *)sevenDaysArr {
    if (!_sevenDaysArr) {
        NSArray *days =@[@"5",@"7",@"12",@"5",@"7"];
        _sevenDaysArr =[[NSMutableArray alloc] initWithArray:days];
    }
    return _sevenDaysArr;
}
-(NSMutableArray *)monthArr {
    if (!_monthArr) {
        _monthArr =[[NSMutableArray alloc] init];
    }
    return _monthArr;
}
-(NSMutableArray *)btnArr {
    if (!_btnArr) {
        _btnArr =[[NSMutableArray alloc] init];
    }
    return _btnArr;
}
-(NSMutableArray*)monthsTitlesArr
{
    if (_monthsTitlesArr == nil) {
        NSArray *mo = @[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月"];
        _monthsTitlesArr =[[NSMutableArray alloc] initWithArray:mo];
    }
    return _monthsTitlesArr;
}
-(NSMutableArray*)daysTitlesArr
{
    if (_daysTitlesArr == nil) {
       
        NSArray  *da = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
        _daysTitlesArr =[[NSMutableArray alloc] initWithArray:da
                         ];
    }
    return _daysTitlesArr;
}
#pragma mark Nav 设置
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)initNav {
    self.navigationItem.title = @"收入资产";
    [self setShowCustomerLeftItem:YES];
    UIButton * rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [AppUtils getButton:rightBtn font:PingFangSCRegular15 titleColor:[UIColor colorFromHexString:@"4090f7"] title:@"明细"];
    rightBtn.frame = CGRectMake(0,0,30,20);
    [rightBtn addTarget:self action:@selector(checkList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * items =[[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = items;
    
}
//明细
-(void)checkList {
    HK_IncomeDetailController * indetail =[[HK_IncomeDetailController alloc] init];
    [self.navigationController pushViewController:indetail animated:YES];
    
}
-(UIView *)topInfoView {
    if (!_topInfoView) {
        _topInfoView =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,360)];
        _topInfoView.backgroundColor =[UIColor whiteColor];
        [_topInfoView addSubview:self.segmentBtnView];
        [_topInfoView addSubview:self.lineChart];
        [_topInfoView addSubview:self.dayIncomLabel];
        [_topInfoView addSubview:self.incomeLabel];
    }
    return _topInfoView;
}
-(JHLineChart *)lineChart {
    if (!_lineChart) {
        _lineChart=[[JHLineChart alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentBtnView.frame),kScreenWidth, 280) andLineChartType:JHChartLineValueNotForEveryX];
        _lineChart.hasPoint = NO;
        //X 坐标的下标题数组
        _lineChart.xLineDataArr = @[@"08.23",@"08.24",@"08.25",@"08.26",@"08.27"];
        //图标边界值
        _lineChart.contentInsets = UIEdgeInsetsMake(0,30,20,20);
        _lineChart.lineChartQuadrantType =  JHLineChartQuadrantTypeFirstQuardrant;
        //坐标点上显示的数值
        _lineChart.valueArr = @[@[],self.sevenDaysArr];
        //是否显示Y 轴的竖线.
        _lineChart.showYLevelLine = YES;
        _lineChart.showYLine = NO;
        _lineChart.showValueLeadingLine = NO;
        //每个坐标点的值 (X, Y)显示在顶点
        _lineChart.showLevePoint = NO;
        _lineChart.showAnimationDuration = 1.5;
        _lineChart.valueFontSize = 9.0;
        _lineChart.backgroundColor =[UIColor whiteColor];
         _lineChart.valueLineColorArr =@[ k_PointColor, k_PointColor];
        _lineChart.pointColorArr = @[[UIColor colorWithRed:49 / 255.0 green:116 / 255.0 blue:235 / 255.0 alpha:1.0],[UIColor colorWithRed:49 / 255.0 green:116 / 255.0 blue:235 / 255.0 alpha:1.0]];
        _lineChart.xAndYLineColor = [UIColor colorWithRed:144 / 255.0 green:144 / 255.0 blue:144 / 255.0 alpha:1.0];
        //坐标点XY 的文字颜色
        _lineChart.xAndYNumberColor =[UIColor colorWithRed:144 / 255.0 green:144 / 255.0 blue:144 / 255.0 alpha:1.0];
        /* 设置每个点的字体颜色 */
        _lineChart.pointNumberColorArr = @[[UIColor colorWithRed:71 / 255.0 green:184 / 255.0 blue:240 / 255.0 alpha:1.0],[UIColor colorWithRed:71 / 255.0 green:184 / 255.0 blue:240 / 255.0 alpha:1.0]];
        _lineChart.positionLineColorArr = @[[UIColor blueColor],[UIColor greenColor]];
        _lineChart.contentFill = YES;
        _lineChart.pathCurve = YES;
        //填充色颜色
        _lineChart.contentFillColorArr = @[[UIColor colorWithRed:0 green:0.5 blue:0 alpha:0.6],[UIColor colorWithRed:205 / 255.0  green:236 / 255.0 blue:240 / 255.0 alpha:0.6]];
        _lineChart.yDescTextFontSize =13;
        _lineChart.xDescTextFontSize =13;
        [_lineChart showAnimation];
    }
    return _lineChart;
}
-(UIView *)segmentBtnView {
    if (!_segmentBtnView) {
        _segmentBtnView =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,40)];
        _segmentBtnView.backgroundColor =[UIColor whiteColor];
        NSArray *arr =@[@"7天",@"30天"];
       CGFloat btnW  =kScreenWidth/ 2;
        for (int i=0; i<arr.count;i++) {
            UIButton *btn  =[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*btnW,0,btnW,40);
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorFromHexString:@"7c7c7c"] forState:UIControlStateNormal];
            btn.titleLabel.font =PingFangSCRegular15;
            btn.tag =100+i;
            if (i==0) {
                [btn setTitleColor:[UIColor colorFromHexString:@"4090f7"] forState:UIControlStateNormal];
            }
            [self.btnArr addObject:btn];
            [btn addTarget:self action:@selector(changeData:) forControlEvents:UIControlEventTouchUpInside];
            [_segmentBtnView addSubview:btn];
        }
    }
    return _segmentBtnView;
}
-(UILabel *)dayIncomLabel {
    if (!_dayIncomLabel) {
        _dayIncomLabel =[[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.lineChart.frame)+10,120,20)];
        [AppUtils getConfigueLabel:_dayIncomLabel font:PingFangSCRegular15 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"30天收益:"];
    }
    return _dayIncomLabel;
}
-(UILabel *)incomeLabel {
    if (!_incomeLabel) {
        _incomeLabel =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-15-200,CGRectGetMinY(self.dayIncomLabel.frame),200,CGRectGetHeight(self.dayIncomLabel.frame))];
          [AppUtils getConfigueLabel:_incomeLabel font:PingFangSCMedium14 aliment:NSTextAlignmentRight textcolor:[UIColor colorFromHexString:@"f76654"] text:@""];
    }
    return _incomeLabel;
}
-(UIImageView *)incomV {
    if (!_incomV) {
        _incomV =[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.incomeLabel.frame)-12-3,CGRectGetMinY(self.dayIncomLabel.frame)+3,12,12)];
        UIImage * image =[UIImage imageNamed:@"514_goldc_"];
        _incomV.image = image;
    }
    return _incomV;
}
-(UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView =[[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.topInfoView.frame)+10,kScreenWidth,kScreenHeight-NAVIGATION_HEIGHT_S-CGRectGetHeight(self.topInfoView.frame)-10) style:UITableViewStylePlain];
        _listTableView.delegate  =self;
        _listTableView.dataSource = self;
        _listTableView.tableFooterView =[[UIView alloc] init];
        _listTableView.scrollEnabled = NO;
        _listTableView.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
        [_listTableView registerClass:[Hk_walletCell class] forCellReuseIdentifier:@"wallet"];
        
    }
    return _listTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Hk_walletCell * cell =[tableView dequeueReusableCellWithIdentifier:@"wallet" forIndexPath:indexPath];
    cell.iconImageV.hidden = YES;
    cell.nameLabel.frame = CGRectMake(15,cell.nameLabel.frame.origin.y,cell.nameLabel.frame.size.width,cell.nameLabel.frame.size.height);
    cell.countLabel.hidden = NO;
    cell.countIm.hidden = NO;
    
    if (indexPath.row) {
        cell.nameLabel.text =@"结算中";
        cell.countLabel.attributedText =[AppUtils configueLabelAtLeft:YES andCount:self.models.data.settlementIntegral];
    }else {
        cell.nameLabel.text =@"交易中";
        cell.countLabel.attributedText =[AppUtils configueLabelAtLeft:YES andCount:self.models.data.settlementIntegral];
    }
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HK_tradeViewController * tradeVC =[[HK_tradeViewController alloc] init];
    if (indexPath.row) {
        tradeVC.tradeStatus = tradeSucess;
    }else {
        tradeVC.tradeStatus = tradeOn;
    }
    [self.navigationController pushViewController:tradeVC animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    
    [self.view addSubview:self.topInfoView];
    [self.view addSubview:self.listTableView];
    //先获取下7天的数据
    [self getIncomDetails:7];
}
-(void)getIncomDetails:(int)days {
    NSMutableDictionary * dic =[[NSMutableDictionary alloc] init];
    [dic setValue:LOGIN_UID forKey:@"loginUid"];
   //传参数为天数
    [dic setValue:@(days) forKey:@"day"];
    [HK_BaseRequest buildPostRequest:get_UserMyIncome body:dic success:^(id  _Nullable responseObject) {
        NSInteger code =[responseObject[@"code"] integerValue];
        if (code) {
            NSString *msg =responseObject[@"msg"];
            if (msg.length) {
                
                [EasyShowTextView showText:msg];
            }
        }else {
        //有值
            HK_MyIncomeModel * models =[HK_MyIncomeModel mj_objectWithKeyValues:responseObject];
            self.models = models;
            [self.listTableView reloadData];
            self.incomeLabel.attributedText =[AppUtils configueLabelAtLeft:YES andCount:self.models.data.countIntegral];
             self.dayIncomLabel.text =[NSString stringWithFormat:@"%d天收益",days];
            if (days==7) {
                //[self.sevenDaysArr removeAllObjects];
                //获取到7天的数据存放数组 待图表进行显示
               // [self.sevenDaysArr addObjectsFromArray:models.data.days];
            }else {
               // [self.monthArr removeAllObjects];
               // [self.monthArr addObject:models.data.days];
            }
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
//切换显示的数据源
-(void)changeData:(UIButton *)sender {
    NSInteger index = sender.tag-100;
    UIButton * B =[self.btnArr objectAtIndex:index];
    for (UIButton *btn in self.btnArr) {
        [btn setTitleColor:[UIColor colorFromHexString:@"7c7c7c"] forState:UIControlStateNormal];
    }
    [B setTitleColor:[UIColor colorFromHexString:@"4090f7"] forState:UIControlStateNormal];
    if (index==0) {
      //显示7天数据-->更新标题和金币数量
         [self getIncomDetails:7];
    }else {
      //显示1个月数据
        [self getIncomDetails:30];
    }
}
-(void)setUpMonths
{
    [self.lineChart clear];
    self.lineChart.valueArr = @[@[],self.monthArr];
    self.lineChart.xLineDataArr = self.monthsTitlesArr;
    [self.lineChart showAnimation];
}

-(void)setUpDays
{
    [self.lineChart clear];
    self.lineChart.xLineDataArr = [self.daysTitlesArr copy];
    //坐标点显示的数值
    self.lineChart.valueArr = @[@[],self.sevenDaysArr];
    [self.lineChart showAnimation];
}
@end
