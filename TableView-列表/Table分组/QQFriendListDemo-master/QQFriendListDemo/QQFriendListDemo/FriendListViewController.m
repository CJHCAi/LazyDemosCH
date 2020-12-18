//
//  FriendListViewController.m
//  核心动画
//
//  Created by 朱伟阁 on 2019/1/25.
//  Copyright © 2019 朱伟阁. All rights reserved.
//

#import "FriendListViewController.h"
#import "GroupModel.h"
#import "FriendModel.h"
#import "FriendTableViewCell.h"
#import "CustomHeadFooterView.h"

@interface FriendListViewController ()<UITableViewDataSource,UITableViewDelegate,CustomHeadFooterViewDelegate>

@property(nonatomic, strong) UITableView *tv;
@property(nonatomic, strong) NSArray *groups;

@end

@implementation FriendListViewController

-(UITableView *)tv{
    if(!_tv){
        _tv = [[UITableView alloc]initWithFrame:CGRectMake(0, State_Bar_H, SCREENWIDTH, SCREENHEIGHT-State_Bar_H-SafeAreaBottom_H) style:UITableViewStylePlain];
        _tv.dataSource = self;
        _tv.delegate = self;
        _tv.showsVerticalScrollIndicator = NO;
        _tv.sectionHeaderHeight = 44;
    }
    return _tv;
}

-(NSArray *)groups{
    if(_groups==nil){
        NSString *path = [[NSBundle mainBundle]pathForResource:@"friends" ofType:@"plist"];
        NSArray *arrayDicts = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *arrayModels = [NSMutableArray array];
        for (NSDictionary *dict in arrayDicts) {
//            GroupModel *group = [GroupModel groupWithDict:dict];
//            [arrayModels addObject:group];
            GroupModel *group = [GroupModel mj_objectWithKeyValues:dict];
            [arrayModels addObject:group];
        }
        _groups = [arrayModels copy];
    }
    return _groups;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    GroupModel *group = self.groups[section];
    if (group.visible) {
        return group.friends.count;
    }else{
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupModel *group = self.groups[indexPath.section];
    FriendModel *friend = group.friends[indexPath.row];
    FriendTableViewCell *cell = [FriendTableViewCell friendTableViewCellWithTableView:tableView];
    cell.friendModel = friend;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    GroupModel *group = self.groups[section];
    CustomHeadFooterView *view = [CustomHeadFooterView headFooterViewWithTableview:tableView];
    view.delegate = self;
    view.group = group;
    view.tag = section;
    //return 返回之前headerFooterView的frame是0,所以需要在某个地方设置headerFooterView的frame
    return view;
    //return 返回之后，uitableview在用headerFooterView的时候就会设置headerFooterView的frame
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"QQ好友列表";
    [self.view addSubview:self.tv];
}

- (void)groupHeaderViewDidClickTitleButton:(CustomHeadFooterView *)headerview{
    //全局刷新
//    [self.tv reloadData];
    //局部刷新
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:headerview.tag];
    [self.tv reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

@end
