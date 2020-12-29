//
//  UserFitnessDataViewController.m
//  SportForum
//
//  Created by zyshi on 14-9-11.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "UserFitnessDataViewController.h"
#import "UIViewController+SportFormu.h"
#import "UIImageView+WebCache.h"

@interface UserFitnessDataViewController ()

@end

@implementation UserFitnessDataViewController
{
    UIImageView *_imageViewUser;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _userInfo = [[ApplicationContext sharedInstance]accountInfo];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self generateCommonViewInParent:self.view Title:@"健身数据" IsNeedBackBtn:YES];
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    CGRect rect = viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
    viewBody.frame = rect;
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    viewBody.layer.mask = maskLayer;
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:viewBody.bounds];
    scrollView.contentSize = CGSizeMake(viewBody.frame.size.width, 500);
    [viewBody addSubview:scrollView];
    
    UIView * viewPart[5];
    viewPart[0] = [[UIView alloc] initWithFrame:CGRectMake(10, 10, viewBody.frame.size.width - 20, 90)];
    viewPart[1] = [[UIView alloc] initWithFrame:CGRectMake(10, 110, (viewBody.frame.size.width - 30) / 2, 90)];
    viewPart[2] = [[UIView alloc] initWithFrame:CGRectMake(viewBody.frame.size.width / 2 + 5, 110, (viewBody.frame.size.width - 30) / 2, 90)];
    viewPart[3] = [[UIView alloc] initWithFrame:CGRectMake(10, 210, viewBody.frame.size.width - 20, 80)];
    viewPart[4] = [[UIView alloc] initWithFrame:CGRectMake(10, 360, viewBody.frame.size.width - 20, 130)];
    for(int i = 0; i < 5; i++)
    {
        viewPart[i].backgroundColor = [UIColor whiteColor];
        viewPart[i].layer.borderColor = [UIColor colorWithRed:237.0 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1.0].CGColor;
        viewPart[i].layer.borderWidth = 1.0;
        viewPart[i].layer.cornerRadius = 5.0;
        /*viewPart[i].layer.shadowOffset = CGSizeMake(0, 2);
        viewPart[i].layer.shadowRadius = 2.0;
        viewPart[i].layer.shadowColor = [UIColor grayColor].CGColor;
        viewPart[i].layer.shadowOpacity = 0.8;*/
        [scrollView addSubview:viewPart[i]];
    }
    
    UILabel * lbSeparate1 = [[UILabel alloc] initWithFrame:CGRectMake(140, 30, 110, 2)];
    lbSeparate1.backgroundColor = [UIColor colorWithRed:231.0 / 255.0 green:231 / 255.0 blue:231 / 255.0 alpha:1.0];
    [viewPart[0] addSubview:lbSeparate1];
    
    UILabel * lbSeparate2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, viewPart[1].frame.size.width - 40, 2)];
    lbSeparate2.backgroundColor = [UIColor colorWithRed:231.0 / 255.0 green:231 / 255.0 blue:231 / 255.0 alpha:1.0];
    [viewPart[1] addSubview:lbSeparate2];
    
    UILabel * lbSeparate3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, viewPart[2].frame.size.width - 40, 2)];
    lbSeparate3.backgroundColor = [UIColor colorWithRed:231.0 / 255.0 green:231 / 255.0 blue:231 / 255.0 alpha:1.0];
    [viewPart[2] addSubview:lbSeparate3];
    
    UILabel * lbSeparate4 = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, viewPart[3].frame.size.width - 40, 2)];
    lbSeparate4.backgroundColor = [UIColor colorWithRed:231.0 / 255.0 green:231 / 255.0 blue:231 / 255.0 alpha:1.0];
    [viewPart[3] addSubview:lbSeparate4];
    
    UILabel * lbSeparate5 = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, viewPart[4].frame.size.width - 40, 2)];
    lbSeparate5.backgroundColor = [UIColor colorWithRed:231.0 / 255.0 green:231 / 255.0 blue:231 / 255.0 alpha:1.0];
    [viewPart[4] addSubview:lbSeparate5];
    
    viewPart[4].hidden = YES;

    _imageViewUser = [[UIImageView alloc]initWithFrame:CGRectMake(40, 10, 70, 70)];
    [_imageViewUser sd_setImageWithURL:[NSURL URLWithString:_userInfo.profile_image]
                   placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    _imageViewUser.layer.cornerRadius = 8.0;
    _imageViewUser.clipsToBounds = YES;
    [viewPart[0] addSubview:_imageViewUser];
    
    UILabel * lbNikeName = [[UILabel alloc] initWithFrame:CGRectMake(140, 5, viewPart[0].frame.size.width - 150, 20)];
    lbNikeName.backgroundColor = [UIColor clearColor];
    lbNikeName.text = _userInfo.nikename;
    lbNikeName.font = [UIFont systemFontOfSize:14];
    lbNikeName.textAlignment = NSTextAlignmentLeft;
    [viewPart[0] addSubview:lbNikeName];
    
    UILabel * lbHeight = [[UILabel alloc] initWithFrame:CGRectMake(140, 35, 40, 15)];
    lbHeight.backgroundColor = [UIColor clearColor];
    lbHeight.text = @"身高：";
    lbHeight.font = [UIFont boldSystemFontOfSize:12];
    lbHeight.textAlignment = NSTextAlignmentLeft;
    [viewPart[0] addSubview:lbHeight];
    
    UILabel * lbHeightValue = [[UILabel alloc] initWithFrame:CGRectMake(205, 35, 60, 15)];
    lbHeightValue.backgroundColor = [UIColor clearColor];
    lbHeightValue.text = [NSString stringWithFormat:@"%lu厘米", _userInfo.height];
    lbHeightValue.font = [UIFont boldSystemFontOfSize:12];
    lbHeightValue.textAlignment = NSTextAlignmentLeft;
    [viewPart[0] addSubview:lbHeightValue];
    
    UILabel * lbWeight = [[UILabel alloc] initWithFrame:CGRectMake(140, 50, 40, 15)];
    lbWeight.backgroundColor = [UIColor clearColor];
    lbWeight.text = @"体重：";
    lbWeight.font = [UIFont boldSystemFontOfSize:12];
    lbWeight.textAlignment = NSTextAlignmentLeft;
    [viewPart[0] addSubview:lbWeight];
    
    UILabel * lbWeightValue = [[UILabel alloc] initWithFrame:CGRectMake(205, 50, 60, 15)];
    lbWeightValue.backgroundColor = [UIColor clearColor];
    lbWeightValue.text = [NSString stringWithFormat:@"%ld公斤", _userInfo.weight];
    lbWeightValue.font = [UIFont boldSystemFontOfSize:12];
    lbWeightValue.textAlignment = NSTextAlignmentLeft;
    [viewPart[0] addSubview:lbWeightValue];
    
    UILabel * lbBMI = [[UILabel alloc] initWithFrame:CGRectMake(140, 65, 40, 15)];
    lbBMI.backgroundColor = [UIColor clearColor];
    lbBMI.text = @"BMI：";
    lbBMI.font = [UIFont boldSystemFontOfSize:12];
    lbBMI.textAlignment = NSTextAlignmentLeft;
    [viewPart[0] addSubview:lbBMI];
    
    UILabel * lbBMIValue = [[UILabel alloc] initWithFrame:CGRectMake(205, 65, 60, 15)];
    lbBMIValue.backgroundColor = [UIColor clearColor];
    lbBMIValue.text = [NSString stringWithFormat:@"%.1f", _userInfo.weight / (_userInfo.height * _userInfo.height / 10000.0)];
    lbBMIValue.font = [UIFont boldSystemFontOfSize:12];
    lbBMIValue.textAlignment = NSTextAlignmentLeft;
    [viewPart[0] addSubview:lbBMIValue];
    
    UILabel * lbMaxDistance = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, viewPart[1].frame.size.width - 40, 30)];
    lbMaxDistance.backgroundColor = [UIColor clearColor];
    lbMaxDistance.textAlignment = NSTextAlignmentCenter;
    [viewPart[1] addSubview:lbMaxDistance];
    
    UILabel * lbDistanceDescription = [[UILabel alloc] initWithFrame:CGRectMake(20, 55, viewPart[1].frame.size.width - 40, 20)];
    lbDistanceDescription.backgroundColor = [UIColor clearColor];
    lbDistanceDescription.text = @"单日跑步最远距离";
    lbDistanceDescription.font = [UIFont boldSystemFontOfSize:12];
    lbDistanceDescription.textAlignment = NSTextAlignmentCenter;
    [viewPart[1] addSubview:lbDistanceDescription];
    
    UILabel * lbCalorie = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, viewPart[1].frame.size.width - 40, 30)];
    lbCalorie.backgroundColor = [UIColor clearColor];
    lbCalorie.textAlignment = NSTextAlignmentCenter;
    [viewPart[2] addSubview:lbCalorie];
    
    UILabel * lbCalorieDescription = [[UILabel alloc] initWithFrame:CGRectMake(20, 55, viewPart[1].frame.size.width - 40, 20)];
    lbCalorieDescription.backgroundColor = [UIColor clearColor];
    lbCalorieDescription.text = @"单日跑步最大消耗";
    lbCalorieDescription.font = [UIFont boldSystemFontOfSize:12];
    lbCalorieDescription.textAlignment = NSTextAlignmentCenter;
    [viewPart[2] addSubview:lbCalorieDescription];
    
    UILabel * lbTotalDistance = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, viewPart[3].frame.size.width - 40, 30)];
    lbTotalDistance.backgroundColor = [UIColor clearColor];
    [viewPart[3] addSubview:lbTotalDistance];
    
    UILabel * lbTotalCalorie = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, viewPart[3].frame.size.width - 40, 30)];
    lbTotalCalorie.backgroundColor = [UIColor clearColor];
    [viewPart[3] addSubview:lbTotalCalorie];
    
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    __weak __typeof(self) weakSelf = self;
        
    [[SportForumAPI sharedInstance] recordStatisticsByUserId:userInfo.userid
                                             FinishedBlock:^void(int errorCode, RecordStatisticsInfo *recordStatisticsInfo)
     {
         __typeof(self) strongSelf = weakSelf;
         
         if (strongSelf == nil) {
             return;
         }
         
         NSDictionary *attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:24], NSForegroundColorAttributeName:[UIColor colorWithRed:1.0 green:160 / 255.0 blue:0 alpha:1.0]};
         NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f", recordStatisticsInfo.max_distance_record.distance / 1000.0] attributes:attribs];
         attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:12], NSForegroundColorAttributeName:[UIColor colorWithRed:1.0 green:160 / 255.0 blue:0 alpha:1.0]};
         NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:@" 公里" attributes:attribs];
         NSMutableAttributedString * strMix = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
         [strMix appendAttributedString:strPart2Value];
         lbMaxDistance.attributedText = strMix;

         attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:24], NSForegroundColorAttributeName:[UIColor colorWithRed:1.0 green:160 / 255.0 blue:0 alpha:1.0]};
         strPart1Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.0f", userInfo.weight * recordStatisticsInfo.max_distance_record.distance / 800.0] attributes:attribs];
         attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:12], NSForegroundColorAttributeName:[UIColor colorWithRed:1.0 green:160 / 255.0 blue:0 alpha:1.0]};
         strPart2Value = [[NSAttributedString alloc] initWithString:@" 大卡" attributes:attribs];
         strMix = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
         [strMix appendAttributedString:strPart2Value];
         lbCalorie.attributedText = strMix;

         attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:12], NSForegroundColorAttributeName:[UIColor blackColor]};
         strPart1Value = [[NSAttributedString alloc] initWithString:@"跑步总共累计 " attributes:attribs];
         attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:24], NSForegroundColorAttributeName:[UIColor colorWithRed:1.0 green:160 / 255.0 blue:0 alpha:1.0]};
         strPart2Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f", recordStatisticsInfo.total_distance / 1000.0] attributes:attribs];
         attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:12], NSForegroundColorAttributeName:[UIColor blackColor]};
         NSAttributedString * strPart3Value = [[NSAttributedString alloc] initWithString:@" 公里" attributes:attribs];
         strMix = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
         [strMix appendAttributedString:strPart2Value];
         [strMix appendAttributedString:strPart3Value];
         lbTotalDistance.attributedText = strMix;

         attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:12], NSForegroundColorAttributeName:[UIColor blackColor]};
         strPart1Value = [[NSAttributedString alloc] initWithString:@"累计消耗了卡路里 " attributes:attribs];
         attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:24], NSForegroundColorAttributeName:[UIColor colorWithRed:1.0 green:160 / 255.0 blue:0 alpha:1.0]};
         strPart2Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.0f", userInfo.weight * recordStatisticsInfo.total_distance / 800.0] attributes:attribs];
         attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:12], NSForegroundColorAttributeName:[UIColor blackColor]};
         strPart3Value = [[NSAttributedString alloc] initWithString:@" 大卡" attributes:attribs];
         strMix = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
         [strMix appendAttributedString:strPart2Value];
         [strMix appendAttributedString:strPart3Value];
         lbTotalCalorie.attributedText = strMix;
     }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[ApplicationContext sharedInstance]cancelCurrentRequests:[NSArray arrayWithObjects:urlRecordStatistics, nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"UserFitnessDataViewController dealloc called!");
}

-(BOOL)bShowFooterViewController {
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
