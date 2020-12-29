//
//  HKCommentInfoController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCommentInfoController.h"
#import "HKMyCircleViewModel.h"
#import "HKPostFieldView.h"
#import "HKPostCommitCell.h"
#import "HKPostPriseResonse.h"
#import "HKPostFieldView.h"
@interface HKCommentInfoController ()<UITableViewDelegate,UITableViewDataSource,CommentCellBtnDelegete,CommitBottomDelegete>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)HKPostCommentInfoResponse * response;
@property (nonatomic, strong)HKPostFieldView *fieldView;
@end
@implementation HKCommentInfoController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论回复详情";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.fieldView];
    [self loadInfoData];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,120) style:UITableViewStylePlain];
        _tableView.delegate =self;
        _tableView.dataSource  = self;
        _tableView.scrollEnabled =NO;
        _tableView.rowHeight =120;
        [_tableView registerClass:[HKPostCommitCell class] forCellReuseIdentifier:@"post"];
    }
    return _tableView;
}
-(HKPostFieldView *)fieldView {
    if (!_fieldView) {
        _fieldView =[[HKPostFieldView alloc] initWithFrame:CGRectMake(0,kScreenHeight-NavBarHeight-StatusBarHeight
                                                                      -40-SafeAreaBottomHeight,kScreenWidth,40)];
        _fieldView.delegete = self;
    }
    return _fieldView;
}
-(void)loadInfoData {
    [HKMyCircleViewModel getInfoPostCommentByCommentId:self.commentId success:^(HKPostCommentInfoResponse *responde) {
        if (responde.code ==0) {
            self.response = responde;
            
            [self.tableView reloadData];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKPostCommitCell * cell =[tableView dequeueReusableCellWithIdentifier:@"post" forIndexPath:indexPath];
    cell.dataModel = self.response.data;
    cell.delegete = self;
    return cell;
}
-(void)ClickCellWithSender:(UIButton *)sender andIndex:(NSInteger)index withModel:(HKCommentList *)model {
    switch (index) {
        case  10:
        {
            //点赞取消点赞
            NSString * prised = self.response.data.praiseState.intValue ? @"0":@"1";
            [HKMyCircleViewModel praiseCommentWithCommentId:self.commentId andstate:prised success:^(HKPostPriseResonse *responde) {
                if (responde.code==0) {
                    [sender setTitle:responde.data.praiseCount forState:UIControlStateNormal];
                    self.response.data.praiseState = prised.intValue ?@"1":@"0";
                    sender.selected =! sender.selected;
                }
            }];
        }
            break;
        case  20:
        {
            [self.fieldView becomeFirstRespond];
        }
            break;
    }
}
#pragma mark 发表评论
-(void)publishCommitWith:(NSString *)Content {
    [HKMyCircleViewModel postCommentWithPostId:self.postId andContent:Content withCommentId:self.commentId andReuserId:self.response.data.userId success:^(HKBaseResponeModel *responde) {
        if (responde.responeSuc) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [EasyShowTextView showText:@"发布评论失败"];
        }
    }];
}
@end
