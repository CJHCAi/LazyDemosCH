//
//  FamilyTreeViewController.m
//  FamilyTree
//
//  Created by 王子豪 on 16/5/24.
//  Copyright © 2016年 王子豪. All rights reserved.
//


enum{
    ItemSelectedSeaIndex = 1,
    ItemSelectedGemImageIndex,
    ItemSelectedReadGemIndex,
    ItemSelectedZBIndex,
    ItemSelectedVideoIndex
};

#import "FamilyTreeViewController.h"
#import "FamilyTreeTopView.h"
#import "SearchFamilyTreeViewController.h"
#import "CreatFamilyTree.h"
#import "ManagerFamilyViewController.h"
#import "WFamilyTableView.h"
#import "WApplyJoinView.h"
@interface FamilyTreeViewController ()<FamilyTreeTopViewDelegate,CreatFamilyTreeDelegate,SelectMyFamilyViewDelegate>
{
    BOOL _selectedCreatBtn;
    BOOL _selectedMyFam;
    NSInteger _selectedCreateBtnType;//测试数据之后删
    
}
/**创建家谱Btn*/
@property (nonatomic,strong) UIButton *creatBtn;

/**入谱人数*/
@property (nonatomic,strong) UILabel *allFamilyNumber;

/**入谱辈数*/
@property (nonatomic,strong) UILabel *allFamilGenNumber;

/**创建家谱view*/
@property (nonatomic,strong) CreatFamilyTree *crtFamTree;

/**没有管理权限的创建家谱*/
@property (nonatomic,strong) CreatFamilyTree *crtFamTreeNoRight;

/**我的家谱点出来的视图*/
@property (nonatomic,strong) SelectMyFamilyView *selecMyFamView;

/**首页家谱Table*/
@property (nonatomic,strong) WFamilyTableView *famTableView;

/**顶部栏*/
@property (nonatomic,strong) FamilyTreeTopView *famTreeTopView;

/**加入家谱view*/
@property (nonatomic,strong) WApplyJoinView *joinView;


@end

@implementation FamilyTreeViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //读取本地数家谱id
    if ([USERDEFAULT objectForKey:kNSUserDefaultsMyFamilyID]) {
        [WFamilyModel shareWFamilModel].myFamilyId = [USERDEFAULT objectForKey:kNSUserDefaultsMyFamilyID];
        [WFamilyModel shareWFamilModel].myFamilyName = [USERDEFAULT objectForKey:kNSUserDefaultsMyFamilyName];
    }
    
    //设置导航栏
    self.navigationController.navigationBarHidden = YES;
    [self initNavi];
    //设置背景图
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, Screen_width , Screen_height-64-49)];
    backImageView.image = MImage(@"bg.png");
    [self.view addSubview:backImageView];
    
    //设置5个button
    [self initFiveButton];
    
    //添加左右两个label
    [self initLeftAndRightLabel];
    
    /** 添加tableview */
    [self.view addSubview:self.famTableView];

    //创建家谱按钮
    [self.view addSubview:self.creatBtn];
    /** 注册通知 */
    [self registNotification];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    //更新数据
    [self getFamInfo];
    if ([USERDEFAULT objectForKey:kNSUserDefaultsMyFamilyID]) {
        [self getFamDetailInfo];

    }else{
        [self reloadAllData];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.creatBtn.selected = false;
    
}
#pragma mark *** 注册通知 ***
-(void)registNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondsToNotification:) name:KNotificationCodeSeletedMyFamilItem object:nil];
}
/** 通知实现方法 */
-(void)respondsToNotification:(NSNotification *)info{
    //变化我的家谱按钮状态
    
    
//    NSDictionary *dic = info.userInfo;
//    NSInteger itemIndex = [dic[@"itemName"] integerValue];
//    //获取所有VC
//    NSArray *vcArr = [self.navigationController viewControllers];
//
//    switch (itemIndex) {
//        case ItemSelectedSeaIndex:
//        {
//            if ([vcArr.lastObject isKindOfClass:[WholeWorldViewController class]]) {
//                return;
//            }
//            WholeWorldViewController *wholeVc = [[WholeWorldViewController alloc] initWithTitle:@"四海同宗"];
//            [self.navigationController pushViewController:wholeVc animated:YES];
//        
//        }
//            break;
//        case ItemSelectedGemImageIndex:
//        {
//            if ([vcArr.lastObject isKindOfClass:[LineageViewController class]]) {
//                return;
//            }
//            LineageViewController *lineVc = [[LineageViewController alloc] initWithTitle:@"世系图"];
//            [self.navigationController pushViewController:lineVc animated:YES];
//        }
//            break;
//        case ItemSelectedReadGemIndex:
//        {
//            
//            ImageAndTextViewController *readVc = [[ImageAndTextViewController alloc] initWithTitle:@"阅读家谱"];
//            NSLog(@"%@", readVc.comNavi.titleLabel.text);
//            BaseViewController *lastVc = vcArr.lastObject;
//            if ([lastVc isKindOfClass:[ImageAndTextViewController class]]&&[lastVc.comNavi.titleLabel.text isEqualToString:@"阅读家谱"]) {
//                return;
//            }
//            
//            [self.navigationController pushViewController:readVc animated:YES];
//            
//        }
//            break;
//        case ItemSelectedZBIndex:
//        {
//            if ([vcArr.lastObject isKindOfClass:[GennerationViewController class]]) {
//                return;
//            }
//            GennerationViewController *zbVc = [[GennerationViewController alloc] init];
//            [self.navigationController pushViewController:zbVc animated:YES];
//        }
//            break;
//        case ItemSelectedVideoIndex:
//        {
//            
//            ImageAndTextViewController *imageVc = [[ImageAndTextViewController alloc] initWithTitle:@"图文影音"];
//             BaseViewController *lastVc = vcArr.lastObject;
//            if ([lastVc isKindOfClass:[ImageAndTextViewController class]]&&[lastVc.comNavi.titleLabel.text isEqualToString:@"图文影音"]) {
//                return;
//            }
//            [self.navigationController pushViewController:imageVc animated:YES];
//        }
//            break;
//
//        default:
//            break;
//    }
}
#pragma mark - 视图搭建
//设置导航栏
-(void)initNavi{

    FamilyTreeTopView *topView = [[FamilyTreeTopView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, StatusBar_Height+NavigationBar_Height)];
    topView.delegate = self;
    self.famTreeTopView = topView;
    [self.view addSubview:self.famTreeTopView];
}

