//
//  HKCityTravelsViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCityTravelsViewController.h"
#import "HKLeSeeViewModel.h"
#import "HKCityTravelsRespone.h"
#import "HKCityTravelsTableViewCell.h"
#import "HKHtmlTableViewCell.h"
#import "HKCItyTravelsNav.h"
#import "HKCityToolBar.h"
#import "HKLeSeeViewModel.h"
#import "HKRewardViewsController.h"
#import "HKLeSeeVideoMyGoodsViewController.h"
#import "HKSelfVideoToolViewController.h"
@interface HKCityTravelsViewController ()<UITableViewDelegate,UITableViewDataSource,CityBarDelegete,HKLeSeeVideoMyGoodsViewControllerDelegate,HKSelfVideoToolViewControllerDeleagte,HKHtmlTableViewCellDeleagte>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)HKCityTravelsRespone *respone;
@property (nonatomic, strong)HKCItyTravelsNav *navView;
@property (nonatomic, strong)HKCityToolBar *cityBar;
@property (nonatomic,weak) HKSelfVideoToolViewController *toolVc;
@end

@implementation HKCityTravelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadNewData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
     [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
-(void)loadNewData{
    [HKLeSeeViewModel getCityAdvInfo:@{@"cityAdvId":self.cityAdvId,@"loginUid":HKUSERLOGINID} success:^(HKCityTravelsRespone *responde) {
        [self.tableView.mj_header  endRefreshing];
        if (responde.responeSuc) {
            self.respone = responde;
            self.cityBar.response =self.respone;
            [self.tableView reloadData];
        }
    }];
}
-(void)setUI{
    [self.view addSubview:self.tableView];

    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];

    if (self.isCity) {
        [self.view addSubview:self.cityBar];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.view).offset(-StatusBarHeight);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-60);
            
        }];
    }else{
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.view).offset(-StatusBarHeight);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
            
        }];
    }
}

-(HKCityToolBar *)cityBar {
    if (!_cityBar) {
        _cityBar =[[HKCityToolBar alloc] initWithFrame:CGRectMake(0,kScreenHeight-50,kScreenWidth,50)];
        _cityBar.delegete = self;
    }
    return _cityBar;
}
-(void)ClickSender:(UIButton *)sender andSenderTag:(NSInteger)tag {
    switch (tag-10) {
        case 0:
        {
           //点赞取消点赞
           NSString * prised = self.respone.data.praiseState.intValue ? @"0":@"1";
            [HKLeSeeViewModel getCityPraiseWithState:prised andCityId:self.cityAdvId success:^(HKBaseResponeModel *responde) {
                if (responde.responeSuc) {
                    [sender setTitle:(NSString *)responde.data forState:UIControlStateNormal];
                    self.respone.data.praiseState = prised.intValue ?@"1":@"0";
                    sender.selected =! sender.selected;
                }
            }];
            
        }
            break;
        case 1:
        {
            HKSelfVideoToolViewController*vc = [[HKSelfVideoToolViewController alloc]init];
            vc.delegate = self;
            vc.cityResponse =self.respone;
            self.navigationController.definesPresentationContext = YES;
            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            vc.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0];
            self.toolVc = vc;
            [self.navigationController presentViewController:vc animated:YES completion:nil];
        }
            break;
        case 2:
        {
            //收藏
            NSString * prised = self.respone.data.collectionState.intValue ? @"0":@"1";
            [HKLeSeeViewModel getCityCollectionWithState:prised andCityId:self.cityAdvId success:^(HKBaseResponeModel *responde) {
                if (responde.responeSuc) {
                    [sender setTitle:(NSString *)responde.data forState:UIControlStateNormal];
                    self.respone.data.collectionState = prised.intValue ?@"1":@"0";
                    sender.selected =! sender.selected;
                }
            }];
        }
            break;
        case 3:
        {
            [HKRewardViewsController showReward:self andType:1 andId:self.cityAdvId];
        }
            break;
        case 4:
        {
            HKLeSeeVideoMyGoodsViewController*vc = [[HKLeSeeVideoMyGoodsViewController alloc]init];
            vc.delegate = self;
            vc.dataArray = self.respone.data.products; self.navigationController.definesPresentationContext = YES;
            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            vc.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0];
            //self.toolVc = vc;
            [self.navigationController presentViewController:vc animated:YES completion:nil];
        }break;
        default:
            break;
    }
}
-(void)htmlScroll:(CGFloat)y{
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y+y) animated:NO];
}
-(void)commitSuc {
    
    
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.estimatedRowHeight = 245;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        HKCityTravelsTableViewCell *cell = [HKCityTravelsTableViewCell baseCellWithTableView:tableView];
        cell.respone =self.respone;
        return cell;
    }else{
        HKHtmlTableViewCell* cell = [HKHtmlTableViewCell baseCellWithTableView:tableView];
        cell.htmlStr = self.respone.data.note;
        cell.delegate = self;
        return cell;
    }
}
-(HKCItyTravelsNav *)navView{
    if (!_navView) {
        @weakify(self)
        _navView = [HKCItyTravelsNav cItyTravelsNavWIthBack:^{
            @strongify(self)
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _navView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
@end
