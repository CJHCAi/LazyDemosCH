//
//  HKPostDetailViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPostDetailViewController.h"
#import "HKMyCircleViewModel.h"
#import "HKPostDetailResponse.h"
#import "HKPostDetailHeadView.h"
#import "HKPostPriseResonse.h"
#import "HKCollageShareView.h"
#import "HKpostComentResponse.h"
#import "HKPostCommitCell.h"
#import "HKGroupMainerView.h"
#import "HKPostFieldView.h"
#import "HKMyFriendListViewModel.h"
#import "HKShareBaseModel.h"
#import "HKSubCommentDetailViewController.h"
#import "HKCommentInfoController.h"
@interface HKPostDetailViewController ()<UITableViewDelegate,UITableViewDataSource,PostHeadViewDelegete,CommitBottomDelegete,CommentCellBtnDelegete>
@property (nonatomic, strong)HKPostDetailResponse *response;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)HKPostDetailHeadView *headView;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, assign)NSInteger totalRow;
@property (nonatomic, strong)HKPostFieldView *fieldView;
@end
@implementation HKPostDetailViewController
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray =[[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(void)initNav {
     self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightBtnPressed) image:[UIImage imageNamed:@"buy_more"]];
}
#pragma  mark 群主操作类目..
-(void)rightBtnPressed {
    [HKGroupMainerView showGroupItemWithselectSheetBlock:nil postModel:self.response.data andController:self];
}
-(void)loadData {
    [HKMyCircleViewModel getPostDetailsWithId:self.postID success:^(HKPostDetailResponse *responde) {
        if (responde.code==0) {
            self.response =responde;
            [self.headView setHeadDataWithResponse:responde];
            self.headView.frame = CGRectMake(0,0,kScreenWidth,self.headView.headH);
            self.tableView.tableHeaderView =self.headView;
            [self.tableView reloadData];
        }
    }];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"帖子详情";
     self.page =1;
    [self initNav];
    [self setUI];
    [self loadData];
    [self loadCommentList];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.fieldView];
}
-(HKPostFieldView *)fieldView {
    if (!_fieldView) {
        _fieldView =[[HKPostFieldView alloc] initWithFrame:CGRectMake(0,kScreenHeight-NavBarHeight-StatusBarHeight
                                                                      -40-SafeAreaBottomHeight,kScreenWidth,40)];
        _fieldView.delegete = self;
    }
    return _fieldView;
}
-(void)loadCommentList {
    [HKMyCircleViewModel getCommentListPostId:self.postID andPage:self.page success:^(HKpostComentResponse *responde) {
        if (responde.code ==0) {
            if (self.page ==1) {
                [self.dataArray removeAllObjects];
            }
            self.totalRow = responde.data.totalRow;
            if (self.page == responde.data.totalPage || responde.data.totalPage == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_footer resetNoMoreData];
            }
            [self.dataArray addObjectsFromArray:responde.data.list];
            [self.tableView reloadData];
        }
    }];
}
-(void)setUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(kScreenHeight-NavBarHeight-StatusBarHeight
                                -40-SafeAreaBottomHeight);
    }];
}
-(HKPostDetailHeadView *)headView {
    if (!_headView) {
        _headView =[[HKPostDetailHeadView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,200)];
        _headView.delegete = self;
    }
    return _headView;
}
#pragma mark 发表评论
-(void)publishCommitWith:(NSString *)Content {
    [HKMyCircleViewModel postCommentWithPostId:self.response.data.postId andContent:Content withCommentId:nil andReuserId:nil success:^(HKBaseResponeModel *responde) {
        if (responde.responeSuc) {
            self.page = 1;
            [self loadCommentList];
        }else {
            [EasyShowTextView showText:@"发布评论失败"];
        }
    }];
}
#pragma mark 进入圈子
-(void)enterCicleVc {
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setClickBtnWithSender:(UIButton *)sender andTag:(NSInteger)tag {
    if (tag==20) {
        HKShareBaseModel*shareM =[[HKShareBaseModel alloc]init];
        HKMyPostModel *model =[[HKMyPostModel alloc] init];
        model.postId = self.response.data.postId;
        model.coverImgSrc =self.response.data.headImg;
        model.title =self.response.data.title;
        model.modelName  = self.response.data.categoryName;
        model.uid =self.response.data.uid;
        shareM.postModel =self.model;
        shareM.subVc = self;
        [HKCollageShareView showSelfBotomWithselectSheetBlock:nil shareModel:shareM];
    }else {
      //点赞 与取消..
        NSString * prised =  self.response.data.isPraise.intValue ? @"0":@"1";
        [HKMyCircleViewModel priseOrNotWithState:prised postId:self.response.data.postId success:^(HKPostPriseResonse *responde) {
            if (responde.code==0) {
                [sender setTitle:responde.data.praiseCount forState:UIControlStateNormal];
                self.response.data.isPraise  = prised.intValue ?@"1":@"0";
                sender.selected =! sender.selected;
            }
        }];
    }
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        //_tableView.estimatedRowHeight = 245;
        _tableView.rowHeight = 139;
        _tableView.tableHeaderView =self.headView;
        [_tableView registerClass:[HKPostCommitCell class] forCellReuseIdentifier:@"cm"];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.page++;
            [self  loadCommentList];
        }];
    }
    return _tableView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * head =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,50)];
    head.backgroundColor =[UIColor whiteColor];
    [AppUtils addSeparatorLine:head frame:CGRectMake(0,0,kScreenWidth,10) color:[UIColor colorFromHexString:@"f1f1f1"]];
    UILabel *totalCommit =[[UILabel alloc] initWithFrame:CGRectMake(16,10,kScreenWidth
                                                                    -32,40)];
    [AppUtils getConfigueLabel:totalCommit font:BoldFont14 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@""];
    [head addSubview:totalCommit];
    NSString *totalRow=[NSString stringWithFormat:@"(%zd)",self.totalRow];
    NSMutableAttributedString *att =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"全部评论%@",totalRow]];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"999999"] range:NSMakeRange(4,totalRow.length)];
    totalCommit.attributedText = att;
    [AppUtils addSeparatorLine:head frame:CGRectMake(0,49,kScreenWidth,1) color:[UIColor colorFromHexString:@"eeeeee"]];
    return head;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKPostCommitCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cm" forIndexPath:indexPath];
    cell.delegete = self;
    HKCommentList *list =self.dataArray[indexPath.row];
    cell.model = list;
    return cell;
}
-(void)ClickCellWithSender:(UIButton *)sender andIndex:(NSInteger)index withModel:(HKCommentList *)model {
    switch (index) {
        case  10:
        {
            //点赞取消点赞
           NSString * prised = model.praiseState.intValue ? @"0":@"1";
            [HKMyCircleViewModel praiseCommentWithCommentId:model.commentId andstate:prised success:^(HKPostPriseResonse *responde) {
                if (responde.code==0) {
                    [sender setTitle:responde.data.praiseCount forState:UIControlStateNormal];
                    model.praiseState = prised.intValue ?@"1":@"0";
                    sender.selected =! sender.selected;
                }
            }];
        }
            break;
       case  20:
        {
            //评论.
            HKCommentInfoController *infoVc =[[HKCommentInfoController alloc] init];
            infoVc.postId = self.postID;
            infoVc.commentId = model.commentId;
            [self.navigationController pushViewController:infoVc animated:YES];
        }
            break;
        case 30:
        {
            //举报..
            [SRActionSheet sr_showActionSheetViewWithTitle:@"" cancelButtonTitle:@"取消" destructiveButtonTitle:@"" otherButtonTitles:@[@"加入黑名单",@"举报该评论"] selectSheetBlock:^(SRActionSheet *actionSheetView, NSInteger index) {
                if (index ==0) {
                    [HKMyFriendListViewModel addFriendToBlackListWithUserId:model.userId success:^(id response) {
                        [EasyShowTextView showText:@"成功加入黑名单"];
                    } fial:^(NSString *error) {
                        [EasyShowTextView showText:error];
                    }];
                }else {
                   [HKMyFriendListViewModel addUserContentReportVc:self];
                }
            }];
        }
            break;
        case 40:
        {
            //查看更多评论..
            HKSubCommentDetailViewController * commentVc =[[HKSubCommentDetailViewController alloc] init];
            commentVc.list = model;
            [self.navigationController pushViewController:commentVc animated:YES];
        }
            break;
        default:
            break;
    }
}
-(void)pushUserDetailWithModel:(HKCommentList *)model {
    HKMyFollowAndFansList *list =[[HKMyFollowAndFansList alloc] init];
    list.headImg = model.headImg;
    list.uid = model.userId;
    list.name =model.uName;
    [AppUtils pushUserDetailInfoVcWithModel:list andCurrentVc:self];
}
@end
