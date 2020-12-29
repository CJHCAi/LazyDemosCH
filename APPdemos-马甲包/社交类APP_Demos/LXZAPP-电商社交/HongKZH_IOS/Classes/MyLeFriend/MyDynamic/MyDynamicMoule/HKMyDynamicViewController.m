//
//  HKMyDynamicViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyDynamicViewController.h"
#import "HKMyDyamicParameter.h"
#import "HKMyDyamicViewModel.h"
#import "HKMyDyamicRespone.h"
#import "HKMyDyamicModel.h"
#import "HKMydyamicDataModel.h"
#import "HKMyPostShareTableViewCell.h"
#import "HKMyEditPostTableViewCell.h"
#import "HKLeSearchAllViewController.h"
#import "HKMyDyamincHeadView.h"
#import "HKMyFriendListViewModel.h"
@interface HKMyDynamicViewController ()<UITableViewDelegate,UITableViewDataSource,HKMyDyamincHeadViewDelegate,HKMyPostBaseTableViewCellDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign) int pageNumber;
@property (nonatomic,assign) int type;

@property (nonatomic, strong)HKMyDyamicParameter *allData;
@property (nonatomic, strong)HKMyDyamicParameter *onlyFriend;
@property (nonatomic, strong)HKMyDyamicParameter *myDyamics;
@property (nonatomic, strong)HKMyDyamincHeadView *headView;
@end

@implementation HKMyDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.type = 1;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextData)];
    self.tableView.mj_footer.hidden = YES;
    [self loadNewData];
}
-(void)loadNewData{
    [SVProgressHUD showWithStatus:@"加载中"];
    HKMyDyamicParameter*dataModel = [self getDataArray];
    [dataModel.questionArray removeAllObjects];
     dataModel.pageNumber = 1;
    [self loadData];
}
-(void)loadNextData{
    HKMyDyamicParameter*dataModel = [self getDataArray];
    dataModel.pageNumber ++;
    [self loadData];
}
-(void)loadData{
    
    [HKMyDyamicViewModel getFriendDynamic:[self getDataArray] success:^(HKMyDyamicRespone *responde) {
         HKMyDyamicParameter*dataModel = [self getDataArray];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
        if (self.pageNumber==1) {
            [[[self getDataArray] questionArray] removeAllObjects];
        }
        if (responde.responeSuc) {
            [dataModel.questionArray addObjectsFromArray:responde.data.list];
            [self.tableView reloadData];
            if (responde.data.lastPage) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                 self.tableView.mj_footer.hidden = NO;
            }
        }else{
            if (dataModel.pageNumber>1) {
                dataModel.pageNumber --;
            }
        }
    }];
}

-(void)gotoSearch{
    HKLeSearchAllViewController *seachVc = [[HKLeSearchAllViewController alloc]init];
    [self.navigationController pushViewController:seachVc animated:YES];
}
-(HKMyDyamicParameter*)getDataArray{
    if (self.type == 1) {
        return self.allData;
    }else if (self.type ==2){
        return self.onlyFriend;
    }else {
        return  self.myDyamics;
    }
}
-(void)setUI{
    self.view.backgroundColor  =[UIColor colorFromHexString:@"#f5f5f5"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(kScreenHeight-NavBarHeight-StatusBarHeight-TabBarHeight-SafeAreaBottomHeight-40);
    }];
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
        _tableView.tableHeaderView = self.headView;
        _tableView.tableFooterView =[[UIView alloc] init];
        _tableView.backgroundColor =[UIColor colorFromHexString:@"#f5f5f5"];
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self getDataArray] questionArray] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKMydyamicDataModel*dataModel = [[self getDataArray] questionArray][indexPath.row];
    if (dataModel.type == 2) {
        HKMyPostShareTableViewCell *cell = [HKMyPostShareTableViewCell myPostBaseTableViewCellWithTableView:tableView];
        cell.delegate = self;
        cell.dataModel = dataModel;
        cell.indexPath = indexPath;
        
        return cell;
    }else{
        HKMyEditPostTableViewCell*cell = [HKMyEditPostTableViewCell myPostBaseTableViewCellWithTableView:tableView];
        cell.delegate = self;
        cell.dataModel = dataModel;
        cell.indexPath =indexPath;
        return cell;
    }
}
//弹出底部actionSheet
-(void)showActionSheetWithModel:(HKMyPostModel *)model andIndexPath:(NSIndexPath *)path{
    [SRActionSheet sr_showActionSheetViewWithTitle:@"" cancelButtonTitle:@"取消" destructiveButtonTitle:@"" otherButtonTitles:@[@"加入黑名单",@"举报该动态"] selectSheetBlock:^(SRActionSheet *actionSheetView, NSInteger index) {
        if (index ==0) {
            [self addUserToBlackListWithUid:model.uid];
        }else {
            [self ReportUser];
        }
    }];
}
#pragma mark 加入黑名单
-(void)addUserToBlackListWithUid:(NSString *)uid {
    
    [HKMyFriendListViewModel addFriendToBlackListWithUserId:uid success:^(id response) {
        [EasyShowTextView showText:@"成功加入黑名单"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addBlackList" object:nil];
        [AppUtils hanldeSuccessPopAfterSecond:1.5 WithCunrrentController:self];
        
    } fial:^(NSString *error) {
        [EasyShowTextView showText:error];
    }];
}
#pragma mark 举报
-(void)ReportUser {
    [HKMyFriendListViewModel addUserContentReportVc:self];
}
-(void)showUserDetailWithModel:(HKMyPostModel *)model {
    HKMyFollowAndFansList *list =[[HKMyFollowAndFansList alloc] init];
    list.headImg = model.headImg;
    list.uid = model.uid;
    list.name =model.uName;
    [AppUtils pushUserDetailInfoVcWithModel:list andCurrentVc:self];
}
#pragma mark 跳转到个人详情..
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
-(void)swichParamsWithSender:(NSInteger)tag {
    switch (tag ) {
        case 100:
            self.type = 1;
            break;
        case 200:
            self.type = 2;
            break;
        case 300:
            self.type = 3;
            break;
        default:
            break;
    }
    [self loadNewData];
}
-(HKMyDyamicParameter *)allData{
    if (!_allData) {
        _allData = [[HKMyDyamicParameter alloc]init];
        _allData.type = 1;
    }
    return _allData;
}
-(HKMyDyamicParameter *)onlyFriend{
    if (!_onlyFriend) {
        _onlyFriend = [[HKMyDyamicParameter alloc]init];
        _onlyFriend.type = 2;
    }
    return _onlyFriend;
}
-(HKMyDyamicParameter *)myDyamics {
    if (!_myDyamics) {
        _myDyamics =[[HKMyDyamicParameter alloc] init];
        _myDyamics.type = 3;
    }
    return _myDyamics;
}

-(HKMyDyamincHeadView *)headView{
    if (!_headView) {
        _headView = [[HKMyDyamincHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 97)];
        _headView.delegate = self;
    }
    return _headView;
}
@end
