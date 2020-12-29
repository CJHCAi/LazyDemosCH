//
//  TaskTipsViewController.m
//  SportForum
//
//  Created by liyuan on 7/10/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "TaskTipsViewController.h"
#import "UIViewController+SportFormu.h"

@interface TaskTipsViewController ()

@end

@implementation TaskTipsViewController

- (void)printFontAndFamilyName
{
    NSArray *familyNames =[[NSArray alloc]initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for(indFamily=0;indFamily<[familyNames count];++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames =[[NSArray alloc]initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
        for(indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@" Font name: %@",[fontNames objectAtIndex:indFont]);
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self printFontAndFamilyName];
    
    [self generateCommonViewInParent:self.view Title:@"运动提示" IsNeedBackBtn:YES];
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    CGRect rect = viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
    viewBody.frame = rect;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    viewBody.layer.mask = maskLayer;
    
    UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(viewBody.frame), CGRectGetHeight(viewBody.frame))];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.scrollEnabled = YES;
    [viewBody addSubview:scrollView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(viewBody.frame) - 310) / 2, 0, 310, 568)];
    [imageView setImage:[UIImage imageNamedWithWebP:@"runtip"]];
    [scrollView addSubview:imageView];
    
    UILabel *lbDescContent = [[UILabel alloc]initWithFrame:CGRectMake(55, 70, CGRectGetWidth(viewBody.frame) - 65, 40)];
    lbDescContent.backgroundColor = [UIColor clearColor];
    lbDescContent.textColor = [UIColor darkGrayColor];
    lbDescContent.textAlignment = NSTextAlignmentLeft;
    lbDescContent.font = [UIFont boldSystemFontOfSize:14];
    lbDescContent.numberOfLines = 0;
    lbDescContent.text = _strTips;
    [scrollView addSubview:lbDescContent];
    
    CGSize constraint = CGSizeMake(CGRectGetWidth(viewBody.frame) - 110, 20000.0f);
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;

    CGSize size = [_strTips boundingRectWithSize:constraint
                                        options:options
                                     attributes:@{NSFontAttributeName:lbDescContent.font} context:nil].size;
    
    lbDescContent.frame = CGRectMake(100,
                                   100,
                                   CGRectGetWidth(viewBody.frame) - 110,
                                   size.height + 20);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"TaskTipsViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"TaskTipsViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"TaskTipsViewController"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"TaskTipsViewController dealloc called!");
}

@end
