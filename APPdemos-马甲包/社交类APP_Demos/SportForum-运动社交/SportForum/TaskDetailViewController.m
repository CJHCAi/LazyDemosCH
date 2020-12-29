//
//  TaskDetailViewController.m
//  SportForum
//
//  Created by liyuan on 7/10/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "UIViewController+SportFormu.h"

@interface TaskDetailViewController ()

@end

@implementation TaskDetailViewController
{
    UIView *_viewBody;
    UIScrollView *m_scrollView;
    TasksInfo *m_taskInfo;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self generateCommonViewInParent:self.view Title:@"任务详情" IsNeedBackBtn:YES];
    
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
    
    m_scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_viewBody.frame), CGRectGetHeight(_viewBody.frame))];
    m_scrollView.backgroundColor = [UIColor clearColor];
    m_scrollView.scrollEnabled = YES;
    [_viewBody addSubview:m_scrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadTaskResult];
    [MobClick beginLogPageView:@"TaskDetailViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"TaskDetailViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"TaskDetailViewController"];
    [[ApplicationContext sharedInstance]cancelCurrentRequests:[NSArray arrayWithObjects:urlTasksResult, nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"TaskDetailViewController dealloc called!");
}

-(void)loadTaskResult
{
    [[SportForumAPI sharedInstance]tasksGetResultById:_taskId FinishedBlock:^(int errorCode, TasksInfo *tasksInfo){
        if (errorCode == 0) {
            m_taskInfo = tasksInfo;
            [self refreshTaskDetail];
        }
    }];
}

