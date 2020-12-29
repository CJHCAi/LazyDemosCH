//
//  HKMyPostManageViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/8.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyPostManageViewController.h"
#import "HKCategoryBarView.h"
#import "HKMyPostsViewController.h"
#import "HKMyRepliesPostsViewController.h"
#import "HKPostRecycleViewController.h"
@interface HKMyPostManageViewController ()
@property (nonatomic, strong)HKCategoryBarView *categoryView;
@end

@implementation HKMyPostManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"我的帖子";
    [self setUI];
}
-(void)setUI{
    [self.view addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    [self setrightBarButtonItemWithImageName:@"recruit_alldelege"];
}
-(void)rightBarButtonItemClick{
    HKPostRecycleViewController*vc = [[HKPostRecycleViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        HKMyPostsViewController *vc1 = [[HKMyPostsViewController alloc]init];
        HKMyRepliesPostsViewController*vc2 = [[HKMyRepliesPostsViewController alloc]init];
        [self.array_VC addObject:vc1];
        [self.array_VC addObject:vc2];
    }
    return self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(HKCategoryBarView *)categoryView{
    if (!_categoryView) {
           @weakify(self)
        _categoryView = [HKCategoryBarView categoryBarViewWithCategoryArray:@[@"主贴",@"回帖"] selectCategory:^(int index) {
            @strongify(self)
            [self btnClicks:index];
        }];
    }
    return _categoryView;
}

@end
