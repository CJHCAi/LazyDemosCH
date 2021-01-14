//
//  ViewController.m
//  02-58同城引导页
//
//  Created by xiaomage on 15/6/26.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *sunView;
@property (weak, nonatomic) IBOutlet UIImageView *personView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIImage *bgImage = [UIImage imageNamed:@"520_userguid_bg"];
    UIScrollView *scorollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    scorollView.contentSize = bgImage.size;
    
    scorollView.delegate = self;
    
    scorollView.decelerationRate = 0.5;
    
    [self.view insertSubview:scorollView atIndex:0];
    
    // bg
    UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
    CGRect rect = bg.frame;
    rect.size.height = self.view.bounds.size.height;
    bg.frame = rect;
    
    [scorollView addSubview:bg];
    
    
}

// 只要一滚动就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获取scrollView偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    
    int intOffsetX = (int)offsetX;
    
    NSString *imageName = [NSString stringWithFormat:@"520_userguid_person_taitou_%d",(intOffsetX % 2 + 1)];
    UIImage *image = [UIImage imageNamed:imageName];
    // 切换人物的图片
    _personView.image = image;
    
    // 旋转小太阳
    _sunView.transform = CGAffineTransformRotate(_sunView.transform, (5) / 180.0 * M_PI);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
