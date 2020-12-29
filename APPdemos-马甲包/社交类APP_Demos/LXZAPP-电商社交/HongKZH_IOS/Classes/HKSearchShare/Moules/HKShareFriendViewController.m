//
//  HKShareFriendViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKShareFriendViewController.h"
#import "HKShareBaseModel.h"
#import "ShareMessage.h"
#import "HKFriendRespond.h"
#import "HKFriendViewModel.h"
#import "HKMyFriendTableViewCell.h"
@interface HKShareFriendViewController ()<UITableViewDelegate,UITableViewDataSource,PushUserBaseInfoDelegete>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *shopsNew;
@property (nonatomic, strong)HKFriendRespond *respone;
@end

@implementation HKShareFriendViewController

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
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.respone.data.count == 0) {
        return nil;
    }
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    UILabel*label = [[UILabel alloc]init];
    label.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    label.font = [UIFont systemFontOfSize:12];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.centerX.equalTo(view);
    }];
    HKFriendListModel*listData = self.respone.data[section];
    label.text = listData.name;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

        return 18;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if( self.respone.data.count >0 )
    {
        return self.respone.data.count;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of time zone names.
 
    if (self.respone.data == nil||self.respone.data.count == 0) {
        return 0;
    }
    return [[self.respone.data[section]list]count];
    
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKMyFriendTableViewCell*cell = [HKMyFriendTableViewCell myFriendTableViewCellWithTableView:tableView];
    cell.delegete = self;
    HKFriendListModel*friendData = self.respone.data[indexPath.section];
    cell.friendM = friendData.list[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     HKFriendListModel *model = self.respone.data[indexPath.section];
    HKFriendModel*item = model.list[indexPath.row];
    
    [[RCIM sharedRCIM]sendMessage:ConversationType_PRIVATE targetId:item.uid content:self.sharModel.message pushContent:self.sharModel.message.msgText pushData:@"分享" success:^(long messageId) {
        [SVProgressHUD showSuccessWithStatus:@"分享成功"];
        if ([self.delegate respondsToSelector:@selector(backVc)]) {
            [self.delegate backVc];
        }
    } error:^(RCErrorCode nErrorCode, long messageId) {
        if (nErrorCode ==RC_CHANNEL_INVALID) {
            [SVProgressHUD showErrorWithStatus:@"当前连接不可用"];
        }else {
            [SVProgressHUD showErrorWithStatus:@"分享失败"];
        }
    }];
    
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)addReRequest
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:HKUSERLOGINID forKey:@"loginUid"];
    [HKFriendViewModel loadFriendList:dic success:^(HKFriendRespond *responde) {
        if (responde.responeSuc) {
            self.respone = responde;
            [self.tableView reloadData];
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setSharModel:(HKShareBaseModel *)sharModel{
    _sharModel = sharModel;
    self.title = @"分享到好友";
    
}
@end
