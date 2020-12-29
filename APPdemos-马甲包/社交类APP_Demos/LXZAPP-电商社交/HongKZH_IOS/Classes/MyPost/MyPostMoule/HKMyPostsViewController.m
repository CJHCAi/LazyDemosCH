//
//  HKMyPostsViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/7.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyPostsViewController.h"
#import "HKMyPostsRespone.h"
#import "HKMyPostViewModel.h"
#import "HKMyPostBaseTableViewCell.h"
#import "HKShareFriendViewController.h"
#import "HKCollageShareView.h"
#import "HKShareBaseModel.h"
#import "HKLeSeeViewModel.h"
@interface HKMyPostsViewController ()<UITableViewDelegate,UITableViewDataSource,HKMyPostBaseTableViewCellDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *questionArray;
@property(nonatomic, assign) int pageNum;
@end

@implementation HKMyPostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNum = 1;
    self.title =@"我的帖子";
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextData)];
    self.tableView.mj_footer.hidden = YES;
    [self setUI];
    [self loadData];
}
-(void)loadData{
    [HKMyPostViewModel myPosts:@{@"loginUid":HKUSERLOGINID,@"pageNumber":@(self.pageNum)} success:^(HKMyPostsRespone *responde) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (responde.responeSuc) {
            if (responde.data.lastPage) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
            }
            [self.questionArray addObjectsFromArray:responde.data.list];
            [self.tableView reloadData];
        }else{
            if (self.pageNum >1) {
                self.pageNum --;
            }
        }
    }];
}
-(void)loadNewData{
    self.pageNum = 1;
    [self.questionArray removeAllObjects];
    [self loadData];
}
-(void)loadNextData{
    self.pageNum++;
    [self loadData];
}
-(void)setUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}
-(void)shareWithModel:(HKMyPostModel *)model{
    HKShareBaseModel*shareModel = [[HKShareBaseModel alloc]init];
    shareModel.postModel = model;
    shareModel.subVc = self;
    [HKCollageShareView showSelfBotomWithselectSheetBlock:nil shareModel:shareModel];
}
-(void)commitWithModel:(HKMyPostModel *)model{
    
}
-(void)praiseWithModel:(HKMyPostModel *)model{
//    NSString*state = @"1";
//    if (model.isPraise) {
//        state = @"1";
//    }
//    [HKLeSeeViewModel praise:@{@"loginUid":HKUSERLOGINID,@"postId":model.postId,@"state":state} type:2 success:^(HKBaseResponeModel *responde) {
//
//    }];
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
    return self.questionArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKMyPostModel*model = self.questionArray[indexPath.row];
    HKMyPostBaseTableViewCell *cell = [HKMyPostViewModel tableView:tableView cellForRowAtIndexPath:indexPath model:model];
    cell.delegate = self;
    cell.model = model;
    cell.indexPath =indexPath;
    return cell;
}
//删除帖子...
-(void)showActionSheetWithModel:(HKMyPostModel *)model andIndexPath:(NSIndexPath *)path{
    [SRActionSheet sr_showActionSheetViewWithTitle:@"您确定要删除该帖子吗?" cancelButtonTitle:@"取消" destructiveButtonTitle:@"" otherButtonTitles:@[@"删除"] selectSheetBlock:^(SRActionSheet *actionSheetView, NSInteger index) {
        
        [self  deletePostWithModel:model withIndexPath:path];
        
    }];
}
-(void)deletePostWithModel:(HKMyPostModel *)model withIndexPath:(NSIndexPath *)indexPath{
    [Toast loading];
    [HKMyPostViewModel deletePostWithPostId:model.postId andType:model.type success:^(HKBaseResponeModel *responde) {
        [Toast loaded];
        
        if (responde.responeSuc) {
            [self.questionArray removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView reloadData];
        }else {
            [EasyShowTextView showText:@"操作失败"];
        }
    }];
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
