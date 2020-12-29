//
//  HKSearchMessageViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSearchMessageViewController.h"
#import "HKSearchTypeTableViewCell.h"
#import "BackSearchNabarView.h"
#import "HKSearchMessageInfoViewController.h"
@interface HKSearchMessageViewController ()<UITableViewDelegate,UITableViewDataSource,BackSearchNabarViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)BackSearchNabarView *nabarView;
@end

@implementation HKSearchMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.nabarView];
    [self.nabarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_offset(64);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.nabarView.mas_bottom);
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
-(void)textChangeWithText:(NSString *)textStr{
    _searchText = textStr;
   NSArray *messsageResult = [[RCIMClient sharedRCIMClient]searchConversations:@[ @(ConversationType_GROUP), @(ConversationType_PRIVATE) ]messageType:@[[RCTextMessage getObjectName], [RCRichContentMessage getObjectName], [RCFileMessage getObjectName]   ]keyword:textStr];
    self.dataArray = [NSMutableArray arrayWithArray:messsageResult];
    
    [self.tableView reloadData];
}
-(void)cancleClick{
    [self back];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKSearchTypeTableViewCell *cell = [HKSearchTypeTableViewCell searchTypeCellWithTableView:tableView];
    [cell setModelWithType:1 andModel:self.dataArray[indexPath.row]];
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]init];
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    [view addSubview:label];
    UIView*lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    [view addSubview:lineView];
    view.backgroundColor = [UIColor whiteColor];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.centerY.equalTo(view);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.right.bottom.equalTo(view);
        make.height.mas_equalTo(1);
    }];
        label.text = @"消息";
  
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 35;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RCSearchConversationResult*model = self.dataArray[indexPath.row];
//    HKSearchMessageInfoModel *messageM = [[HKSearchMessageInfoModel alloc]init];
//    messageM.rcModel = model;
//    messageM.count = 50;
//    messageM.searchText = self.searchText;
//    HKSearchMessageInfoViewController*vc = [[HKSearchMessageInfoViewController alloc]init];
//    vc.model = messageM;
//    [self.navigationController pushViewController:vc animated:YES];
    
    //进入聊天界面.
    HK_CladlyChattesView *chat = [[HK_CladlyChattesView alloc] init];
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chat.conversationType = model.conversation.conversationType;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chat.targetId = model.conversation.targetId;
    //设置聊天会话界面要显示的标题
    if (model.conversation.conversationTitle.length) {
        chat.title = model.conversation.conversationTitle;
        
    }else {
        chat.title =@"消息";
    }
    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (BackSearchNabarView *)nabarView
{
    if(_nabarView == nil)
    {
        _nabarView = [[ BackSearchNabarView alloc]init];
        _nabarView.delegate = self;
    }
    return _nabarView;
}
-(void)setSearchText:(NSString *)searchText{
    _searchText = searchText;
    self.nabarView.searchText = searchText;
}
@end
