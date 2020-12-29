//
//  TaskHistoryViewController.m
//  SportForum
//
//  Created by liyuan on 14-10-11.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "TaskHistoryViewController.h"
#import "UIViewController+SportFormu.h"
#import "UIImageView+WebCache.h"
#import "MWPhotoBrowser.h"
#import "RecordSportViewController.h"

#define MAX_PUBLISH_PNG_COUNT 6
#define TASK_IMAGE_ADD_BTN_TAG 100
#define TASK_VIEW_TIPS_TAG 101
#define TASK_FINISH_BTN_TAG 102

@interface TaskHistoryViewController ()<MWPhotoBrowserDelegate>

@end

@implementation TaskHistoryViewController
{
    UIView *_viewBody;
    UILabel *_lbPicBegin;
    
    NSMutableArray * _imgViewArray;
    NSMutableArray * _imgBtnArray;
    NSMutableArray * _imgBackFrameArray;
    NSMutableArray *_photos;
    
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
    
    _imgViewArray = [[NSMutableArray alloc]init];
    _imgBtnArray = [[NSMutableArray alloc]init];
    _imgBackFrameArray = [[NSMutableArray alloc]init];
    _photos = [[NSMutableArray alloc]init];
    
    [self generateCommonViewInParent:self.view Title:@"历史任务" IsNeedBackBtn:YES];
    
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
    [self loadTaskInfo];
    [MobClick beginLogPageView:@"TaskHistoryViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"TaskHistoryViewController"];
    [[ApplicationContext sharedInstance]cancelCurrentRequests:[NSArray arrayWithObjects:urlTasksGetInfo, nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"TaskHistoryViewController dealloc called!");
}

-(void)loadTaskInfo
{
    [[SportForumAPI sharedInstance]tasksGetInfoByTaskId:_taskId FinishedBlock:^(int errorCode, TasksInfo *tasksInfo){
        if (errorCode == 0) {
            m_taskInfo = tasksInfo;
            [self refreshTaskHistory];
        }
    }];
}

-(void)refreshTaskHistory
{
    for (UIView *view in [m_scrollView subviews]){
        [view removeFromSuperview];
    }
    
    e_task_status eTaskStatus = [CommonFunction ConvertStringToTaskStatusType:m_taskInfo.task_status];
    
    NSString *strTips = @"";
    NSString *strStatus = @"";
    UIImage *imageStatus = nil;
    
    if (_eTaskType == e_task_literature || _eTaskType == e_task_magic) {
        imageStatus = [UIImage imageNamed:@"task-finished"];
        strStatus = @"任务已完成";
        strTips = @"恭喜您顺利完成任务.";
    }
    else
    {
        if (eTaskStatus == e_task_finish) {
            imageStatus = [UIImage imageNamed:@"task-finished"];
            strStatus = @"任务已审核通过";
            
            if (m_taskInfo.task_result.length > 0) {
                strTips = [NSString stringWithFormat:@"恭喜您顺利完成任务.\n%@", [NSString stringWithFormat:@"我们建议：%@", m_taskInfo.task_result]];
            }
            else
            {
                strTips = @"恭喜您顺利完成任务.";
            }
        }
        else if(eTaskStatus == e_task_authentication)
        {
            imageStatus = [UIImage imageNamed:@"task-waiting"];
            strStatus = @"正在审核中";
            strTips = @"请耐心等待，我们正在审核您的任务完成状况.";
        }
        else if(eTaskStatus == e_task_unfinish)
        {
            imageStatus = [UIImage imageNamed:@"task-fail"];
            strStatus = @"任务审核未通过";
            strTips = @"非常抱歉，您的任务审核未通过.";
            
            if (m_taskInfo.task_result.length > 0) {
                strTips = [NSString stringWithFormat:@"非常抱歉，您的任务审核未通过.\n%@", [NSString stringWithFormat:@"我们建议：%@", m_taskInfo.task_result]];
            }
            else
            {
                strTips = @"非常抱歉，您的任务审核未通过.";
            }
        }
    }
    
    /*UILabel *labelStatus = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 20)];
    labelStatus.backgroundColor = [UIColor clearColor];
    labelStatus.textColor = [UIColor blackColor];
    labelStatus.text = @"任务状态:";
    labelStatus.textAlignment = NSTextAlignmentLeft;
    labelStatus.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:labelStatus];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(labelStatus.frame), imageStatus.size.width, imageStatus.size.height)];
    [imageView setImage:imageStatus];
    [m_scrollView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, CGRectGetMaxY(labelStatus.frame), 120, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = (eTaskStatus == e_task_unfinish ? [UIColor redColor] : [UIColor blackColor]);
    label.text = strStatus;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:label];*/
    
    UILabel *labelDesc = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 290, 20)];
    labelDesc.backgroundColor = [UIColor clearColor];
    labelDesc.textColor = [UIColor blackColor];
    labelDesc.text = @"任务描述:";
    labelDesc.textAlignment = NSTextAlignmentLeft;
    labelDesc.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:labelDesc];
    
    UILabel *lbDescContent = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(labelDesc.frame), 290, 40)];
    lbDescContent.backgroundColor = [UIColor clearColor];
    lbDescContent.textColor = [UIColor blackColor];
    lbDescContent.text = m_taskInfo.task_desc;
    lbDescContent.textAlignment = NSTextAlignmentLeft;
    lbDescContent.font = [UIFont boldSystemFontOfSize:14];
    lbDescContent.numberOfLines = 0;
    [m_scrollView addSubview:lbDescContent];

    //CGSize size = [lbDescContent.text sizeWithFont:lbDescContent.font constrainedToSize:CGSizeMake(290, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize size = [lbDescContent.text boundingRectWithSize:CGSizeMake(290, 20000.0f)
                                              options:options
                                           attributes:@{NSFontAttributeName:lbDescContent.font} context:nil].size;
    
    lbDescContent.frame = CGRectMake(10, CGRectGetMaxY(labelDesc.frame), 290, size.height);
    
    UILabel *labelResult = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lbDescContent.frame) + 5, 290, 20)];
    labelResult.backgroundColor = [UIColor clearColor];
    labelResult.textColor = [UIColor blackColor];
    labelResult.text = @"任务结果:";
    labelResult.textAlignment = NSTextAlignmentLeft;
    labelResult.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:labelResult];
    
    CGRect rect = labelResult.frame;
    
    if (_eTaskType == e_task_literature || _eTaskType == e_task_magic)
    {
        UILabel *lbResultContent = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(labelResult.frame), 290, 40)];
        lbResultContent.backgroundColor = [UIColor clearColor];
        lbResultContent.textColor = [UIColor blackColor];
        lbResultContent.text = m_taskInfo.task_result;
        lbResultContent.textAlignment = NSTextAlignmentLeft;
        lbResultContent.font = [UIFont boldSystemFontOfSize:14];
        lbResultContent.numberOfLines = 0;
        [m_scrollView addSubview:lbResultContent];
        
        //size = [lbResultContent.text sizeWithFont:lbResultContent.font constrainedToSize:CGSizeMake(290, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        size = [lbResultContent.text boundingRectWithSize:CGSizeMake(290, 20000.0f)
                                                           options:options
                                                        attributes:@{NSFontAttributeName:lbResultContent.font} context:nil].size;
        lbResultContent.frame = CGRectMake(10, CGRectGetMaxY(labelResult.frame), 290, size.height);
        
        rect = lbResultContent.frame;
    }
    
    if (_eTaskType == e_task_physique) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];

        UILabel *lbBeginTime = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(rect), 115, 20)];
        lbBeginTime.backgroundColor = [UIColor clearColor];
        lbBeginTime.textColor = [UIColor blackColor];
        lbBeginTime.text = @"运动开始时间：";
        lbBeginTime.textAlignment = NSTextAlignmentLeft;
        lbBeginTime.font = [UIFont boldSystemFontOfSize:14];
        [m_scrollView addSubview:lbBeginTime];
        
        NSDate *dateBegin = [NSDate dateWithTimeIntervalSince1970:m_taskInfo.begin_time];
        NSString *strBeginDate = [dateFormatter stringFromDate:dateBegin];
        
        UILabel *lbBeginDate = [[UILabel alloc]initWithFrame:CGRectMake(125, CGRectGetMaxY(rect), 175, 20)];
        lbBeginDate.backgroundColor = [UIColor clearColor];
        lbBeginDate.textColor = [UIColor colorWithRed:239.0 / 255.0 green:162.0 / 255.0 blue:1.0 / 255.0 alpha:1.0];
        lbBeginDate.text = strBeginDate;
        lbBeginDate.textAlignment = NSTextAlignmentLeft;
        lbBeginDate.font = [UIFont boldSystemFontOfSize:14];
        [m_scrollView addSubview:lbBeginDate];
        
        UILabel *lbEndTime = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lbBeginTime.frame), 115, 20)];
        lbEndTime.backgroundColor = [UIColor clearColor];
        lbEndTime.textColor = [UIColor blackColor];
        lbEndTime.text = @"运动结束时间：";
        lbEndTime.textAlignment = NSTextAlignmentLeft;
        lbEndTime.font = [UIFont boldSystemFontOfSize:14];
        [m_scrollView addSubview:lbEndTime];
        
        NSDate *dateEnd = [NSDate dateWithTimeIntervalSince1970:m_taskInfo.end_time];
        NSString *strEndDate = [dateFormatter stringFromDate:dateEnd];
        
        UILabel *lbEndDate = [[UILabel alloc]initWithFrame:CGRectMake(125, CGRectGetMaxY(lbBeginTime.frame), 175, 20)];
        lbEndDate.backgroundColor = [UIColor clearColor];
        lbEndDate.textColor = [UIColor colorWithRed:239.0 / 255.0 green:162.0 / 255.0 blue:1.0 / 255.0 alpha:1.0];
        lbEndDate.text = strEndDate;
        lbEndDate.textAlignment = NSTextAlignmentLeft;
        lbEndDate.font = [UIFont boldSystemFontOfSize:14];
        [m_scrollView addSubview:lbEndDate];
        
        UILabel *lbDistance = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lbEndTime.frame), 115, 20)];
        lbDistance.backgroundColor = [UIColor clearColor];
        lbDistance.textColor = [UIColor blackColor];
        lbDistance.text = @"运动距离(公里)：";
        lbDistance.textAlignment = NSTextAlignmentLeft;
        lbDistance.font = [UIFont boldSystemFontOfSize:14];
        [m_scrollView addSubview:lbDistance];
        
        UILabel *lbDisData = [[UILabel alloc]initWithFrame:CGRectMake(125, CGRectGetMaxY(lbEndTime.frame), 175, 20)];
        lbDisData.backgroundColor = [UIColor clearColor];
        lbDisData.textColor = [UIColor colorWithRed:239.0 / 255.0 green:162.0 / 255.0 blue:1.0 / 255.0 alpha:1.0];
        lbDisData.text = [NSString stringWithFormat:@"%.2f", m_taskInfo.distance / 1000.00];
        lbDisData.textAlignment = NSTextAlignmentLeft;
        lbDisData.font = [UIFont boldSystemFontOfSize:14];
        [m_scrollView addSubview:lbDisData];

        rect = lbDistance.frame;
        
        if ([m_taskInfo.task_pics.data count] == 0 && m_taskInfo.source.length > 0) {
            UILabel *lbSource = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lbDistance.frame), 215, 20)];
            lbSource.backgroundColor = [UIColor clearColor];
            lbSource.textColor = [UIColor blackColor];
            lbSource.text = @"从本机健康App导入，数据来源：";
            lbSource.textAlignment = NSTextAlignmentLeft;
            lbSource.font = [UIFont boldSystemFontOfSize:14];
            [m_scrollView addSubview:lbSource];
            
            UILabel *lbSouData = [[UILabel alloc]initWithFrame:CGRectMake(225, CGRectGetMaxY(lbDistance.frame), 85, 20)];
            lbSouData.backgroundColor = [UIColor clearColor];
            lbSouData.textColor = [UIColor colorWithRed:239.0 / 255.0 green:162.0 / 255.0 blue:1.0 / 255.0 alpha:1.0];
            lbSouData.text = m_taskInfo.source;
            lbSouData.textAlignment = NSTextAlignmentLeft;
            lbSouData.font = [UIFont boldSystemFontOfSize:14];
            [m_scrollView addSubview:lbSouData];
            
            rect = lbSouData.frame;
        }
    }

    UIView *viewTips = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(rect) + 10, CGRectGetWidth(_viewBody.frame), 245)];
    viewTips.tag = TASK_VIEW_TIPS_TAG;
    [m_scrollView addSubview:viewTips];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 92, 214)];
    [imageView setImage:[UIImage imageNamed:@"girl-tips"]];
    [viewTips addSubview:imageView];
    
    NSString *strText = strTips;
    CSButton *btnTipsView = [CSButton buttonWithType:UIButtonTypeCustom];
    btnTipsView.contentEdgeInsets = UIEdgeInsetsMake(10, 15 + imageStatus.size.width, 10, 10);
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
    //size = [strText sizeWithFont:btnTipsView.titleLabel.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    size = [strText boundingRectWithSize:constraint
                                                       options:options
                                                    attributes:@{NSFontAttributeName:btnTipsView.titleLabel.font} context:nil].size;
    
    
    btnTipsView.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + 10,
                                   MAX(CGRectGetMinY(imageView.frame) + (CGRectGetHeight(imageView.frame) - (size.height + 20)) / 2, 15),
                                   CGRectGetWidth(viewTips.frame) - CGRectGetMaxX(imageView.frame) - 30,
                                   size.height + 25);
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(btnTipsView.frame) + 15, CGRectGetMinY(btnTipsView.frame) + 10, imageStatus.size.width, imageStatus.size.height)];
    [imageView1 setImage:imageStatus];
    [viewTips addSubview:imageView1];
    
    viewTips.frame = CGRectMake(0, CGRectGetMaxY(rect) + 10, CGRectGetWidth(_viewBody.frame), MAX(CGRectGetMaxY(imageView.frame), CGRectGetMaxY(btnTipsView.frame)));
    
    if ([m_taskInfo.task_pics.data count] > 0) {
        _lbPicBegin = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(rect), 290, 20)];
        _lbPicBegin.backgroundColor = [UIColor clearColor];
        _lbPicBegin.textColor = [UIColor blackColor];
        _lbPicBegin.text = @"有图有真相:";
        _lbPicBegin.textAlignment = NSTextAlignmentLeft;
        _lbPicBegin.font = [UIFont boldSystemFontOfSize:14];
        [m_scrollView addSubview:_lbPicBegin];
        
        [self generateImageViewByUrls:m_taskInfo.task_pics.data];
        
        CGRect rect = viewTips.frame;
        imageView = [_imgViewArray lastObject];
        
        rect.origin = CGPointMake(0, CGRectGetMaxY(imageView.frame));
        viewTips.frame = rect;
    }
    
    /*CSButton *btnTips = [CSButton buttonWithType:UIButtonTypeCustom];
    btnTips.backgroundColor = UIColor.clearColor;
    btnTips.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    btnTips.titleLabel.textAlignment = NSTextAlignmentLeft;
    [btnTips setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnTips setTitle:@"联系悦动力小秘书" forState:UIControlStateNormal];
    btnTips.frame = CGRectMake(CGRectGetMinX(btnTipsView.frame) + 18, CGRectGetMaxY(btnTipsView.frame) - 25, 120, 20);
    [viewTips addSubview:btnTips];
    [viewTips bringSubviewToFront:btnTips];
    
    btnTips.actionBlock = ^void()
    {
    };
    
    UILabel *labelLine = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(btnTips.frame) + 10, CGRectGetMaxY(btnTips.frame) - 2, 95, 0.8)];
    labelLine.backgroundColor = [UIColor blueColor];
    labelLine.textColor = [UIColor blueColor];
    [viewTips addSubview:labelLine];*/
    
    CSButton *btnFinish = [CSButton buttonWithType:UIButtonTypeCustom];
    btnFinish.frame = CGRectMake(CGRectGetWidth(m_scrollView.frame) - 70, CGRectGetMaxY(viewTips.frame) - 40, 60, 60);
    [btnFinish setBackgroundImage:[UIImage imageNamed:@"PK-table-run-btn"] forState:UIControlStateNormal];
    btnFinish.hidden = (eTaskStatus != e_task_unfinish);
    [m_scrollView addSubview:btnFinish];
    
    /*CSButton *btnFinish = [CSButton buttonWithType:UIButtonTypeCustom];
    btnFinish.frame = CGRectMake((CGRectGetWidth(m_scrollView.frame) - 123) / 2, CGRectGetMaxY(viewTips.frame) + 20, 123, 38);
    [btnFinish setTitle:@"重新尝试" forState:UIControlStateNormal];
    [btnFinish setBackgroundImage:[UIImage imageNamed:@"btn-3-yellow"] forState:UIControlStateNormal];
    [btnFinish setBackgroundImage:[UIImage imageNamed:@"btn-3-grey"] forState:UIControlStateDisabled];
    btnFinish.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [btnFinish setTitleColor:[UIColor colorWithRed:184.0 / 255.0 green:126.0 / 255.0 blue:0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [btnFinish setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnFinish setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    btnFinish.tag = TASK_FINISH_BTN_TAG;
    btnFinish.hidden = (eTaskStatus != e_task_unfinish);
    [m_scrollView addSubview:btnFinish];*/
    
    __weak __typeof(self) weakSelf = self;
    
    btnFinish.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        
        RecordSportViewController *recordSportViewController = [[RecordSportViewController alloc]init];
        recordSportViewController.taskInfo = strongSelf->m_taskInfo;
        [strongSelf.navigationController pushViewController:recordSportViewController animated:YES];
    };
    
    CGSize contentSize = CGSizeMake(CGRectGetWidth(_viewBody.frame), CGRectGetMaxY(btnFinish.frame) + 10);
    [m_scrollView setContentSize:contentSize];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

