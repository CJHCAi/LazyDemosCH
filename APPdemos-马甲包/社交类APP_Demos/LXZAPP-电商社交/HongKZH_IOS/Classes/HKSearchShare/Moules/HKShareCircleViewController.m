//
//  HKShareCircleViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKShareCircleViewController.h"
#import "HKCircleLishTableViewCell.h"
#import "HKFriendViewModel.h"
#import "HKCliceListRespondeModel.h"
#import "ShareMessage.h"
#import "HKShareBaseModel.h"
#import "HKEditSharePostViewController.h"
@interface HKShareCircleViewController ()<UITableViewDelegate,UITableViewDataSource,HKEditSharePostViewControllerDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *shopsNew;
@property (nonatomic, strong)HKCliceListRespondeModel *responde;
@end

@implementation HKShareCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self addReRequest];
    // Do any additional setup after loading the view.
}
-(void)setUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)addReRequest{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:HKUSERLOGINID forKey:@"loginUid"];
    [HKFriendViewModel loadClicleList:dic success:^(HKCliceListRespondeModel *responde) {
        if (responde.responeSuc) {
            self.responde = responde;
            [self.tableView reloadData];
        }
    }];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // There is only one section.
    return self.responde.data.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of time zone names.
    HKCliceListData*listM = self.responde.data[section];
        
    return listM.list.count;
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HKCircleLishTableViewCell *cell = [HKCircleLishTableViewCell circleLishTableViewCellWithTableView:tableView];
    HKCliceListData*listM = self.responde.data[indexPath.section];
    
    cell.model = listM.list[indexPath.row];
   
    
    
    
    return cell;
}
-(void)gotoBack{
    if ([self.delegate respondsToSelector:@selector(backVc)]) {
        [self.delegate backVc];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HKCliceListData*model = self.responde.data[indexPath.section];
    HKClicleListModel*item = model.list[indexPath.row];
    if (self.sharModel.shareType == SHARE_Type_POST) {
        HKEditSharePostViewController*vc = [[HKEditSharePostViewController alloc]init];
        vc.circleId = item.circleId;
        vc.postM = self.sharModel.postModel;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];

        return;
    }
    [[RCIM sharedRCIM]sendMessage:ConversationType_GROUP targetId:item.circleId content:self.sharModel.message pushContent:self.sharModel.message.msgText pushData:@"分享" success:^(long messageId) {
        DLog(@"d");
        [SVProgressHUD showSuccessWithStatus:@"分享成功"];
        if ([self.delegate respondsToSelector:@selector(backVc)]) {
            [self.delegate backVc];
        }
    } error:^(RCErrorCode nErrorCode, long messageId) {
        [SVProgressHUD showErrorWithStatus:@"分享失败"];
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSMutableArray *)shopsNew
{
    if(_shopsNew == nil)
    {
        _shopsNew = [ NSMutableArray array];
    }
    return _shopsNew;
}
-(void)setSharModel:(HKShareBaseModel *)sharModel{
    _sharModel = sharModel;
    self.title = @"分享到圈子";
}
@end
