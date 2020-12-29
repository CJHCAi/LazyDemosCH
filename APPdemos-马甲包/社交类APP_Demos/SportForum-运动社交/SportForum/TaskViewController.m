//
//  TaskViewController.m
//  SportForum
//
//  Created by liyuan on 14-9-10.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "TaskViewController.h"
#import "UIViewController+SportFormu.h"
#import "RecordSportViewController.h"
#import "AlertManager.h"

@interface TaskViewController ()
@end

@implementation TaskViewController
{
    UIView *_viewBody;
    UIScrollView *m_scrollView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoadGUI
{
    m_scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_viewBody.frame), CGRectGetHeight(_viewBody.frame))];
    m_scrollView.backgroundColor = [UIColor clearColor];
    m_scrollView.scrollEnabled = YES;
    [_viewBody addSubview:m_scrollView];
    
    UILabel *labelDesc = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 290, 20)];
    labelDesc.backgroundColor = [UIColor clearColor];
    labelDesc.textColor = [UIColor blackColor];
    labelDesc.text =  [NSString stringWithFormat:@"任务描述:"];
    labelDesc.textAlignment = NSTextAlignmentLeft;
    labelDesc.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:labelDesc];
    
    UILabel *lbDescContent = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(labelDesc.frame), 290, 40)];
    lbDescContent.backgroundColor = [UIColor clearColor];
    lbDescContent.textColor = [UIColor blackColor];
    lbDescContent.text = _taskInfo.task_desc;
    lbDescContent.textAlignment = NSTextAlignmentLeft;
    lbDescContent.font = [UIFont boldSystemFontOfSize:14];
    lbDescContent.numberOfLines = 0;
    [m_scrollView addSubview:lbDescContent];
    
    CGSize constraint0 = CGSizeMake(CGRectGetWidth(lbDescContent.frame), 20000.0f);
    //CGSize size0 = [_taskInfo.task_desc sizeWithFont:lbDescContent.font constrainedToSize:constraint0 lineBreakMode:NSLineBreakByWordWrapping];
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize size0 = [_taskInfo.task_desc boundingRectWithSize:constraint0
                                        options:options
                                     attributes:@{NSFontAttributeName:lbDescContent.font} context:nil].size;
    lbDescContent.frame = CGRectMake(10, CGRectGetMaxY(labelDesc.frame), 290, size0.height);

    UIView *viewTips = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lbDescContent.frame), CGRectGetWidth(_viewBody.frame), CGRectGetHeight(_viewBody.frame) - 53 - CGRectGetMaxY(lbDescContent.frame) - 10)];
    [m_scrollView addSubview:viewTips];
    
    /*UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(viewTips.frame) - 274) / 2, 60, 274, 145)];
    [imageView setImage:[UIImage imageNamed:@"task-tips"]];
    [viewTips addSubview:imageView];
    
    CSButton *btnTipsView = [CSButton buttonWithType:UIButtonTypeCustom];
    btnTipsView.contentEdgeInsets = UIEdgeInsetsMake(10, 15, 25, 10);
    btnTipsView.backgroundColor = [UIColor clearColor];
    btnTipsView.titleLabel.font = [UIFont systemFontOfSize:14];
    btnTipsView.titleLabel.numberOfLines = 0;
    [btnTipsView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnTipsView setTitle:@"有问题就点我哦!" forState:UIControlStateNormal];
    btnTipsView.frame = CGRectMake(140, 120, 130, 30);
    [viewTips addSubview:btnTipsView];*/
    
    //NSString *strText = @"训练提示：慢跑为小碎步跑。为了给你的训练增加能量你可以在出门前两小时吃一点水果或者巧克力，然后在出门前一小时喝适量（约240克）的运动饮料，"
     //                   "这样既能够保证你有充足的水分，也能补充钠和钾。如有问题，点此提问。";
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, (CGRectGetHeight(viewTips.frame) - 214) / 2, 92, 214)];
    [imageView setImage:[UIImage imageNamed:@"girl-tips"]];
    [viewTips addSubview:imageView];
    
    NSString *strText = _taskInfo.task_tip;
    CSButton *btnTipsView = [CSButton buttonWithType:UIButtonTypeCustom];
    btnTipsView.contentEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 10);
    UIImage* origimage = [UIImage imageNamed:@"message-2"];
    origimage = [origimage resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(origimage.size.height / 2) + 5 , floorf(origimage.size.width / 2) + 5, floorf(origimage.size.height / 2) + 5, floorf(origimage.size.width / 2) + 5)];
    btnTipsView.backgroundColor = UIColor.clearColor;
    btnTipsView.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    btnTipsView.titleLabel.numberOfLines = 0;
    [btnTipsView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnTipsView setBackgroundImage:origimage forState:UIControlStateNormal];
    [btnTipsView setBackgroundImage:origimage forState:UIControlStateHighlighted];
    [btnTipsView setTitle:strText forState:UIControlStateNormal];
    [viewTips addSubview:btnTipsView];
    
    CGSize constraint = CGSizeMake(CGRectGetWidth(viewTips.frame) - CGRectGetMaxX(imageView.frame) - 30 - 25  , 20000.0f);
    //CGSize size = [strText sizeWithFont:btnTipsView.titleLabel.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize size = [strText boundingRectWithSize:constraint
                                                       options:options
                                                    attributes:@{NSFontAttributeName:btnTipsView.titleLabel.font} context:nil].size;
    
    btnTipsView.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + 10,
                                   MAX((CGRectGetHeight(viewTips.frame) - size.height - 20) / 2, 10),
                                   CGRectGetWidth(viewTips.frame) - CGRectGetMaxX(imageView.frame) - 30,
                                   size.height + 20);
    
    /*CSButton *btnTips = [CSButton buttonWithType:UIButtonTypeCustom];
    btnTips.backgroundColor = UIColor.clearColor;
    btnTips.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    btnTips.titleLabel.textAlignment = NSTextAlignmentLeft;
    [btnTips setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnTips setTitle:@"提问" forState:UIControlStateNormal];
    btnTips.frame = CGRectMake(CGRectGetMinX(btnTipsView.frame) + 18, CGRectGetMaxY(btnTipsView.frame) - 25, 25, 20);
    [viewTips addSubview:btnTips];
    [viewTips bringSubviewToFront:btnTips];
    
    btnTips.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        CircleDetailViewController *circleDetailViewController = [[CircleDetailViewController alloc]init];
        circleDetailViewController.strCircleType = @"运动日志";
        circleDetailViewController.eArticleTagType = e_article_log;
        [strongSelf.navigationController pushViewController:circleDetailViewController animated:YES];
    };
    
    UILabel *labelLine = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(btnTips.frame), CGRectGetMaxY(btnTips.frame) - 2, 22, 0.8)];
    labelLine.backgroundColor = [UIColor blueColor];
    labelLine.textColor = [UIColor blueColor];
    [viewTips addSubview:labelLine];*/
    
    CSButton *btnFinish = [CSButton buttonWithType:UIButtonTypeCustom];
    btnFinish.frame = CGRectMake((CGRectGetWidth(m_scrollView.frame) - 123) / 2, CGRectGetHeight(_viewBody.frame) - 53, 123, 38);
    [btnFinish setTitle:@"输入数据" forState:UIControlStateNormal];
    [btnFinish setBackgroundImage:[UIImage imageNamed:@"btn-3-yellow"] forState:UIControlStateNormal];
    [btnFinish setBackgroundImage:[UIImage imageNamed:@"btn-3-grey"] forState:UIControlStateDisabled];
    btnFinish.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [btnFinish setTitleColor:[UIColor colorWithRed:184.0 / 255.0 green:126.0 / 255.0 blue:0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [btnFinish setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnFinish setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    [m_scrollView addSubview:btnFinish];

    m_scrollView.contentSize = CGSizeMake(m_scrollView.contentSize.width, CGRectGetMaxY(btnFinish.frame) + 25);
    __weak __typeof(self) weakSelf = self;
    
    btnFinish.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
        
        if (userInfo != nil) {
            if (userInfo.ban_time > 0) {
                [AlertManager showAlertText:@"用户已被禁言，无法完成本次操作。" InView:strongSelf.view hiddenAfter:2];
                return;
            }
            else if(userInfo.ban_time < 0)
            {
                [AlertManager showAlertText:@"用户已进入黑名单，无法完成本次操作。" InView:strongSelf.view hiddenAfter:2];
                return;
            }
        }
        
        RecordSportViewController *recordSportViewController = [[RecordSportViewController alloc]init];
        recordSportViewController.taskInfo = strongSelf.taskInfo;
        [strongSelf.navigationController pushViewController:recordSportViewController animated:YES];
    };
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self generateCommonViewInParent:self.view Title:@"记录运动任务" IsNeedBackBtn:YES];
    
    _viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    _viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    CGRect rect = _viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
    _viewBody.frame = rect;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    _viewBody.layer.mask = maskLayer;
    
    [self viewDidLoadGUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"TaskViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"TaskViewController"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"TaskViewController dealloc called!");
}

@end
