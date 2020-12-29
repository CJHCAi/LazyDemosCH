//
//  HKLeFriendManagerViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLeFriendManagerViewController.h"
#import "HKCategoryBarView.h"
#import "HK_GladlyFriendNewsView.h"
#import "HKMycircleListViewController.h"
#import "HKMyDynamicViewController.h"
#import "HKMyFriendListViewController.h"
#import "HKAddFriendViewController.h"
@interface HKLeFriendManagerViewController ()
@property (nonatomic, strong)HKCategoryBarView *categoryView;
@end

@implementation HKLeFriendManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      [self setUI];
    [self addNotification];
}
-(void)cancelNewUser {
    [super cancelNewUser];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)setUI{
    self.title = @"乐友";
    self.navigationItem.leftBarButtonItem = nil;
    [self setrightBarButtonItemWithImageName:@"newFriend"];
    [self.view addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
}
-(void)rightBarButtonItemClick{
    HKAddFriendViewController*addVc = [[HKAddFriendViewController alloc]init];
    [self.navigationController pushViewController:addVc animated:YES];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        HK_GladlyFriendNewsView*vc1 = [[HK_GladlyFriendNewsView alloc]init];
        HKMyFriendListViewController*vc2 = [[HKMyFriendListViewController alloc]init];
        HKMycircleListViewController*vc3 = [[HKMycircleListViewController alloc]init];
        HKMyDynamicViewController*vc4 = [[HKMyDynamicViewController alloc]init];
        [self.array_VC addObject:vc1];
        [self.array_VC addObject:vc2];
        [self.array_VC addObject:vc4];
    }
    return self;
}
-(HKCategoryBarView *)categoryView{
    if (!_categoryView) {
        @weakify(self)
        HKCategoryBarView *extractedExpr = [HKCategoryBarView categoryBarViewWithCategoryArray:@[@"消息",@"好友",@"动态"] selectCategory:^(int index) {
            @strongify(self)
            [self btnClicks:index];
        }];
        _categoryView = extractedExpr;
    }
    return _categoryView;
}

@end
