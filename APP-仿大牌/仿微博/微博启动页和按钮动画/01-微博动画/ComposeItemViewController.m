//
//  ComposeItemViewController.m
//  01-微博动画
//
//  Created by xiaomage on 15/6/26.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "ComposeItemViewController.h"
#import "MenuItem.h"
#import "MenuItemButton.h"
@interface ComposeItemViewController ()


@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int btnIndex;
@property (nonatomic, strong) NSMutableArray *itemButtons;

@end

@implementation ComposeItemViewController

- (NSMutableArray *)itemButtons
{
    if (_itemButtons == nil) {
        _itemButtons = [NSMutableArray array];
    }
    return _itemButtons;
}
/*
 按钮按顺序的从下往上偏移
 
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 添加所有item按钮
    [self setUpAllBtns];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    
}

- (void)timeChange
{
    // 让一个按钮做动画
    
    if (_btnIndex == self.itemButtons.count) {
        // 定时器停止
        [_timer invalidate];
        
        return;
    }
    
    // 获取按钮
    UIButton *btn = self.itemButtons[_btnIndex];
    
    [self setUpOneBtnAnim:btn];
    
    _btnIndex++;
    
    
}
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    // 做按钮的动画
//    [self setUpAllBtnAnim];
//
//}



#pragma mark - 给所有的按钮做动画
- (void)setUpAllBtnAnim
{
    for (UIButton *btn in self.itemButtons) {
        
        [self setUpOneBtnAnim:btn];
        
    }
}
#pragma mark - 给一个按钮做动画
- (void)setUpOneBtnAnim:(UIButton *)btn
{
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        btn.transform = CGAffineTransformIdentity;
    } completion:nil];
    
}

#pragma mark - 添加所有item按钮
- (void)setUpAllBtns
{
    int cols = 3;
    int col = 0;
    int row = 0;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat wh = 100;
    CGFloat margin = ([UIScreen mainScreen].bounds.size.width - cols * wh) / (cols + 1);
    CGFloat oriY = 300;
    
    int count = (int)_items.count;
    for (int i = 0; i < count; i++) {
        UIButton *btn = [MenuItemButton buttonWithType:UIButtonTypeCustom];
        
        col = i % cols;
        row = i / cols;
        
        x = margin + col * (margin + wh);
        y = row * (margin + wh) + oriY;
        
        
        btn.frame = CGRectMake(x, y, wh, wh);
        
        // 设置按钮的图片和文字
        MenuItem *item = _items[i];
        
        [btn setImage:item.image forState:UIControlStateNormal];
        [btn setTitle:item.title forState:UIControlStateNormal];
        
        // 偏移到底部
        btn.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height);
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(btnClick1:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.itemButtons addObject:btn];
        
        [self.view addSubview:btn];
        
    }
}
- (void)btnClick1:(UIButton *)btn
{
    [UIView animateWithDuration:1 animations:^{
        btn.transform = CGAffineTransformMakeScale(2.0, 2.0);
        btn.alpha = 0;
        
    }];
    
    NSLog(@"%s",__func__);
}
- (void)btnClick:(UIButton *)btn
{
    [UIView animateWithDuration:1 animations:^{
        
        btn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
