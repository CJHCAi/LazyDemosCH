//
//  ViewController.m
//  标签
//
//  Created by Vieene on 16/7/29.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "ViewController.h"
#import "TYHlabelView.h"

@interface ViewController ()
@property (weak, nonatomic)  IBOutlet UIView *groupTypeView;
@property (nonatomic,strong) TYHlabelView  *labelView;
@property (nonatomic,strong) TYHlabelView  *labelView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *labels = [@"我，他，你，我们，他们，历史，VIP，same，1234567，12，犬瘟热特突然，ID哦啊接哦哦安" componentsSeparatedByString:@"，"];
    CGRect frame = CGRectMake(20, 30, 200, 140);
    self.labelView = [[TYHlabelView alloc] initWithLabelArray:labels viewframe:frame];
    self.labelView.backgroundColor = [UIColor lightGrayColor];
    self.labelView.Clickblock = ^(UIButton *btn){
        NSLog(@"%@----%d",btn,btn.tag);
    };
    [self.view addSubview:self.labelView];
    
    
    CGRect frame2 = CGRectMake(0, 64 + 180, 320, 140);
    self.labelView2 = [[TYHlabelView alloc] initWithLabelArray:labels viewframe:frame2];
    self.labelView2.backgroundColor = [UIColor darkGrayColor];
    self.labelView2.Clickblock = ^(UIButton *btn){
        NSLog(@"%@----%d",btn,btn.tag);
    };
    [self.view addSubview:self.labelView2];
}
- (void)hotTagButtonClick:(UIButton *)btn
{
    
}

@end
