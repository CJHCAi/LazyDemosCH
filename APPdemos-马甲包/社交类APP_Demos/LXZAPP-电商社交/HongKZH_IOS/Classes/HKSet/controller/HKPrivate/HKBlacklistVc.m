//
//  HKBlacklistVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBlacklistVc.h"
#import "HKSetTool.h"
#import "HKBlackListCell.h"
@interface HKBlacklistVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView * listTableView;
@property (nonatomic, strong)NSMutableArray * dataSources;
@property (nonatomic, assign)int page;


@end

@implementation HKBlacklistVc
-(NSMutableArray *)dataSources {
    if (!_dataSources) {
        _dataSources =[[NSMutableArray alloc] init];
    }
    return _dataSources;
}
-(UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight) style:UITableViewStylePlain];
        _listTableView.delegate  =self;
        _listTableView.dataSource = self;
        _listTableView.tableFooterView =[[UIView alloc] init];
        _listTableView.rowHeight = 70;
        _listTableView.showsVerticalScrollIndicator =NO;
        _listTableView.showsHorizontalScrollIndicator =NO;
        _listTableView.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
        [_listTableView registerClass:[HKBlackListCell class] forCellReuseIdentifier:@"BLACK"];
        _listTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [_listTableView.mj_footer setHidden: YES];
    }
    return _listTableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKBlackListCell * cell =[tableView dequeueReusableCellWithIdentifier:@"BLACK" forIndexPath:indexPath];
    cell.list = self.dataSources[indexPath.row];
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    HKBlackList * model  =[self.dataSources objectAtIndex:indexPath.row];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"您确定要删除吗"
                           cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
        }]
                           otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^{
            
            [HKSetTool removeBlackLikstWithFriendId:model.uid successBlock:^(id response) {
                [self.dataSources removeObjectAtIndex:indexPath.row];
                //再将此条cell从列表删除,_tableView为列表
                [self.listTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.listTableView reloadData];
                
            } fail:^(NSString *error) {
                 [EasyShowTextView showText:@"操作失败"];
            }];
        }], nil] show];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
}
-(void)loadMoreData {
    self.page ++;
    [self getBlackList];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"黑名单管理";
    self.showCustomerLeftItem = YES;
    self.page =1;
    [self.view addSubview:self.listTableView];
    [self getBlackList];
}
-(void)getBlackList {
    if (_page>1) {
        [self.listTableView.mj_footer setHidden:NO];
        //不移除数据
    }else {
        [self.listTableView.mj_footer setHidden:YES];
    }
    [HKSetTool getBlackListWithPage:self.page SuccessBlock:^(HKBlcakListResponse *response) {
        if (self.page==1) {
            if (self.dataSources.count) {
                [self.dataSources removeAllObjects];
            }
            [self.listTableView.mj_footer setHidden:NO];
        }
        if (response.data.list.count) {
            for (HKBlackList *model in response.data.list) {
                [self.dataSources addObject:model];
            }
            [self.listTableView.mj_footer endRefreshing];
        }
        else
        {
            [self.listTableView.mj_footer setHidden:YES];
            if (self.page!=1) {
                [EasyShowTextView showText:@"全部加载完毕"];
            }
        }
       [self.listTableView reloadData];
        
    } fail:^(NSString *error) {
        [EasyShowTextView showText:error];
    }];
}
@end