//设置5个button
-(void)initFiveButton{
    CGFloat widthSpace = 10;
    CGFloat btnWidth = (Screen_width - 10*4-30)/5;
    CGFloat btnHeight = 0.2*Screen_height;
    NSArray *btnImageNames = @[@"kuang1",@"kuang4",@"kuang3",@"kuang2",@"kuang5"];
    for (int i = 0; i < 5; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15+widthSpace*i+btnWidth*i, 10+64, btnWidth, btnHeight)];
        [btn setImage:MImage(btnImageNames[i]) forState:UIControlStateNormal];
        btn.tag = 1000+i+1;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}


//添加左右两个label
-(void)initLeftAndRightLabel{
    CGFloat btnHeight = 0.2*Screen_height;
    //添加左边label
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 84+btnHeight, Screen_width/2-15, 30)];
    leftLabel.text = @"已入谱人数-人";
    leftLabel.textAlignment = NSTextAlignmentLeft;
    leftLabel.font = MFont(12);
    self.allFamilyNumber = leftLabel;
    [self.view addSubview:self.allFamilyNumber];
    //添加右边label
    UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width/2, 64+10+btnHeight+10, Screen_width/2-15, 30)];
    rightLabel.text = @"已入谱-辈";
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.font=MFont(12);
    self.allFamilGenNumber = rightLabel;
    [self.view addSubview:self.allFamilGenNumber];    
}

#pragma mark *** 网络请求 ***
//我的所有家谱
-(void)getFamInfo{
    
    [TCJPHTTPRequestManager POSTWithParameters:@{@"query":@"",@"type":@"MyGen"} requestID:GetUserId requestcode:kRequestCodequerymygen success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            
            NSString *jsonStr = [NSString stringWithFormat:@"%@",jsonDic[@"data"]];
            
            
            NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray *allFamNams = [@[] mutableCopy];
            NSMutableArray *allFamIds = [@[] mutableCopy];
            for (NSDictionary *dic in arr) {
                [allFamNams addObject:dic[@"GeName"]];
                [allFamIds addObject:dic[@"Geid"]];
            }
            
            [WSelectMyFamModel sharedWselectMyFamModel].myFamArray = allFamNams;
            [WSelectMyFamModel sharedWselectMyFamModel].myFamIdArray = allFamIds;
    
        }
    } failure:^(NSError *error) {
        MYLog(@"失败");
    }];
}

