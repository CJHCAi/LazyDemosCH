//
//  YXWGuideViewController.m
//  StarAlarm
//
//  Created by dllo on 16/4/15.
//  Copyright © 2016年 YYL. All rights reserved.
//

#import "YXWGuideViewController.h"

@interface YXWGuideViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation YXWGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //引导页
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 4, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    
    for (int i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width * i, 0,self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"引导页%d",i]];
        imageView.userInteractionEnabled = YES;
        [self.scrollView addSubview:imageView];
       
    }
    
    UIButton *endInButton = [UIButton buttonWithType:UIButtonTypeSystem];
    endInButton.frame = CGRectMake(self.scrollView.frame.size.width * 3.5 - 40, self.scrollView.frame.size.height / 2 + 40, 100, 30);
    [endInButton setTitle:@"立即体验" forState:UIControlStateNormal];
    
    [endInButton addTarget:self action:@selector(endInAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:endInButton];
    [self.view addSubview:self.scrollView];

}

-(void)endInAction:(UIButton *)sender {
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center postNotificationName:@"guide" object:@"nil" userInfo:nil];
}

#pragma mark - scrollview 的协议方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSLog(@"%f",scrollView.contentOffset.x);
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
