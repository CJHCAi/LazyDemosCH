//
//  HKPostRecycleViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/8.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPostRecycleViewController.h"
#import "HKCategoryBarView.h"
#import "HKDelPostViewController.h"
@interface HKPostRecycleViewController ()
@property (nonatomic, strong)HKCategoryBarView *categoryView;
@end

@implementation HKPostRecycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    // Do any additional setup after loading the view.
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        HKDelPostViewController*vc1 = [[HKDelPostViewController alloc]init];
        vc1.type = 3;
         HKDelPostViewController*vc2 = [[HKDelPostViewController alloc]init];
        vc2.type = 2;
        HKDelPostViewController*vc3 = [[HKDelPostViewController alloc]init];
        vc3.type = 1;
        [self.array_VC addObject:vc1];
        [self.array_VC addObject:vc2];
        [self.array_VC addObject:vc3];
    }
    return self;
}
-(void)setUI{
    self.title = @"帖子回收站";
    [self.view addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
}
-(HKCategoryBarView *)categoryView{
    if (!_categoryView) {
           @weakify(self)
        _categoryView = [HKCategoryBarView categoryBarViewWithCategoryArray:@[@"系统删帖",@"圈住删帖",@"自己删帖"] selectCategory:^(int index) {
            @strongify(self)
            [self btnClicks:index];
        }];
    }
    return _categoryView;
}

@end