//家谱首页信息
-(void)getFamDetailInfo{
    
    NSString *geId = @"";
    if ([USERDEFAULT objectForKey:kNSUserDefaultsMyFamilyID]) {
        geId = [USERDEFAULT objectForKey:kNSUserDefaultsMyFamilyID];
    }else{
        geId = [WFamilyModel shareWFamilModel].myFamilyId;
    }

    [TCJPHTTPRequestManager POSTWithParameters:@{@"GeId":geId} requestID:GetUserId requestcode:kRequestCodegetintogen success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            
            WFamilyModel *model = [WFamilyModel modelWithJSON:jsonDic[@"data"]];
            
            [WFamilyModel shareWFamilModel].ds = model.ds;
            [WFamilyModel shareWFamilModel].rs = model.rs;
            [WFamilyModel shareWFamilModel].datalist = model.datalist;
            //更新数据
            [self reloadAllData];
        }
    } failure:^(NSError *error) {
        
    }];
}
/** 更新数据 */
-(void)reloadAllData{
    
    [self.famTableView.tableView reloadData];
    self.allFamilyNumber.text = [NSString stringWithFormat:@"已入谱人数%ld人",(long)[WFamilyModel shareWFamilModel].rs];
    self.allFamilGenNumber.text = [NSString stringWithFormat:@"已入谱%ld辈",(long)[WFamilyModel shareWFamilModel].ds];

}

#pragma mark - 事件
//给5个button添加点击事件跳转
-(void)clickBtn:(UIButton *)sender{
    
    switch (sender.tag) {
        case 1001:
            //跳转
        {
            NSLog(@"四海同宗");
            WholeWorldViewController *wholeVc = [[WholeWorldViewController alloc] initWithTitle:@"四海同宗"];
            [self.navigationController pushViewController:wholeVc animated:YES];
            break;
        }
        case 1002:
        {
            //跳转
            NSLog(@"世系图");
            LineageViewController *lineageVC = [[LineageViewController alloc]initWithTitle:@"世系图"];
            [self.navigationController pushViewController:lineageVC animated:YES];
        }
            break;
        case 1003:
            //跳转
        {
            NSLog(@"阅读家谱");
            ImageAndTextViewController *imageTextVC = [[ImageAndTextViewController alloc]initWithTitle:@"阅读家谱"];

            [self.navigationController pushViewController:imageTextVC animated:YES];
        }
            break;
        case 1004:
        {
            //跳转
            NSLog(@"字辈");
            GennerationViewController *gennerVc = [[GennerationViewController alloc] init];
            [self.navigationController pushViewController:gennerVc animated:YES];
        }
            break;
        case 1005:
        {
            //跳转
            NSLog(@"图文影像");
            ImageAndTextViewController *imageTextVC = [[ImageAndTextViewController alloc]initWithTitle:@"图文影音"];
            [self.navigationController pushViewController:imageTextVC animated:YES];
        }
            break;
        default:
            break;
    }
    
}
-(void)respondsToCreatBtn:(UIButton *)sender{
    
//    _selectedCreateBtnType +=1;
//    if (_selectedCreateBtnType == 1) {
//        
//        [self.view addSubview:self.crtFamTree];
//    }else if(_selectedCreateBtnType ==2){
//        [_crtFamTree removeFromSuperview];
//        
//        [self.view addSubview:self.crtFamTreeNoRight];
//
//    }else {
//        [_crtFamTreeNoRight removeFromSuperview];
//        
//         _selectedCreateBtnType = 0;
//    }
//    sender.selected = !sender.selected;
//    if (sender.selected) {
        [self.view addSubview:self.crtFamTree];
//    }else{
//        [self.crtFamTree removeFromSuperview];
//    }
}

#pragma mark - FamilyTreeTopViewDelegate
-(void)TopSearchViewDidTapView:(FamilyTreeTopView *)topSearchView{
    MYLog(@"点击搜索栏");
    [SXLoadingView showProgressHUD:@"正在搜索"];
    /** 获取搜索信息 */
    [TCJPHTTPRequestManager POSTWithParameters:@{@"query":self.famTreeTopView.searchLabel.text,@"pagenum":@"1",@"pagesize":@"20",@"ismygen":@"0"} requestID:GetUserId requestcode:kRequestCodequerygenandgemelist success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            
            WSearchModel *searchModel = [WSearchModel modelWithJSON:jsonDic[@"data"]];
            
            [WSearchModel shardSearchModel].genlist = searchModel.genlist;
            [WSearchModel shardSearchModel].datatype = searchModel.datatype;
            [WSearchModel shardSearchModel].page = searchModel.page;
            [SXLoadingView hideProgressHUD];
            //赋值完过后跳转
            SearchFamilyTreeViewController *seachVc = [[SearchFamilyTreeViewController alloc]init];
            [self.navigationController pushViewController:seachVc animated:YES];
            
        }
    } failure:^(NSError *error) {
        
    }];
      
}
-(void)TopSearchView:(FamilyTreeTopView *)topSearchView didRespondsToMenusBtn:(UIButton *)sender{
    MYLog(@"点击我的家谱");
    
    if (sender.selected) {
        
        [self.view addSubview:self.selecMyFamView];
    }else{
         [self.selecMyFamView removeFromSuperview];
    }
    [self.selecMyFamView updateDataSourceAndUI];
    
}

