//
//  HKhisToryController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKhisToryController.h"
#import "HK_VideoConfogueTool.h"
#import "HKCorporateAdvertisingInfoViewController.h"
#import "SelfMediaRespone.h"
#import "HKSelfMeidaVodeoViewController.h"
@interface HKhisToryController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray * lists;
@property (nonatomic, assign)NSInteger page;

@end

@implementation HKhisToryController

-(NSMutableArray *)lists {
    if (!_lists) {
        _lists =[[NSMutableArray alloc] init];
    }
    return _lists;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight) style:UITableViewStylePlain];
        _tableView.delegate  = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView =[[UIView alloc] init];
        _tableView.rowHeight =125;
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKHisToryVideoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKHisToryVideoCell class])];
        
//        @weakify(self);
        // 上拉刷新
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            @strongify(self);
            self.page++;
            [self loadData];
        }];
        _tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page=1;
            [self loadData];
        }];
    }
    return _tableView;
}

//#pragma mark Nav 设置
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [AppUtils setPopHidenNavBarForFirstPageVc:self];
//}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title =@"历史观看";
    self.page = 1;
    self.showCustomerLeftItem =YES;
    [self.view addSubview:self.tableView];
    [self loadData];
    
}
-(void)loadData {
    //获取历史记录..
    [HK_VideoConfogueTool getUserVideoHistoryListByPage:self.page successBlock:^(HK_VideoHReSponse *response) {
        [self.tableView.mj_header endRefreshing];
        if (self.page == 1) {
            [self.lists removeAllObjects];
        }
        HK_VideosData *data =response.data;
        if (self.page == data.totalPage || data.totalPage == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        [self.lists addObjectsFromArray:data.list];
        [self.tableView reloadData];
    } fial:^(NSString *fials) {
        [EasyShowTextView showText:fials];
        //登录信息失效清除loginUid
        [LoginUserDataModel clearUserInfo];
    }];
                                    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  self.lists.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKHisToryVideoCell * cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKHisToryVideoCell class]) forIndexPath:indexPath];
    HK_DataVideoList *list =self.lists[indexPath.row];
    cell.list = list;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//播放...
    HK_DataVideoList *list =self.lists[indexPath.row];

    [self gotoVideo:list.ID antType:[NSString stringWithFormat:@"%@",list.type] coverImgSrc:list.coverImgSrc indexPath:indexPath];
}

-(void)gotoVideo:(NSString*)ID antType:(NSString*)type coverImgSrc:(NSString*)coverImgSrc indexPath:(NSIndexPath*)indexPath{
    //1自媒体 2企业广告3城市广告4传统文化
    if (type.intValue == 1) {
        
        NSMutableArray*array = [NSMutableArray arrayWithCapacity:self.lists.count];
        HK_DataVideoList*listD = self.lists[indexPath.item];
        SelfMediaModelList*listM = [SelfMediaModelList mj_objectWithKeyValues:[listD mj_keyValues]];
        [array addObject:listM];
        HKSelfMeidaVodeoViewController*vc = [[HKSelfMeidaVodeoViewController alloc]init];
        vc.dataArray = array;
        vc.selectRow = 0;
        vc.sourceType =@"2";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type.intValue == 2){
        HKCorporateAdvertisingInfoViewController*vc = [[HKCorporateAdvertisingInfoViewController alloc]init];
        vc.ID = ID;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type.intValue == 3){
        SelfMediaModelList*listM = [[SelfMediaModelList alloc]init];
        listM.title = @"";
        listM.coverImgSrc = coverImgSrc;
        //    listM.
        listM.praiseCount = @"";
        listM.rewardCount = @"";
        listM.isCity = YES;
        listM.ID = ID;
        HKSelfMeidaVodeoViewController*vc = [[HKSelfMeidaVodeoViewController alloc]init];
        vc.dataArray = [NSMutableArray arrayWithObject:listM];
        vc.selectRow = 0;
        vc.sourceType =@"2";
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    HK_DataVideoList  * model  =[self.lists objectAtIndex:indexPath.row];
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"您确定要删除吗"
                           cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
        }]
                           otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^{
            
            [HK_VideoConfogueTool deleteUSerWatchHistoryByVideoID:model.ID successBlock:^(id response) {
                [self.lists removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView reloadData];
                
            } fial:^(NSString *fials) {
                [EasyShowTextView showText:fials];
            }];
        
        }], nil] show];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
     
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
}
@end
