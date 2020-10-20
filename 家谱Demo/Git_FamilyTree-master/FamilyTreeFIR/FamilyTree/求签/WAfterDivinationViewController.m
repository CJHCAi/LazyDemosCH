//
//  WAfterDivinationViewController.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/20.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WAfterDivinationViewController.h"
#import "LotteryPoetryModel.h"
#import "InitialLotteryPoetryViewController.h"

@interface WAfterDivinationViewController ()
@property (nonatomic,strong) UIImageView *backImageView; /*背景*/
@property (nonatomic,strong) UILabel *divLabelNum; /*多少签*/
@property (nonatomic,strong) UILabel *divLabelType; /*哪种签*/

@property (nonatomic,strong) UILabel *contLabelfis; /*内容1*/
@property (nonatomic,strong) UILabel *contLabelSen; /*内容2*/

@property (nonatomic,strong) UIButton *analyseDiv; /*解签*/

/** 签文模型*/
@property (nonatomic, strong) LotteryPoetryModel *lotteryPoetryModel;
/** 签诗数组*/
@property (nonatomic, strong) NSArray *poetryArr;
@end

@implementation WAfterDivinationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.comNavi.titleLabel.text = @"签诗";
    [self getData];
    [self.view addSubview:self.backImageView];
    [self.backImageView addSubview:self.contLabelfis];
    [self.backImageView addSubview:self.contLabelSen];
    [self.backImageView addSubview:self.analyseDiv];
}

-(void)getData{
    NSDictionary *logDic = @{@"userid":[NSString stringWithFormat:@"%@",GetUserId]};
    WK(weakSelf)
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:@"getmemqq" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"%@",jsonDic[@"data"]);
        if (succe) {
            weakSelf.lotteryPoetryModel = [LotteryPoetryModel modelWithJSON:jsonDic[@"data"]];
            weakSelf.divLabelNum.text = [NSString verticalStringWith:weakSelf.lotteryPoetryModel.qh];
            weakSelf.divLabelType.text = [NSString verticalStringWith:[NSString stringWithFormat:@"%@之签",weakSelf.lotteryPoetryModel.qwhh]];
            //[weakSelf initInfoLotteryPoetryLBs];
            NSString *poetryStr = [weakSelf.lotteryPoetryModel.qs stringByReplacingOccurrencesOfString:@"," withString:@" "];
            NSString *poetryStr1 = [poetryStr stringByReplacingOccurrencesOfString:@"." withString:@" "];
            weakSelf.poetryArr = [poetryStr1 componentsSeparatedByString:@"\\n"];
            weakSelf.contLabelfis.text = [NSString verticalStringWith:weakSelf.poetryArr[0]];
            weakSelf.contLabelSen.text = [NSString verticalStringWith:weakSelf.poetryArr[1]];
            
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}




#pragma mark *** events ***
-(void)respondsToAnalyseBtn:(UIButton *)sender{
    MYLog(@"解签");
    InitialLotteryPoetryViewController *initialVC = [[InitialLotteryPoetryViewController alloc]initWithTitle:@"初解" image:nil];
    initialVC.lotteryPoetryModel = self.lotteryPoetryModel;
    [self.navigationController pushViewController:initialVC animated:YES];
    
}

#pragma mark *** getters ***

-(UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, Screen_width, HeightExceptNaviAndTabbar)];
        _backImageView.image = MImage(@"ydq_bg");
        _backImageView.userInteractionEnabled = YES;
        UIImageView *redBack = [[UIImageView alloc] initWithFrame:AdaptationFrame(450, 50, 100, 800)];
        redBack.image = MImage(@"ydq_yw");
        [_backImageView addSubview:redBack];
        [redBack addSubview:self.divLabelNum];
        [redBack addSubview:self.divLabelType];
        
    }
    return _backImageView;
}

-(UILabel *)divLabelNum{
    if (!_divLabelNum) {
        _divLabelNum = [[UILabel alloc] initWithFrame:AdaptationFrame(25, 30, 60, 340)];
        _divLabelNum.font = BFont(50*AdaptationWidth());
        _divLabelNum.textAlignment = 1;
        _divLabelNum.textColor = [UIColor blackColor];
        //_divLabelNum.text = [NSString verticalStringWith:@"第九十九签"];
        _divLabelNum.numberOfLines = 0;
    }
    return _divLabelNum;
}

-(UILabel *)divLabelType{
    if (!_divLabelType) {
        _divLabelType = [[UILabel alloc] initWithFrame:AdaptationFrame(25, 510, 40, 200)];
        _divLabelType.font = WFont(40);
        _divLabelType.textAlignment = 1;
        _divLabelType.textColor = LH_RGBCOLOR(85, 27, 1);
        _divLabelType.numberOfLines = 0;
        //_divLabelType.text = [NSString verticalStringWith:@"上上之签"];
    }
    return _divLabelType;
}
-(UILabel *)contLabelfis{
    if (!_contLabelfis) {
        _contLabelfis = [[UILabel alloc] initWithFrame:AdaptationFrame(185, 96, 58, 780)];
        _contLabelfis.font = WFont(40);
        _contLabelfis.textAlignment = 1;
        _contLabelfis.numberOfLines = 0;
        //_contLabelfis.text = [NSString verticalStringWith:@"得意春风绣满绣 码头声唱状元高"];
    }
    return _contLabelfis;
}
-(UILabel *)contLabelSen{
    if (!_contLabelSen) {
        _contLabelSen = [[UILabel alloc] initWithFrame:AdaptationFrame(CGRectXW(self.contLabelfis)/AdaptationWidth()+60, 96, 58, 780)];
        _contLabelSen.font = WFont(40);
        _contLabelSen.textAlignment = 1;
        _contLabelSen.numberOfLines = 0;
        //_contLabelSen.text = [NSString verticalStringWith:@"帅灵地杰逞英豪 一箭分明点大敖"];
        
    }
    return _contLabelSen;
}

-(UIButton *)analyseDiv{
    if (!_analyseDiv) {
        _analyseDiv = [[UIButton alloc] initWithFrame:AdaptationFrame(231, (CGRectGetMinY(self.tabBarController.tabBar.frame)/AdaptationWidth()-280), 285, 72)];
        _analyseDiv.layer.cornerRadius = 36*AdaptationWidth();
        _analyseDiv.clipsToBounds = YES;
        [_analyseDiv addTarget:self action:@selector(respondsToAnalyseBtn:) forControlEvents:UIControlEventTouchUpInside];
    
        [_analyseDiv setImage:MImage(@"ydq_bt") forState:0];
        
    }
    return _analyseDiv;
}




@end