#pragma mark *** createTreeDelegate ***

-(void)CreateFamilyTree:(CreatFamilyTree *)creatTree didSelectedBtn:(UIButton *)sender{
    
        if (sender.tag == 0) {
            CreateFamViewController *creVc = [[CreateFamViewController alloc] initWithTitle:@"创建家谱" image:nil];
            creVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:creVc animated:YES];
            
        }
        if (sender.tag == 1) {
            
            [self TopSearchViewDidTapView:nil];
            
        }
        if (sender.tag == 2) {
            
            if (![USERDEFAULT objectForKey:kNSUserDefaultsMyFamilyID]) {
                [SXLoadingView showAlertHUD:@"请先选择一个家谱" duration:0.5];
                return;
        }
            
        ManagerFamilyViewController *manager = [[ManagerFamilyViewController alloc] initWithTitle:@"管理家谱" image:nil];
        [manager.comNavi.rightBtn removeFromSuperview];
        [self.navigationController pushViewController:manager animated:YES];
    }
    if (sender.tag!=1) {
        [self.crtFamTree removeFromSuperview];
    }

}

-(void)SelectMyFamilyViewDelegate:(SelectMyFamilyView *)seleMyFam didSelectFamTitle:(NSString *)title SelectFamID:(NSString *)famId{
    //更新界面
    [self getFamDetailInfo];
    self.famTreeTopView.menuBtn.selected = false;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark *** getters ***

-(UIButton *)creatBtn{
    if (!_creatBtn) {
        _creatBtn = [[UIButton alloc] initWithFrame:CGRectMake(Screen_width-105*AdaptationWidth(), Screen_height-self.tabBarController.tabBar.bounds.size.height-2*105*AdaptationWidth(), 105*AdaptationWidth(), 105*AdaptationWidth())];
        [_creatBtn setImage:MImage(@"noJP_cj_open") forState:UIControlStateNormal];
        [_creatBtn addTarget:self action:@selector(respondsToCreatBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _creatBtn;
}
-(CreatFamilyTree *)crtFamTree{
    if (!_crtFamTree) {
        _crtFamTree = [[CreatFamilyTree alloc] initWithFrame: CGRectMake(0, 64, Screen_width, HeightExceptNaviAndTabbar) withType:CreatefamilyTreeTypeThreeBtn];
        _crtFamTree.delegate = self;
        
    }
    return _crtFamTree;
}
-(CreatFamilyTree *)crtFamTreeNoRight{
    if (!_crtFamTreeNoRight) {
        _crtFamTreeNoRight = [[CreatFamilyTree alloc] initWithFrame: AdaptationFrame(62, 495, 517, 373) withType:CreatefamilyTreeTypeTwoBtn];
        _crtFamTreeNoRight.delegate = self;
        
    }
    return _crtFamTreeNoRight;
}
-(SelectMyFamilyView *)selecMyFamView{
    if (!_selecMyFamView) {
        _selecMyFamView = [[SelectMyFamilyView alloc] initWithFrame:CGRectMake(0, 64, Screen_width, HeightExceptNaviAndTabbar)];
        _selecMyFamView.delegate = self;
    }
    [_selecMyFamView.tableView reloadData];
    
    return _selecMyFamView;
}
-(WFamilyTableView *)famTableView{
    if (!_famTableView) {
        _famTableView = [[WFamilyTableView alloc] initWithFrame:CGRectMake(15, 74+0.2*Screen_height+40, Screen_width-30, 670*AdaptationWidth())];
        _famTableView.backgroundColor = [UIColor clearColor];
    }
    return _famTableView;
}
-(WApplyJoinView *)joinView{
    if (!_joinView) {
        _joinView = [[WApplyJoinView alloc] initWithFrame:CGRectMake(0, 64, Screen_width, HeightExceptNaviAndTabbar) checkType:WApplyJoinViewNeedlessCheck];
    }
    return _joinView;
}
@end
