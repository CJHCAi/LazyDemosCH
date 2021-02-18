//
//  FortuneTodayViewController.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/4.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "FortuneTodayViewController.h"
#import "HeadLuckView.h"
#import "AllLucyNum.h"
#import "NSString+getStarDate.h"
#import "FortuneTodayModel.h"

@interface FortuneTodayViewController ()
{
    NSMutableArray *_dataSource;
    NSMutableArray *_iconCount;
}

/** 今日运势模型*/
@property (nonatomic, strong) FortuneTodayModel *fortuneTodayModel;
/** 今日运势头部视图*/
@property (nonatomic, strong) HeadLuckView *heav;

@end

@implementation FortuneTodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.comNavi.titleLabel.text = @"今日运势";
    [self getMainData];
}

-(void)getMainData{
    NSDictionary *logDic = @{@"userid":[NSString stringWithFormat:@"%@",GetUserId]};
    WK(weakSelf)
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:kRequestCodeGetMemys success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            MYLog(@"%@",jsonDic[@"data"]);
            weakSelf.fortuneTodayModel = [FortuneTodayModel modelWithJSON:jsonDic[@"data"]];
            
            [weakSelf initData];
            [weakSelf initForUI];
            //[weakSelf initHeadLuckData];
            
            
        }else{
            MYLog(@"%@",jsonDic[@"message"]);
        }
    } failure:^(NSError *error) {
        MYLog(@"失败---%@",error.description);
    }];

    
    
}

#pragma mark *** 初始化数据 ***
-(void)initData{
//    _iconCount = @[@"3",@"2",@"1",@"4"];
//    _dataSource = @[@"今天出门上班前要多检查随身物品，不要忘记带重要文件，记忆力可是有点不太靠谱破！工作今天出门上班前要多检查随身物品，不要忘记带重要文件，记忆力可是有点不太靠谱破！工作。sss",@"需要多花些心思在感情经营上。",@"工作上需要特别小心处理细节问题",@"彩云状况不错可以放心投资"];
    _iconCount = [@[] mutableCopy];
    if (self.fortuneTodayModel.jr.all) {
        [_iconCount addObject:@([self.fortuneTodayModel.jr.all intValue]/20)];
        [_iconCount addObject:@([self.fortuneTodayModel.jr.love intValue]/20)];
        [_iconCount addObject:@([self.fortuneTodayModel.jr.work intValue]/20)];
        [_iconCount addObject:@([self.fortuneTodayModel.jr.money intValue]/20)];
    }else{
        [_iconCount addObject:@0];
        [_iconCount addObject:@0];
        [_iconCount addObject:@0];
        [_iconCount addObject:@0];
    }
    _dataSource = [@[] mutableCopy];
    if (self.fortuneTodayModel.jr.summary) {
        [_dataSource addObject:self.fortuneTodayModel.jr.summary];
    }else{
        [_dataSource addObject:@""];
    }
    if (self.fortuneTodayModel.bz.love) {
        [_dataSource addObject:self.fortuneTodayModel.bz.love];
        [_dataSource addObject:self.fortuneTodayModel.bz.work];
        [_dataSource addObject:self.fortuneTodayModel.bz.money];
    }else{
        [_dataSource addObject:@""];
        [_dataSource addObject:@""];
        [_dataSource addObject:@""];
    }
    
    
    
}

//初始化headLuckView数据
-(void)initHeadLuckData{
   if (self.fortuneTodayModel.jr.all){
        self.heav.headPorTime.text = [NSString getStarDateWithStar:self.fortuneTodayModel.jr.name];
        self.heav.healthNum.text = self.fortuneTodayModel.jr.health;
        self.heav.chatNum.text = self.fortuneTodayModel.jr.work;
        self.heav.luckyColor.text = self.fortuneTodayModel.jr.color;
        self.heav.luckyNum.text = [NSString stringWithFormat:@"%ld",(long)self.fortuneTodayModel.jr.number];
        self.heav.coupleAite.text = self.fortuneTodayModel.jr.qfriend;
       self.heav.headPortraits.image = MImage([NSString getStarImageName:self.fortuneTodayModel.jr.name]);
    }else{
        self.heav.headPorTime.text = @"";
        self.heav.healthNum.text = @"";
        self.heav.chatNum.text = @"";
        self.heav.luckyColor.text = @"";
        self.heav.luckyNum.text = @"";
        self.heav.coupleAite.text = @"";
    }
    
}

#pragma mark *** 初始化界面 ***
-(void)initForUI{
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:MImage(@"bg")];
    bgView.frame = CGRectMake(0, 64, Screen_width, Screen_height);
    [self.view addSubview:bgView];
    
    self.heav = [[HeadLuckView alloc] initWithFrame:CGRectMake(20, 20, Screen_width-40, 0.21*Screen_height)];
    [self initHeadLuckData];
    [self.view addSubview:self.heav];
    
    AllLucyNum *lucyView = [[AllLucyNum alloc] initWithFrame:CGRectMake(20, CGRectYH(self.heav)+0.015*Screen_height, self.heav.bounds.size.width, 15) TitleImage:MImage(@"todayYS_ZH_TitIMG") title:@"综合运势" lucyIconImage:MImage(@"todayYS_ZH_redXing") nullImage:MImage(@"todayYS_ZH_whiteXing") iconAmount:[_iconCount[0] integerValue] detailDsc:_dataSource[0]];
 
    
    AllLucyNum *loveLuc = [[AllLucyNum alloc] initWithFrame:CGRectMake(20, CGRectYH(lucyView)+0.015*Screen_height,self.heav.bounds.size.width, 10) TitleImage:MImage(@"todayYS_LV_TitIMG") title:@"爱情运势" lucyIconImage:MImage(@"todayYS_LV_reds") nullImage:MImage(@"todayYS_LV_whites") iconAmount:[_iconCount[1] integerValue] detailDsc:_dataSource[1]];
   
    
    AllLucyNum *businStu = [[AllLucyNum alloc] initWithFrame:CGRectMake(20, CGRectYH(loveLuc)+0.015*Screen_height, self.heav.bounds.size.width, 10) TitleImage:MImage(@"todayYS_learn_TitIMG") title:@"事业学业" lucyIconImage:MImage(@"todayYS_learn_blues") nullImage:MImage(@"todayYS_learn_whites") iconAmount:[_iconCount[2] integerValue] detailDsc:_dataSource[2]];
   
    
    AllLucyNum *treasureLuc = [[AllLucyNum alloc] initWithFrame:CGRectMake(20, CGRectYH(businStu)+0.015*Screen_height, self.heav.bounds.size.width, 10) TitleImage:MImage(@"todayYS_Wl_TitIMG") title:@"运势财富" lucyIconImage:MImage(@"todayYS_Wl_haveMoney") nullImage:MImage(@"todayYS_Wl_noMoney") iconAmount:[_iconCount[3] integerValue] detailDsc:_dataSource[3]];
   
    
    UIScrollView *bacScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-60)];
    bacScrollView.bounces = NO;
    bacScrollView.contentSize = CGSizeMake(Screen_width, 84+CGRectSize(self.heav).height+lucyView.bounds.size.height+loveLuc.bounds.size.height+businStu.bounds.size.height+treasureLuc.bounds.size.height+50);
    [self.view addSubview:bacScrollView];
    
    [bacScrollView addSubview:self.heav];
    [bacScrollView addSubview:lucyView];
    [bacScrollView addSubview:loveLuc];
    [bacScrollView addSubview:businStu];
    [bacScrollView addSubview:treasureLuc];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
