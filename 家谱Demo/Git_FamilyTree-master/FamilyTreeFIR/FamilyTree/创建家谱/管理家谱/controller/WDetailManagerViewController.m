//
//  WDetailManagerViewController.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/21.
//  Copyright © 2016年 王子豪. All rights reserved.
//
enum{
    ADDmemberBtnTag,
    ADDmanagerBtnTag
};
#import "WDetailManagerViewController.h"

@interface WDetailManagerViewController ()

@property (nonatomic,strong) UIScrollView *backScrollView; /*背景滚动图*/

/**背景图*/
@property (nonatomic,strong) UIImageView *bakImageView;

@property (nonatomic,strong) RollView *rollView; /*多少代卷谱*/
@property (nonatomic,strong) RollDetailView *rollDetail; /*具体某人*/


@property (nonatomic,strong) UIButton *addMemberBtn;/*新增成员*/
@property (nonatomic,strong) UIButton *addManagerBtn; /*新增管理*/

/**代数数组*/
@property (nonatomic,strong) NSMutableArray *gennerNumberArr;

@end

@implementation WDetailManagerViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initData];
    [self initUI];
    
}

#pragma mark *** 初始化数据 ***
-(void)initData{
    
}
#pragma mark *** 初始化界面 ***
-(void)initUI{
    [self.view addSubview:self.backScrollView];
    [self.backScrollView addSubview:self.rollView];
    [self.backScrollView addSubview:self.rollDetail];
    [self initAllDetailManagerDetailView];
    [self registerNotification];
}

-(void)registerNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAllView) name:kNotificationCodeAddMember object:nil];
    
}

//初始化所有具体图
-(void)initAllDetailManagerDetailView{
    
    NSArray *titleArr = @[@"姓名：",@"养子："];
    
    NSMutableArray *subDetaiArr = [@[] mutableCopy];//具体信息arr。设计图为三种
    
    NSMutableArray *genNum = [@[] mutableCopy];//所有代数
    NSMutableArray *genMemberId = [@[] mutableCopy];//所有代数的成员id，用于添加管理员
    NSMutableArray *headImageArr = [@[] mutableCopy];//所有头像
    
    NSArray <WJPInfoDatalist *>*modelArr = [WDetailJPInfoModel sharedWDetailJPInfoModel].datalist;
    
        [modelArr enumerateObjectsUsingBlock:^(WJPInfoDatalist * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            for (int idx2 = 0; idx2<obj.datas.count; idx2++) {
                
                [genNum addObject:[NSString stringWithFormat:@"第%ld代",(long)obj.ds]];
                //装姓名，亲子，养子的数组
                NSMutableArray *XArr = [@[] mutableCopy];
                //名字
                [XArr addObject:obj.datas[idx2].name];
                //妻子
//                [XArr addObject:obj.datas[idx2].mother&&obj.datas[idx2].mother.length!=0?obj.datas[idx2].mother:@"无"];
                
                //养子
                NSArray *chArr = obj.datas[idx2].chl;
                if (chArr&&chArr.count!=0) {
//                    [XArr addObject:obj.datas[idx2].chl[0]];
                    [XArr addObject:obj.datas[idx2].chl];

                }else{
                    [XArr addObject:@[@""]];
                }
                
                [subDetaiArr addObject:XArr];
                
                [genMemberId addObject:[NSString stringWithFormat:@"%ld",(long)obj.datas[idx2].gemeid]];
                [headImageArr addObject:obj.datas[idx2].photo];
            }
            
        }];
   
    //更新滚动图和大小
    
    _backScrollView.contentSize = AdaptationSize(1040, subDetaiArr.count>4?subDetaiArr.count*270:5*270);
    self.bakImageView.frame = CGRectMake(0, 0, _backScrollView.contentSize.width, _backScrollView.contentSize.height);
    
    NSArray *frameArr = @[[NSNumber numberWithFloat:30+360],
                          [NSNumber numberWithFloat:270],
                          [NSNumber numberWithFloat:195],
                          [NSNumber numberWithFloat:121],
                          [NSNumber numberWithFloat:50]];
    
    /** 设置5代人不同的FrameX */
    NSInteger finCount = 0;
    
    for (int idx = 0; idx<genNum.count; idx++) {
        if (idx>0) {
            if ([genNum[idx-1] isEqualToString:genNum[idx]]) {
                
            }else{
                finCount+=1;
            }
        }
        //布局
        RollDetailView *rollView = [[RollDetailView alloc] initWithFrame:AdaptationFrame([frameArr[finCount] floatValue]-30, 30+idx*240, 500, 200) leftViewDataArr:titleArr rightViewDataArr:subDetaiArr[idx]];
        rollView.genLabel.text = [NSString verticalStringWith:genNum[idx]];
        rollView.myMemberID = genMemberId[idx];
        NSString *imageUrlStr = headImageArr[idx];
        if (imageUrlStr && imageUrlStr.length!=0) {
            rollView.headImageView.imageURL = [NSURL URLWithString:imageUrlStr];
        }
        //每个添加手势
        UITapGestureRecognizer *tapGues = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToRollViewGesture:)];
        [rollView addGestureRecognizer:tapGues];
    
        [self.backScrollView addSubview:rollView];
        
        [self.view addSubview:self.addMemberBtn];
#warning 删掉了新增管理按钮
//        [self.view addSubview:self.addManagerBtn];
        
    }
}

