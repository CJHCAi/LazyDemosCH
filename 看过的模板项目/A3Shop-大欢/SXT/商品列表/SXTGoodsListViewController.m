//
//  SXTGoodsListViewController.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/24.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTGoodsListViewController.h"
#import "SXTGoodsListTopButtonView.h"//顶部四个按钮的view

@interface SXTGoodsListViewController()

@property (strong, nonatomic)   SXTGoodsListTopButtonView *fourBtnView;              /** 四个按钮 */

@end

@implementation SXTGoodsListViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.edgesForExtendedLayout = 0;
    [self.view addSubview:self.fourBtnView];
}

- (SXTGoodsListTopButtonView *)fourBtnView{
    if (!_fourBtnView) {
        _fourBtnView = [[SXTGoodsListTopButtonView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 30)];
    }
    return _fourBtnView;
}

@end
