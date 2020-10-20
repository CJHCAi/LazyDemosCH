//
//  JRRelationViewController.m
//  JR
//
//  Created by 张骏 on 17/8/25.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "JRRelationViewController.h"
#import "JRRelationView.h"

@interface JRRelationViewController ()
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) JRRelationView *relationView;

@end

@implementation JRRelationViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setBgImgView];
 
    [self setRelationView];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


#pragma mark - private
- (void)setBgImgView{
    _bgImgView = [UIImageView imageViewWithFrame:self.view.bounds image:[UIImage imageNamed:@"relationBg"]];
    
    [self.view addSubview:_bgImgView];
}


- (void)setRelationView{
    
    CGFloat height = JRHeight(350 + 2 * JRPadding);
    _relationView = [[JRRelationView alloc] initWithFrame:CGRectMake(0, self.view.height - height - 44 - JRPadding, JRScreenWidth, height)];
    _relationView.picArray = @[[UIImage new], [UIImage imageNamed:@"relationBedge"], [UIImage imageNamed:@"relationPK"], [UIImage new]];
    
    [self.view addSubview:_relationView];
}


@end
