//
//  HKMyhobbyController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyhobbyController.h"
#import "HKHobyCell.h"
#import "HK_LoginRegesterTool.h"
#import "LCTabBarController.h"
#import "AppDelegate.h"
@interface HKMyhobbyController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView * collectionView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)UIView *topInfoView;
@property (nonatomic, strong)UIView *footSubmitView;
@property (nonatomic, strong)NSMutableArray *selectHobyArr;

@property (nonatomic, strong)UIButton *finishBtn;

@end

@implementation HKMyhobbyController
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
-(NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource =[[NSMutableArray alloc] init];
    }
    return _dataSource;
}
-(NSMutableArray *)selectHobyArr {
    if (!_selectHobyArr) {
        _selectHobyArr =[[NSMutableArray alloc] init];
    }
    return _selectHobyArr;
}
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        CGFloat itemW = (kScreenWidth-60-40)/3;
        CGFloat itemH = itemW +20;

        layout.itemSize =CGSizeMake(itemW,itemH);
        //该方法也可以设置itemSize
        layout.minimumInteritemSpacing =20;
        layout.minimumLineSpacing=20;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.topInfoView.frame),kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight-120-SafeAreaBottomHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[HKHobyCell class] forCellWithReuseIdentifier:@"hoby"];
        _collectionView.showsVerticalScrollIndicator =NO;
    }
    return _collectionView;
}
-(UIView *)topInfoView {
    if (!_topInfoView) {
        _topInfoView =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,60)];
        _topInfoView.backgroundColor =[UIColor whiteColor];
        UILabel *tips =[[UILabel alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,60)];
        [_topInfoView addSubview:tips];
        [AppUtils getConfigueLabel:tips font:PingFangSCRegular16 aliment:NSTextAlignmentCenter textcolor:[UIColor colorFromHexString:@"666666"] text:@"请选择至少4个感兴趣的内容"];
        
    }
    return _topInfoView;
}
-(UIView *)footSubmitView {
    if (!_footSubmitView) {
        _footSubmitView =[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.collectionView.frame),kScreenWidth,60)];
        UIView *lineTop =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,1)];
        lineTop.backgroundColor =[UIColor groupTableViewBackgroundColor];
        [_footSubmitView addSubview:lineTop];
        UIButton *finish =[UIButton buttonWithType:UIButtonTypeCustom];
        self.finishBtn = finish;
        finish.frame =CGRectMake(30,6,kScreenWidth-60,48);
        [_footSubmitView addSubview:finish];
        [AppUtils getButton:finish font:PingFangSCRegular15 titleColor:[UIColor whiteColor] title:@"完成 进入首页"];
        finish.backgroundColor = [UIColor colorFromHexString:@"cccccc"];
        finish.layer.cornerRadius =5;
        finish.layer.masksToBounds =YES;
        [finish addTarget:self action:@selector(finished) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footSubmitView;
}
//完成选择 进入首页
-(void)finished {
    if (self.selectHobyArr.count<4) {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showErrorWithStatus:@"请至少选择4个兴趣"];
        return;
    }
    NSMutableArray *caterStrAr =[[NSMutableArray alloc] init];
    for (HK_userHobyModel *model in self.selectHobyArr) {
       
        [caterStrAr addObject:model.categoryId];
    }
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD show];
    [HK_LoginRegesterTool addCatergoryListForUserWithCaterArray:caterStrAr successBlock:^{
        
        [SVProgressHUD dismiss];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
           
            AppDelegate *delegete =(AppDelegate *)[UIApplication sharedApplication].delegate;
         
            LCTabBarController *tabLC =(LCTabBarController *)delegete.window.rootViewController;
            
            [tabLC setSelectedIndex:0];
    
        }];
        
    } error:^(NSString *error) {
         [SVProgressHUD dismiss];
        [EasyShowTextView showText:error];
    }];
}
#pragma mark 验证按钮的可用性
-(void)verfiyNextBtnAbled {
    
    if (!self.selectHobyArr.count) {
        self.finishBtn.enabled =NO;
        self.finishBtn.backgroundColor =[UIColor colorFromHexString:@"cccccc"];
    }else {
        self.finishBtn.enabled =YES;
        self.finishBtn.backgroundColor = RGB(255,49,34);
    }
}
//跳过
-(void)skip {
    
    UIAlertController *alertController =[UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"确定要跳过此步骤吗?"];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:RGB(35,35,35) range:NSMakeRange(0, 9)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 9)];
    [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    UIAlertAction *cancleA =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancleA setValue:RGB(132,132,132) forKey:@"titleTextColor"];
    
    [alertController addAction:cancleA];
    UIAlertAction *define =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
        }];
    }];
    [define setValue:RGB(233,67,48) forKey:@"titleTextColor"];
    [alertController addAction:define];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(instancetype)init {
    if (self = [super init]) {
         self.sx_disableInteractivePop =YES;
    }
    return self;
}
- (void)viewDidLoad {
     [super viewDidLoad];
    self.title =@"感兴趣的内容";
    self.view.backgroundColor =[UIColor whiteColor];
    self.navigationItem.hidesBackButton =YES;
    [AppUtils addBarButton:self title:@"跳过" action:@selector(skip) position:PositionTypeRight];
    [self.view addSubview:self.topInfoView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.footSubmitView];
    [self getAllCaterHoby];
}
-(void)getAllCaterHoby {
    
    [HK_BaseRequest buildPostRequest:get_mediaAdv_getMainAllCategoryList body:nil success:^(id  _Nullable responseObject) {
        NSArray *data =responseObject[@"data"];
        for (NSDictionary * dic in data) {
            HK_userHobyModel * model =[HK_userHobyModel mj_objectWithKeyValues:dic];
            [self.dataSource addObject:model];
            
        }
        [self.collectionView reloadData];
        
    } failure:^(NSError * _Nullable error) {
        
    }
     ];
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0,30,20,30);
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HKHobyCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"hoby" forIndexPath:indexPath];
    cell.userModel =self.dataSource[indexPath.row];
   
    return cell;

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HK_userHobyModel * model =self.dataSource[indexPath.row];
    model.isSelect  =! model.isSelect;
    [self.collectionView reloadData];
    [self.selectHobyArr removeAllObjects];
   //获取所有选中的模型
    for (HK_userHobyModel *model in self.dataSource) {
        if (model.isSelect) {
            if (![self.selectHobyArr containsObject:model]) {
                [self.selectHobyArr addObject:model];
            }
        }
    }
    
    [self verfiyNextBtnAbled];
    
}
@end