-(void)onClickImageViewByIndex:(NSUInteger)index
{
    [_photos removeAllObjects];
    
    for (NSString *strUrl in m_taskInfo.task_pics.data) {
        [_photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:strUrl]]];
    }
    
    // Create browser
	MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayDeleteButton = NO;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;
#endif
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:index];
    
    [self.navigationController pushViewController:browser animated:YES];
}

-(void)generateImageViewByUrls:(NSMutableArray*)arrayUrls
{
    for (UIImageView* imageView in _imgViewArray) {
        [imageView removeFromSuperview];
    }
    
    for (CSButton *btnImage in _imgBtnArray) {
        [btnImage removeFromSuperview];
    }
    
    for (UIView *viewFrame in _imgBackFrameArray) {
        [viewFrame removeFromSuperview];
    }
    
    [_imgViewArray removeAllObjects];
    [_imgBtnArray removeAllObjects];
    [_imgBackFrameArray removeAllObjects];
    
    if ([arrayUrls count] == 0) {
        return;
    }
    
    CGRect rectBegin = CGRectMake(10, CGRectGetMaxY(_lbPicBegin.frame) + 10, 60, 60);
    
    for (int i = 0; i < MIN([arrayUrls count], MAX_PUBLISH_PNG_COUNT); i++) {
        if (i % 4 == 0 && i > 0) {
            rectBegin.origin = CGPointMake(10, CGRectGetMaxY(rectBegin) + 10);
        }
        else
        {
            rectBegin.origin = CGPointMake(10 + 77 * i, CGRectGetMinY(rectBegin));
        }
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:rectBegin];
        [imageView sd_setImageWithURL:[NSURL URLWithString:arrayUrls[i]]
                     placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
        imageView.layer.cornerRadius = 5.0;
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        CGRect rect = CGRectMake(CGRectGetMinX(imageView.frame) - 1, CGRectGetMinY(imageView.frame) - 1, CGRectGetWidth(imageView.frame) + 2, CGRectGetHeight(imageView.frame) + 2);
        UIView * backframe = [[UIView alloc] initWithFrame:rect];
        backframe.backgroundColor = [UIColor colorWithRed:236 / 255.0 green:236 / 255.0 blue:236 / 255.0 alpha:1];
        CALayer * layer = backframe.layer;
        [layer setBorderWidth:1.0];
        [layer setBorderColor:[[UIColor colorWithRed:187 / 255.0 green:187 / 255.0 blue:187 / 255.0 alpha:1] CGColor]];
    
        CSButton *btnImage = [CSButton buttonWithType:UIButtonTypeCustom];
        btnImage.frame = imageView.frame;
        btnImage.backgroundColor = [UIColor clearColor];
        [m_scrollView addSubview:btnImage];
        
        __weak __typeof(self) weakSelf = self;
        
        btnImage.actionBlock = ^void()
        {
            __typeof(self) strongSelf = weakSelf;
            NSUInteger nIndex = [strongSelf->_imgViewArray indexOfObject:imageView];
            [strongSelf onClickImageViewByIndex:nIndex];
        };
        
        //[m_scrollView addSubview:backframe];
        [m_scrollView addSubview:imageView];
        [m_scrollView addSubview:btnImage];
        [m_scrollView bringSubviewToFront:imageView];
        [m_scrollView bringSubviewToFront:btnImage];
        
        [_imgBtnArray addObject:btnImage];
        //[_imgBackFrameArray addObject:backframe];
        [_imgViewArray addObject:imageView];
    }
}

@end