-(void)reloadAllView{
    
    [self updateMemberDataWhileComplete:^{
        
        [self.backScrollView removeAllSubviews];
        
        UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.backScrollView.contentSize.width, self.backScrollView.contentSize.height)];
        backView.image = MImage(@"gljp_bg");
        [self.backScrollView addSubview:backView];
        
        [self.backScrollView addSubview:self.rollView];
        [self.backScrollView addSubview:self.rollDetail];
        [self initAllDetailManagerDetailView];
        backView.frame = CGRectMake(0, 0, self.backScrollView.contentSize.width, self.backScrollView.contentSize.height);
        
    }];
}

-(void)updateMemberDataWhileComplete:(void(^)())back{
    
    [TCJPHTTPRequestManager POSTWithParameters:@{@"gemeid":[WDetailJPInfoModel sharedWDetailJPInfoModel].currentJPID,
                                                 @"geid":[WFamilyModel shareWFamilModel].myFamilyId,
                                                 @"sex":@""} requestID:GetUserId requestcode:kRequestCodequeryzbgemedetaillist success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
                                                     if (succe) {
                                                         WDetailJPInfoModel *detailJP = [WDetailJPInfoModel modelWithJSON:jsonDic[@"data"]];
                                                         [WDetailJPInfoModel sharedWDetailJPInfoModel].datalist = detailJP.datalist;
                                                         
                                                         back();
                                                         
                                                     }
                                                 } failure:^(NSError *error) {
                                                     
                                                 }];
    
}

#pragma mark *** events ***
-(void)respondsToMemberAndManagerBtn:(UIButton *)sender{
    NSLog(@"%@", sender.titleLabel.text);
    if ([sender.titleLabel.text isEqualToString:@"新增成员"]) {
        AddMemberViewController *addMenVc = [[AddMemberViewController alloc] initWithTitle:@"添加成员" image:nil];
        [self.navigationController pushViewController:addMenVc animated:YES];
    }
    
    
    
}
/** 点击视图加载详情 */
-(void)respondsToRollViewGesture:(UIGestureRecognizer *)guesture{
    
    RollDetailView *rollView = (RollDetailView *)guesture.view;
    [TCJPHTTPRequestManager POSTWithParameters:@{@"gemeid":rollView.myMemberID} requestID:GetUserId requestcode:kRequestCodequerygemedetailbyid success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            WpersonInfoModel *model = [WpersonInfoModel modelWithJSON:jsonDic[@"data"]];
            
            WPersonInfoViewController *personVc = [[WPersonInfoViewController alloc] initWithTitle:@"个人信息" image:nil];
            personVc.infoModel = model;
            [self.navigationController pushViewController:personVc animated:YES];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}
#pragma mark *** getters ***
-(UIScrollView *)backScrollView{
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, Screen_width, HeightExceptNaviAndTabbar)];
        _backScrollView.contentSize = AdaptationSize(1040, 3000);
        _backScrollView.contentOffset = AdaptationCenter(360, 0);
        _backScrollView.bounces = false;
        UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _backScrollView.contentSize.width, _backScrollView.contentSize.height)];
        backView.image = MImage(@"gljp_bg");
        
        self.bakImageView = backView;
        [_backScrollView addSubview:self.bakImageView];
        
    }
    return _backScrollView;
}
-(RollView *)rollView{
    if (!_rollView) {
        NSString *title = [WDetailJPInfoModel sharedWDetailJPInfoModel].currentJPName;
        NSInteger idx = [WDetailJPInfoModel sharedWDetailJPInfoModel].currentJPIdx;
        _rollView = [[RollView alloc] initWithFrame:AdaptationFrame(520+360, 30, 135, 360) withTitle:title rollType: idx>1?RollViewTypeDecade:RollViewTypeUnitsDigit];
        
    }
    return _rollView;
}

-(UIButton *)addMemberBtn{
    if (!_addMemberBtn) {
        _addMemberBtn = [[UIButton alloc] initWithFrame:AdaptationFrame(self.view.bounds.size.width/AdaptationWidth()-146, 727, 146, 63)];
        [_addMemberBtn setTitle:@"新增成员" forState:0];
        _addMemberBtn.backgroundColor = [UIColor blackColor];
        _addMemberBtn.alpha =0.8;
        _addMemberBtn.titleLabel.font = WFont(30);
        _addMemberBtn.layer.cornerRadius = 2;
        _addMemberBtn.clipsToBounds = YES;
        _addMemberBtn.tag = ADDmemberBtnTag;
        [_addMemberBtn addTarget:self action:@selector(respondsToMemberAndManagerBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _addMemberBtn;
}
-(UIButton *)addManagerBtn{
    if (!_addManagerBtn) {
        _addManagerBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.addMemberBtn.frame.origin.x, CGRectYH(self.addMemberBtn)+3, self.addMemberBtn.frame.size.width, self.addMemberBtn.frame.size.height)];
        [_addManagerBtn setTitle:@"新增管理" forState:0];
        _addManagerBtn.backgroundColor = self.addMemberBtn.backgroundColor;
        _addManagerBtn.alpha = 0.8;
        _addManagerBtn.titleLabel.font = self.addMemberBtn.titleLabel.font;
        _addManagerBtn.layer.cornerRadius = 2;
        _addManagerBtn.clipsToBounds = YES;
        _addManagerBtn.tag = ADDmanagerBtnTag;
        [_addManagerBtn addTarget:self action:@selector(respondsToMemberAndManagerBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _addManagerBtn;
}
@end
