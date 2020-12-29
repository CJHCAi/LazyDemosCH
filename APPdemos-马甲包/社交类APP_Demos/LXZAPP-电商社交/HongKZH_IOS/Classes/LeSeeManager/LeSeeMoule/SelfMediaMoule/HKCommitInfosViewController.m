//
//  HKCommitInfosViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCommitInfosViewController.h"
#import "HKToolCommtiTableViewCell.h"
#import "HKLeSeeViewModel.h"
#import "MediaAdvCommentReplyListRespone.h"
#import "HKReplysTableViewCell.h"
#import "HKCommitSelfMeadioTool.h"
#import "HKLeSeeViewModel.h"
@interface HKCommitInfosViewController ()<UITableViewDelegate,UITableViewDataSource,HKCommitSelfMeadioToolDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign) int pageNum;
@property (nonatomic, strong)NSMutableArray *questionArray;
@property (nonatomic, strong)HKCommitSelfMeadioTool *commitTool;
@end

@implementation HKCommitInfosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"评论详情";
    [self setUI];
    self.pageNum = 1;
    [self loadData];
    [self.view addSubview:self.commitTool];
    [self.commitTool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
   
}

-(void)loadData{
    [HKLeSeeViewModel getMediaAdvCommentReplyListRespone:@{@"commentId":self.model.commentId.length>0?self.model.commentId:@"",@"loginUid":HKUSERLOGINID,@"pageNumber":@(self.pageNum)} success:^(MediaAdvCommentReplyListRespone *responde) {
        if (responde.responeSuc) {
            if (self.pageNum==1) {
                [self.questionArray removeAllObjects];
            }
            [self.questionArray addObjectsFromArray:responde.data.list];
            [self.tableView reloadData];
        }
    }];
}
-(void)setUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-50);
    }];
}
-(HKCommitSelfMeadioTool *)commitTool{
    if (!_commitTool) {
        _commitTool = [[HKCommitSelfMeadioTool alloc]initWithFrame:CGRectZero];
        _commitTool.hidden = NO;
        _commitTool.delegate = self;
    }
    return _commitTool;
}
-(void)commitWithText:(NSString *)text {
    NSString *ID;
    if (self.cityResponse) {
        ID = self.cityResponse.data.cityAdvId;
    }else {
        ID =self.responde.data.ID;
    }
    [HKLeSeeViewModel advComment:@{@"loginUid":HKUSERLOGINID,@"content":text,@"id":ID,@"commentId":self.model.commentId} success:^(HKBaseResponeModel *responde) {
        if (responde.responeSuc) {
            [self.view endEditing:YES];
            self.pageNum =1;
            [self loadData];
            self.responde.data.commentCount = [NSString stringWithFormat:@"%ld",self.responde.data.commentCount.integerValue+1];
            [SVProgressHUD showSuccessWithStatus:@"评论成功"];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"评论失败"];
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
        _tableView.estimatedRowHeight = 245;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.questionArray.count;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HKToolCommtiTableViewCell*cell = [HKToolCommtiTableViewCell baseCellWithTableView:tableView];
        cell.model = self.model;
        cell.type = 1;
        return cell;
    }else{
        HKReplysTableViewCell*cell = [HKReplysTableViewCell baseCellWithTableView:tableView];
        cell.model = self.questionArray[indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
- (NSMutableArray *)questionArray
{
    if(_questionArray == nil)
    {
        _questionArray = [ NSMutableArray array];
    }
    return _questionArray;
}
@end
