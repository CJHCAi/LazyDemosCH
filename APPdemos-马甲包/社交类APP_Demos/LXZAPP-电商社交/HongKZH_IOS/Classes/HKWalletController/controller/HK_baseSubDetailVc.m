//
//  HK_baseSubDetailVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_baseSubDetailVc.h"
#import "HK_tradeCell.h"
#import "HK_BaseRequest.h"
@interface HK_baseSubDetailVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView * listTableView;
@property (nonatomic, strong)NSMutableArray * dataSources;
@property (nonatomic, assign)int page;
@end

@implementation HK_baseSubDetailVc

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.page =1;
    [self.view addSubview:self.listTableView];
    [self loadOrderListInfo];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataSources.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HK_tradeCell * cell =[tableView dequeueReusableCellWithIdentifier:@"tradeCell" forIndexPath:indexPath];
    OrderList * mdoel =[self.dataSources objectAtIndex:indexPath.row];
    [cell configueDataWithModel:mdoel];
    return cell;
}
-(UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight*2-45-49-16) style:UITableViewStylePlain];
        _listTableView.delegate  =self;
        _listTableView.dataSource = self;
        _listTableView.tableFooterView =[[UIView alloc] init];
        _listTableView.rowHeight = 70;
        _listTableView.showsVerticalScrollIndicator =NO;
        _listTableView.showsHorizontalScrollIndicator =NO;
        _listTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _listTableView.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
        [_listTableView registerNib:[UINib nibWithNibName:@"HK_tradeCell" bundle:nil] forCellReuseIdentifier:@"tradeCell"];
        UIView *headerView =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,10)];
        headerView.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
        _listTableView.tableHeaderView = headerView;
        //        //加上拉刷新下拉加载
                //下拉刷新
                _listTableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
                //    //上拉加载
                _listTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
                [_listTableView.mj_footer setHidden: YES];
        
    }
    return _listTableView;
}

-(void)loadOrderListInfo {
    
    if (_page>1) {
        [self.listTableView.mj_footer setHidden:NO];
        //不移除数据
    }else {
        [self.listTableView.mj_footer setHidden:YES];
    }
    NSMutableDictionary *params =[[NSMutableDictionary alloc] init];
    [params setValue:LOGIN_UID forKey:@"loginUid"];
    [params setValue:@(self.page) forKey:@"pageNumber"];
    [params setValue:[NSString stringWithFormat:@"%u",self.status] forKey:@"state"];
    [HK_BaseRequest buildPostRequest:get_sellSellerorderFlow body:params success:^(id  _Nullable responseObject) {
        [self.listTableView.mj_header endRefreshing];
        NSInteger code =[responseObject[@"code"] integerValue];
        if (code) {
            NSString *mes =responseObject[@"msg"];
            if (mes.length) {
                [EasyShowTextView showText:mes];
            }
        }else {
            if (self.page==1) {
                if (self.dataSources.count) {
                    [self.dataSources removeAllObjects];
                }
                [self.listTableView.mj_footer setHidden:NO];
            }
            HK_orderListModel * bigModel =[HK_orderListModel mj_objectWithKeyValues:responseObject];
            if (bigModel.data.list.count) {
                [self.dataSources addObjectsFromArray:bigModel.data.list];
                [self.listTableView.mj_footer endRefreshing];
                [self.listTableView reloadData];
            }
            
            else
            {
                [self.listTableView.mj_footer setHidden:YES];
                [self.listTableView.mj_footer endRefreshing];
                [EasyShowTextView showText:@"全部加载完毕"];
            }
        }
    } failure:^(NSError * _Nullable error) {
        [self.listTableView.mj_header endRefreshing];
        [self.listTableView.mj_footer endRefreshing];
        [EasyShowTextView showText:@"无网络,稍后重试"];
    }];
    
}
-(void)loadNewData {
    self.page =1;
    [self loadOrderListInfo];
}
-(void)loadMoreData {
    self.page++;
    [self loadOrderListInfo];
}
-(NSMutableArray *)dataSources {
    if (!_dataSources) {
        _dataSources =[[NSMutableArray alloc] init];
    }
    return _dataSources;
}

@end