-(void)refreshTaskDetail
{
    for (UIView *view in [m_scrollView subviews]){
        [view removeFromSuperview];
    }
    
    NSString *strTaskTitle = @"跑步任务";
    UIImage *imgTask = [UIImage imageNamed:@"me-level-runner"];
    
    switch (_eTaskType) {
        case e_task_physique:
            imgTask = [UIImage imageNamed:@"me-level-runner"];
            strTaskTitle = @"跑步任务";
            break;
        case e_task_literature:
            imgTask = [UIImage imageNamed:@"me-level-pen"];
            strTaskTitle = @"博文任务";
            break;
        case e_task_magic:
            imgTask = [UIImage imageNamed:@"me-level-magic"];
            strTaskTitle = @"魔法任务";
            break;
        default:
            break;
    }

    UIImageView *imgViewTask = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(m_scrollView.frame) / 2 - 55, 15, 30, 30)];
    [imgViewTask setImage:imgTask];
    [m_scrollView addSubview:imgViewTask];
    
    UILabel *lbTaskTitle = [[UILabel alloc]init];
    lbTaskTitle.backgroundColor = [UIColor clearColor];
    lbTaskTitle.text = strTaskTitle;
    lbTaskTitle.textColor = [UIColor darkGrayColor];
    lbTaskTitle.font = [UIFont boldSystemFontOfSize:15];
    lbTaskTitle.frame = CGRectMake(CGRectGetWidth(m_scrollView.frame) / 2 - 25, CGRectGetMinY(imgViewTask.frame), 100, 25);
    lbTaskTitle.textAlignment = NSTextAlignmentLeft;
    [m_scrollView addSubview:lbTaskTitle];
    
    UIImageView *imgTaskBoard = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(m_scrollView.frame) - 263) / 2, CGRectGetMaxY(imgViewTask.frame) - 10, 263, 118)];
    [imgTaskBoard setImage:[UIImage imageNamed:@"dialogbox"]];
    [m_scrollView addSubview:imgTaskBoard];
    
    UILabel *lbTaskDesc = [[UILabel alloc]init];
    lbTaskDesc.backgroundColor = [UIColor clearColor];
    lbTaskDesc.textColor = [UIColor darkGrayColor];
    lbTaskDesc.font = [UIFont boldSystemFontOfSize:14];
    lbTaskDesc.frame = CGRectMake(CGRectGetMinX(imgTaskBoard.frame) + 15, CGRectGetMaxY(imgViewTask.frame) + 20, CGRectGetWidth(m_scrollView.frame) - (CGRectGetMinX(imgTaskBoard.frame) + 15) * 2, 60);
    lbTaskDesc.textAlignment = NSTextAlignmentCenter;
    lbTaskDesc.numberOfLines = 0;
    [m_scrollView addSubview:lbTaskDesc];
    
    if (_eTaskType == e_task_physique) {
        NSDictionary *attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:@"距离：" attributes:attribs];
        
        attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:20], NSForegroundColorAttributeName:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0]};
        NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f ", _distance / 1000.0] attributes:attribs];
        
        attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSAttributedString * strPart3Value = [[NSAttributedString alloc] initWithString:@"公里， 时长：" attributes:attribs];
        
        attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:20], NSForegroundColorAttributeName:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0]};
        NSAttributedString * strPart4Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lld ", _duration / 60] attributes:attribs];
        
        attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSAttributedString * strPart5Value = [[NSAttributedString alloc] initWithString:@"分钟\n" attributes:attribs];
        
        attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSAttributedString * strPart6Value = [[NSAttributedString alloc] initWithString:m_taskInfo.task_desc attributes:attribs];
        
        NSMutableAttributedString * strPer = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
        [strPer appendAttributedString:strPart2Value];
        [strPer appendAttributedString:strPart3Value];
        [strPer appendAttributedString:strPart4Value];
        [strPer appendAttributedString:strPart5Value];
        [strPer appendAttributedString:strPart6Value];
        
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setParagraphSpacing:10];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [strPer addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [strPer length])];
        lbTaskDesc.attributedText = strPer;
    }
    else
    {
        lbTaskDesc.text = m_taskInfo.task_desc;
    }

    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    NSUInteger nLevel = userInfo.proper_info.rankLevel;
    NSUInteger nHorseCount = nLevel / 25;
    NSUInteger nRabbitCount = (nLevel - nHorseCount * 25) / 5;
    //NSUInteger nSnailCount = nLevel - nHorseCount * 25 - nRabbitCount * 5;
    
    NSString *strLevelImg = @"level-snail";
    
    if (nHorseCount > 0) {
        strLevelImg = @"level-horse";
    }
    else if(nRabbitCount > 0)
    {
        strLevelImg = @"level-rabbit";
    }
    else
    {
        strLevelImg = @"level-snail";
    }

    UIImageView *imgViewTips = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgTaskBoard.frame) - 30, CGRectGetMinY(imgViewTask.frame) - 10, 30, 30)];
    [imgViewTips setImage:[UIImage imageNamed:strLevelImg]];
    [m_scrollView addSubview:imgViewTips];

    UIImageView *imgResultBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(m_scrollView.frame) - 291, 310, 291)];
    [imgResultBg setImage:[UIImage imageNamedWithWebP:@"noticeboardnew"]];
    [m_scrollView addSubview:imgResultBg];
    
    UIImageView *imgViewStatus = [[UIImageView alloc]initWithFrame:CGRectMake(85, CGRectGetMaxY(imgTaskBoard.frame) + 105, 24, 24)];
    imgViewStatus.hidden = YES;
    [m_scrollView addSubview:imgViewStatus];
    
    UILabel* lbResultTitle = [[UILabel alloc]initWithFrame:CGRectMake(80, CGRectGetMaxY(imgTaskBoard.frame) + 105, 155, 27)];
    lbResultTitle.backgroundColor = [UIColor clearColor];
    lbResultTitle.textColor = [UIColor darkGrayColor];
    lbResultTitle.font = [UIFont boldSystemFontOfSize:14];
    lbResultTitle.textAlignment = NSTextAlignmentCenter;
    lbResultTitle.numberOfLines = 0;
    [m_scrollView addSubview:lbResultTitle];
    
    UILabel* lbResultContent = [[UILabel alloc]init];
    lbResultContent.backgroundColor = [UIColor clearColor];
    lbResultContent.textColor = [UIColor darkGrayColor];
    lbResultContent.font = [UIFont boldSystemFontOfSize:14];
    lbResultContent.textAlignment = NSTextAlignmentLeft;
    lbResultContent.numberOfLines = 0;
    [m_scrollView addSubview:lbResultContent];
    
    UILabel* lbResultReview = [[UILabel alloc]init];
    lbResultReview.backgroundColor = [UIColor clearColor];
    lbResultReview.textColor = [UIColor darkGrayColor];
    lbResultReview.font = [UIFont boldSystemFontOfSize:14];
    lbResultReview.textAlignment = NSTextAlignmentLeft;
    lbResultReview.numberOfLines = 0;
    [m_scrollView addSubview:lbResultReview];
    
    e_task_status eTaskStatus = [CommonFunction ConvertStringToTaskStatusType:m_taskInfo.task_status];
    
    NSString *strResult = @"尚未提交记录";
    NSString *strReview = @"";
    UIImage *imageStatus = nil;
    
    switch (eTaskStatus) {
        case e_task_normal:
            strResult = @"尚未提交记录";
            lbResultContent.hidden = YES;
            lbResultReview.hidden = YES;
            break;
        case e_task_finish:
            imageStatus = [UIImage imageNamed:@"task-finished"];
            strResult = @"任务通过审核";
            lbResultContent.hidden = NO;
            lbResultReview.hidden = NO;
            lbResultReview.textColor = [UIColor darkGrayColor];
            break;
        case e_task_unfinish:
            imageStatus = [UIImage imageNamed:@"task-fail"];
            strResult = @"任务已被拒绝";
            
            if (m_taskInfo.task_result.length > 0) {
                strReview = [NSString stringWithFormat:@"原因: %@", m_taskInfo.task_result];
            }
            else
            {
                strReview = @"原因: 非常抱歉，您的任务审核未通过。";
            }
            
            lbResultContent.hidden = NO;
            lbResultReview.hidden = NO;
            lbResultReview.textColor = [UIColor redColor];
            break;
        case e_task_authentication:
            imageStatus = [UIImage imageNamed:@"task-pendding"];
            strResult = @"任务正在审核";
            lbResultContent.hidden = NO;
            lbResultReview.hidden = NO;
            lbResultReview.textColor = [UIColor darkGrayColor];
            break;
        default:
            break;
    }

    lbResultTitle.text = strResult;
    
    if (imageStatus != nil) {
        imgViewStatus.hidden = NO;
        [imgViewStatus setImage:imageStatus];
    }
    
    if (_eTaskType == e_task_literature || _eTaskType == e_task_magic)
    {
        lbResultContent.text = m_taskInfo.task_result;
    }
    else if (_eTaskType == e_task_physique) {
        NSDictionary *attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:@"距离: " attributes:attribs];
        
        attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16], NSForegroundColorAttributeName:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0]};
        NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f ", m_taskInfo.distance / 1000.0] attributes:attribs];
        
        attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSAttributedString * strPart3Value = [[NSAttributedString alloc] initWithString:@"公里, 时长: " attributes:attribs];
        
        attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16], NSForegroundColorAttributeName:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0]};
        NSAttributedString * strPart4Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lld ", m_taskInfo.duration / 60] attributes:attribs];
        
        attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSAttributedString * strPart5Value = [[NSAttributedString alloc] initWithString:@"分钟" attributes:attribs];
        
        NSMutableAttributedString * strPer = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
        [strPer appendAttributedString:strPart2Value];
        [strPer appendAttributedString:strPart3Value];
        [strPer appendAttributedString:strPart4Value];
        [strPer appendAttributedString:strPart5Value];
        lbResultContent.attributedText = strPer;
    }

    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize size = [lbResultContent.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(m_scrollView.frame) - 120, 20000.0f)
                                                     options:options
                                                  attributes:@{NSFontAttributeName:lbResultContent.font} context:nil].size;
    lbResultContent.frame = CGRectMake(65, CGRectGetMaxY(lbResultTitle.frame) + 5, CGRectGetWidth(m_scrollView.frame) - 120, size.height + 10);
    
    lbResultReview.text = strReview;
    
    size = [lbResultReview.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(m_scrollView.frame) - 110, 20000.0f)
                                                     options:options
                                                  attributes:@{NSFontAttributeName:lbResultReview.font} context:nil].size;
    lbResultReview.frame = CGRectMake(65, CGRectGetMaxY(lbResultContent.frame) + 5, CGRectGetWidth(m_scrollView.frame) - 120, size.height + 10);
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
