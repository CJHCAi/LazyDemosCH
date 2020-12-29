//
//  MainViewController.m
//  SportForum
//
//  Created by liyuan on 14-8-14.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "MainViewController.h"
#import "UIViewController+SportFormu.h"
#import "JT3DScrollView.h"
#import "UIImageView+WebCache.h"
#import "AccountPreViewController.h"
#import "AlertManager.h"
#import "UIViewLayerProcess.h"
#import "PhotoStackView.h"
#import "MWPhotoBrowser.h"
#import "MobileFriendViewController.h"
#import "RecordSportViewController.h"
#import "ArticlePublicViewController.h"
#import "WebGameViewController.h"
#import "GameViewController.h"
#import "TaskTipsViewController.h"
#import "TaskDetailViewController.h"
#import "TaskRunShareViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>

////For Test
//#import "RunShareViewController.h"
//#import "ThumbShareViewController.h"
//#import "PKShareViewController.h"
//#import "RecordReceiveHeartViewController.h"

@interface MainViewController ()<PhotoStackViewDataSource, PhotoStackViewDelegate, MWPhotoBrowserDelegate, UIAlertViewDelegate>

@end

@implementation MainViewController
{
    UIView *_viewMainFir;
    UILabel *_lbScoreCircle;
    UILabel *_lbTaskCircle;
    UILabel *_lbTaskDesc;
    UILabel *_lbTaskTitle;
    UIImageView *_imgViewBg;
    UIImageView *_imageStatus;
    UIImageView *_imgViewTask;
    UIImageView *_imgViewTips;
    CSButton *_btnFailDetails;
    CSButton * _btnTask;
    UIView *_viewRefer;
    UIView *_viewFriend;
    
    UIView *_viewMainSec;
    PhotoStackView *_photoStack;
    UIPageControl *_pageControl;
    NSMutableArray *_imageData;//图片数据
    
    JT3DScrollView *_scrollView;
    UIViewLayerProcess *_labeledProgressView;
    
    NSTimer * m_timeReward;
    CGFloat m_fProcess;
    
    NSMutableArray* _gameItems;
    NSMutableArray * _photos;
    
    //TasksReferInfo object
    NSMutableArray * _arrReferInfo;
    TasksInfo *_taskInfo;
    
    UIAlertView* _alertView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)bShowFooterViewController {
    return YES;
}

#pragma mark - Create Controls

-(void)initLayout
{
    _scrollView = [[JT3DScrollView alloc]initWithFrame:self.view.frame];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.effect = JT3DScrollViewEffectDepth;
    [self.view addSubview:_scrollView];
    
    [self generateMainFirView];
}

- (void)removeViewFromScroll:(UIView*)view
{
    if (view != nil) {
        [view removeFromSuperview];
        view = nil;
        
        CGFloat width = CGRectGetWidth(_scrollView.frame);

        CGFloat x = _scrollView.subviews.count * width;
        _scrollView.contentSize = CGSizeMake(x, 0);
    }
}

- (UIView*)createCardWithColor
{
    CGFloat width = CGRectGetWidth(_scrollView.frame);
    CGFloat height = CGRectGetHeight(_scrollView.frame);
    
    CGFloat x = _scrollView.subviews.count * width;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, 0, width, height)];
    view.backgroundColor = [UIColor clearColor];
    
    [_scrollView addSubview:view];
    _scrollView.contentSize = CGSizeMake(x + width, 0);
    
    return view;
}

-(void)generateMainFirView
{
    _viewMainFir = [self createCardWithColor];
    
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(_viewMainFir.frame) / 2 - 120, 10, 240, 20)];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = [UIColor blackColor];
    labelTitle.text = @"蜗牛训练营";
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.font = [UIFont boldSystemFontOfSize:16];
    labelTitle.tag = 39999;
    [_viewMainFir addSubview:labelTitle];
    
    _imgViewBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(labelTitle.frame) + 10, CGRectGetWidth(_viewMainFir.frame), 200)];
    [_imgViewBg setImage:[UIImage imageNamedWithWebP:@"run_bg"]];
    [_viewMainFir addSubview:_imgViewBg];

    UIImageView *imageViewUser = [[UIImageView alloc]initWithFrame:CGRectMake(5, CGRectGetMinY(_imgViewBg.frame) + 5, 35, 35)];
    imageViewUser.tag = 40000;
    [_viewMainFir addSubview:imageViewUser];
    
    CSButton *btnUser = [CSButton buttonWithType:UIButtonTypeCustom];
    btnUser.frame = CGRectMake(0, CGRectGetMinY(_imgViewBg.frame), 50, 50);
    btnUser.backgroundColor = [UIColor clearColor];
    btnUser.tag = 40001;
    btnUser.hidden = YES;
    [_viewMainFir addSubview:btnUser];
    
    __weak __typeof(self) weakSelf = self;
    
    btnUser.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        
        UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
        AccountPreViewController *accountPreViewController = [[AccountPreViewController alloc]init];
        accountPreViewController.strUserId = userInfo.userid;
        [strongSelf.navigationController pushViewController:accountPreViewController animated:YES];
    };

    UILabel *lbBoard = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageViewUser.frame) + 5, CGRectGetMidY(imageViewUser.frame) - 10, 100, 20)];
    lbBoard.backgroundColor = [UIColor clearColor];
    lbBoard.font = [UIFont systemFontOfSize:12];
    lbBoard.textColor = [UIColor blackColor];
    lbBoard.textAlignment = NSTextAlignmentLeft;
    lbBoard.tag = 40002;
    [_viewMainFir addSubview:lbBoard];
    
    UIImageView *imgCircle = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(_viewMainFir.frame) - 140.0f) / 2, CGRectGetMinY(_imgViewBg.frame) + 15, 140.0f, 140.0f)];
    [imgCircle setImage:[UIImage imageNamed:@"home-circle-main"]];
    [_viewMainFir addSubview:imgCircle];
    
    _labeledProgressView = [[UIViewLayerProcess alloc] initWithFrame:CGRectMake((CGRectGetWidth(_viewMainFir.frame) - 140.0f) / 2, CGRectGetMinY(imgCircle.frame), 140.0f, 140.0f)];
    [_viewMainFir addSubview:_labeledProgressView];
    
    UILabel *lbTotalTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(_labeledProgressView.frame) - 100 / 2, CGRectGetMidY(_labeledProgressView.frame) - 40, 100, 20)];
    lbTotalTitle.backgroundColor = [UIColor clearColor];
    lbTotalTitle.text = @"总分";
    lbTotalTitle.font = [UIFont systemFontOfSize:12];
    lbTotalTitle.textColor = [UIColor blackColor];
    lbTotalTitle.textAlignment = NSTextAlignmentCenter;
    [_viewMainFir addSubview:lbTotalTitle];
    
    _lbScoreCircle = [[UILabel alloc]init];
    _lbScoreCircle.backgroundColor = [UIColor clearColor];
    _lbScoreCircle.textColor = [UIColor blackColor];
    _lbScoreCircle.font = [UIFont boldSystemFontOfSize:18];
    _lbScoreCircle.frame = CGRectMake(CGRectGetMidX(_labeledProgressView.frame) - 100 / 2, CGRectGetMidY(_labeledProgressView.frame) - 15, 100, 30);
    _lbScoreCircle.textAlignment = NSTextAlignmentCenter;
    [_viewMainFir addSubview:_lbScoreCircle];
    
    _lbTaskCircle = [[UILabel alloc]init];
    _lbTaskCircle.backgroundColor = [UIColor clearColor];
    _lbTaskCircle.textColor = [UIColor blackColor];
    _lbTaskCircle.font = [UIFont systemFontOfSize:12];
    _lbTaskCircle.frame = CGRectMake(CGRectGetMidX(_labeledProgressView.frame) - 100 / 2, CGRectGetMidY(_labeledProgressView.frame) + 18, 100, 20);
    _lbTaskCircle.textAlignment = NSTextAlignmentCenter;
    [_viewMainFir addSubview:_lbTaskCircle];
    
    CSButton *btnTaskDetails = [CSButton buttonWithType:UIButtonTypeCustom];
    [btnTaskDetails setImage:[UIImage imageNamed:@"home-task-details"] forState:UIControlStateNormal];
    btnTaskDetails.frame = CGRectMake((CGRectGetWidth(_viewMainFir.frame) - 30) / 2, CGRectGetMaxY(_labeledProgressView.frame) + 5, 30, 30);
    [_viewMainFir addSubview:btnTaskDetails];
    
    btnTaskDetails.actionBlock = ^(void)
    {
        __typeof(self) strongSelf = weakSelf;
        
        TaskDetailViewController *taskDetailViewController = [[TaskDetailViewController alloc]init];
        taskDetailViewController.taskId = strongSelf->_taskInfo.task_id;
        taskDetailViewController.eTaskType = [CommonFunction ConvertStringToTaskType:strongSelf->_taskInfo.task_type];
        taskDetailViewController.duration = strongSelf->_taskInfo.duration;
        taskDetailViewController.distance = strongSelf->_taskInfo.distance;
        [strongSelf.navigationController pushViewController:taskDetailViewController animated:YES];
        
        
        //        PKShareViewController *pkShareViewController = [[PKShareViewController alloc]init];
        //        pkShareViewController.strSendId = @"1427792416928";
        //        [strongSelf.navigationController pushViewController:pkShareViewController animated:YES];
    };

    CSButton *btnVideo = [CSButton buttonWithType:UIButtonTypeCustom];
    [btnVideo setImage:[UIImage imageNamed:@"home-video"] forState:UIControlStateNormal];
    btnVideo.frame = CGRectMake(CGRectGetMaxX(btnTaskDetails.frame) + 40, CGRectGetMaxY(_labeledProgressView.frame) + 5, 30, 30);
    [_viewMainFir addSubview:btnVideo];
    
    btnVideo.actionBlock = ^(void)
    {
        __typeof(self) strongSelf = weakSelf;
        
        if (strongSelf->_taskInfo.task_video.length > 0) {
            [strongSelf onClickVideoPreView:strongSelf->_taskInfo.task_video];
        }
        
//        RunShareViewController *runShareViewController = [[RunShareViewController alloc]init];
//         runShareViewController.strSendId = @"1436769721143";
//         runShareViewController.strRecordId = @"55a3665281b6031edd000002";
//         runShareViewController.strLocAddr = @"中国上海市浦东新区张江镇张江晨晖路930号";
//         runShareViewController.lRunBeginTime = 1437132300;
//         runShareViewController.strImgAddr = @"http://172.24.222.42:8082/2,0d1de237a812";
//         runShareViewController.strLatlng = @"31.2022,121.6044";
//         [strongSelf.navigationController pushViewController:runShareViewController animated:YES];
    };
    
    CSButton *btnTipInfo = [CSButton buttonWithType:UIButtonTypeCustom];
    [btnTipInfo setImage:[UIImage imageNamed:@"home-tip-info"] forState:UIControlStateNormal];
    btnTipInfo.frame = CGRectMake(CGRectGetMinX(btnTaskDetails.frame) - 70, CGRectGetMaxY(_labeledProgressView.frame) + 5, 30, 30);
    [_viewMainFir addSubview:btnTipInfo];
    
    btnTipInfo.actionBlock = ^(void)
    {
        __typeof(self) strongSelf = weakSelf;
        
        if (strongSelf->_taskInfo != nil && strongSelf->_taskInfo.task_tip.length > 0) {
            TaskTipsViewController *taskTipsViewController = [[TaskTipsViewController alloc]init];
            taskTipsViewController.strTips = strongSelf->_taskInfo.task_tip;
            [strongSelf.navigationController pushViewController:taskTipsViewController animated:YES];
        }
        
//        ThumbShareViewController *thumbShareViewController = [[ThumbShareViewController alloc]init];
//        thumbShareViewController.strSendId = @"1427792416928";
//        thumbShareViewController.strArticleId = @"559633da81b60344d400000d";//;@"559dec9d81b60333cd000008"
//        [strongSelf.navigationController pushViewController:thumbShareViewController animated:YES];
    };
    
    _imgViewTask = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_viewMainFir.frame) / 2 - 55, CGRectGetMaxY(_imgViewBg.frame) + 5, 25, 25)];
    [_imgViewTask setImage:[UIImage imageNamed:@"me-level-runner"]];
    [_viewMainFir addSubview:_imgViewTask];
    
    _lbTaskTitle = [[UILabel alloc]init];
    _lbTaskTitle.backgroundColor = [UIColor clearColor];
    _lbTaskTitle.text = @"跑步任务";
    _lbTaskTitle.textColor = [UIColor darkGrayColor];
    _lbTaskTitle.font = [UIFont boldSystemFontOfSize:15];
    _lbTaskTitle.frame = CGRectMake(CGRectGetWidth(_viewMainFir.frame) / 2 - 25, CGRectGetMinY(_imgViewTask.frame), 100, 25);
    _lbTaskTitle.textAlignment = NSTextAlignmentLeft;
    [_viewMainFir addSubview:_lbTaskTitle];
    
    UIImageView *imgTask = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(_viewMainFir.frame) - 263) / 2, CGRectGetMaxY(_imgViewTask.frame) - 20, 263, 118)];
    [imgTask setImage:[UIImage imageNamed:@"dialogbox"]];
    [_viewMainFir addSubview:imgTask];
    
    _imageStatus = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_viewMainFir.frame) / 2 - 12, CGRectGetMinY(imgTask.frame) + 35, 24, 24)];
    _imageStatus.hidden = YES;
    [_viewMainFir addSubview:_imageStatus];
    
    _lbTaskDesc = [[UILabel alloc]init];
    _lbTaskDesc.backgroundColor = [UIColor clearColor];
    _lbTaskDesc.text = @"慢跑1分钟，行走2分钟，重复8次，距离2公里，时长25分钟";
    _lbTaskDesc.textColor = [UIColor darkGrayColor];
    _lbTaskDesc.font = [UIFont boldSystemFontOfSize:14];
    _lbTaskDesc.frame = CGRectMake(CGRectGetMinX(imgTask.frame) + 15, CGRectGetMinY(imgTask.frame) + 15, CGRectGetWidth(_viewMainFir.frame) - 2 * (CGRectGetMinX(imgTask.frame) + 15), 60);
    _lbTaskDesc.textAlignment = NSTextAlignmentCenter;
    _lbTaskDesc.numberOfLines = 0;
    [_viewMainFir addSubview:_lbTaskDesc];
    
    _imgViewTips = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgTask.frame) - 25, CGRectGetMaxY(_imgViewBg.frame) - 20, 30, 30)];
    [_imgViewTips setImage:[UIImage imageNamed:@"level-snail"]];
    [_viewMainFir addSubview:_imgViewTips];
    
    _btnFailDetails = [CSButton buttonWithType:UIButtonTypeCustom];
    [_btnFailDetails setImage:[UIImage imageNamed:@"home-task-details"] forState:UIControlStateNormal];
    _btnFailDetails.frame = CGRectMake(CGRectGetMaxX(btnVideo.frame) + 30, CGRectGetMaxY(_labeledProgressView.frame) + 5, 30, 30);
    [_viewMainFir addSubview:_btnFailDetails];
    _btnFailDetails.hidden = YES;
    
    _btnFailDetails.actionBlock = btnTaskDetails.actionBlock;
    
    UIImage * imgButton = [UIImage imageNamed:@"btn-3-blue"];
    _btnTask = [[CSButton alloc] initNormalButtonTitle:@"开始任务" Rect:CGRectMake((CGRectGetWidth(_viewMainFir.frame) - 123) / 2, CGRectGetMaxY(imgTask.frame) + 15, 123, 38)];
    [_btnTask setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnTask setBackgroundImage:imgButton forState:UIControlStateNormal];
    [_btnTask setBackgroundImage:[UIImage imageNamed:@"btn-3-grey"] forState:UIControlStateDisabled];
    _btnTask.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_btnTask setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
    [_viewMainFir addSubview:_btnTask];
    
    _btnTask.actionBlock = ^(void)
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf onClickStartTaskBtn];
        
        //[JDStatusBarNotification showWithStatus:@"约跑邀请已发送成功!" dismissAfter:5.0 styleName:JDStatusBarStyleError];
        
        /*RecordReceiveHeartViewController * recordReceiveHeartViewController = [[RecordReceiveHeartViewController alloc]init];
        recordReceiveHeartViewController.strSendId = @"1436769721143";
        recordReceiveHeartViewController.strRecordId = @"55a3665281b6031edd000002";
        [strongSelf.navigationController pushViewController:recordReceiveHeartViewController animated:YES];
        
        RunShareViewController *runShareViewController = [[RunShareViewController alloc]init];
        runShareViewController.strSendId = @"1436769721143";
        runShareViewController.strRecordId = @"55a3665281b6031edd000002";
        runShareViewController.strLocAddr = @"中国上海市浦东新区张江镇张江晨晖路930号";
        runShareViewController.lRunBeginTime = 1437132300;
        runShareViewController.strImgAddr = @"http://172.24.222.42:8082/2,0d1de237a812";
        runShareViewController.strLatlng = @"121.6044,31.2022";
        [strongSelf.navigationController pushViewController:runShareViewController animated:YES];
        
        ThumbShareViewController *thumbShareViewController = [[ThumbShareViewController alloc]init];
        thumbShareViewController.strSendId = @"1427792416928";
        thumbShareViewController.strArticleId = @"559633da81b60344d400000d";//;@"559dec9d81b60333cd000008"
        [strongSelf.navigationController pushViewController:thumbShareViewController animated:YES];
        
        PKShareViewController *pkShareViewController = [[PKShareViewController alloc]init];
        pkShareViewController.strSendId = @"1427792416928";
        [strongSelf.navigationController pushViewController:pkShareViewController animated:YES];*/
    };
    
    /*UILabel * lbPhysique = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageViewUser.frame) + 10, CGRectGetMinY(imageViewUser.frame) + 5, (CGRectGetWidth(_viewMainFir.frame) - (CGRectGetMaxX(imageViewUser.frame) + 10 + 5)) / 4, 20)];
    lbPhysique.backgroundColor = [UIColor clearColor];
    lbPhysique.textAlignment = NSTextAlignmentCenter;
    lbPhysique.textColor = [UIColor blackColor];
    lbPhysique.font = [UIFont boldSystemFontOfSize:16];
    lbPhysique.text = @"体 魄";
    [_viewMainFir addSubview:lbPhysique];
    
    UILabel * lbLiterature = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbPhysique.frame), CGRectGetMinY(imageViewUser.frame) + 5, CGRectGetWidth(lbPhysique.frame), 20)];
    lbLiterature.backgroundColor = [UIColor clearColor];
    lbLiterature.textAlignment = NSTextAlignmentCenter;
    lbLiterature.textColor = [UIColor blackColor];
    lbLiterature.font = [UIFont boldSystemFontOfSize:16];
    lbLiterature.text = @"文 学";
    [_viewMainFir addSubview:lbLiterature];
    
    UILabel * lbMagic = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbLiterature.frame), CGRectGetMinY(imageViewUser.frame) + 5, CGRectGetWidth(lbPhysique.frame), 20)];
    lbMagic.backgroundColor = [UIColor clearColor];
    lbMagic.textAlignment = NSTextAlignmentCenter;
    lbMagic.textColor = [UIColor blackColor];
    lbMagic.font = [UIFont boldSystemFontOfSize:16];
    lbMagic.text = @"魔 法";
    [_viewMainFir addSubview:lbMagic];
    
    UILabel * lbTotal = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbMagic.frame), CGRectGetMinY(imageViewUser.frame) + 5, CGRectGetWidth(lbPhysique.frame), 20)];
    lbTotal.backgroundColor = [UIColor clearColor];
    lbTotal.textAlignment = NSTextAlignmentCenter;
    lbTotal.textColor = [UIColor blackColor];
    lbTotal.font = [UIFont boldSystemFontOfSize:16];
    lbTotal.text = @"总 分";
    [_viewMainFir addSubview:lbTotal];
    
    UILabel * lbPhysiqueValue = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lbPhysique.frame), CGRectGetMaxY(lbPhysique.frame) + 2, CGRectGetWidth(lbPhysique.frame), 20)];
    lbPhysiqueValue.backgroundColor = [UIColor clearColor];
    lbPhysiqueValue.textAlignment = NSTextAlignmentCenter;
    lbPhysiqueValue.textColor = [UIColor darkGrayColor];
    lbPhysiqueValue.font = [UIFont boldSystemFontOfSize:13];
    lbPhysiqueValue.tag = 40002;
    [_viewMainFir addSubview:lbPhysiqueValue];
    
    UILabel * lbLiteratureValue = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lbLiterature.frame), CGRectGetMaxY(lbLiterature.frame) + 2, CGRectGetWidth(lbLiterature.frame), 20)];
    lbLiteratureValue.backgroundColor = [UIColor clearColor];
    lbLiteratureValue.textAlignment = NSTextAlignmentCenter;
    lbLiteratureValue.textColor = [UIColor darkGrayColor];
    lbLiteratureValue.font = [UIFont boldSystemFontOfSize:13];
    lbLiteratureValue.tag = 40003;
    [_viewMainFir addSubview:lbLiteratureValue];
    
    UILabel * lbMagicValue = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lbMagic.frame), CGRectGetMaxY(lbMagic.frame) + 2, CGRectGetWidth(lbMagic.frame), 20)];
    lbMagicValue.backgroundColor = [UIColor clearColor];
    lbMagicValue.textAlignment = NSTextAlignmentCenter;
    lbMagicValue.textColor = [UIColor darkGrayColor];
    lbMagicValue.font = [UIFont boldSystemFontOfSize:13];
    lbMagicValue.tag = 40004;
    [_viewMainFir addSubview:lbMagicValue];
    
    UILabel * lbTotalValue = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lbTotal.frame), CGRectGetMaxY(lbTotal.frame) + 2, CGRectGetWidth(lbTotal.frame), 20)];
    lbTotalValue.backgroundColor = [UIColor clearColor];
    lbTotalValue.textAlignment = NSTextAlignmentCenter;
    lbTotalValue.textColor = [UIColor darkGrayColor];
    lbTotalValue.font = [UIFont boldSystemFontOfSize:13];
    lbTotalValue.tag = 40005;
    [_viewMainFir addSubview:lbTotalValue];
    
    UILabel * lbPhysiqueValueAdd = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lbPhysiqueValue.frame), CGRectGetMaxY(lbPhysiqueValue.frame) + 2, CGRectGetWidth(lbPhysiqueValue.frame), 20)];
    lbPhysiqueValueAdd.backgroundColor = [UIColor clearColor];
    lbPhysiqueValueAdd.textAlignment = NSTextAlignmentCenter;
    lbPhysiqueValueAdd.textColor = [UIColor darkGrayColor];
    lbPhysiqueValueAdd.font = [UIFont boldSystemFontOfSize:13];
    lbPhysiqueValueAdd.tag = 40006;
    [_viewMainFir addSubview:lbPhysiqueValueAdd];
    
    UILabel * lbLiteratureValueAdd = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lbLiteratureValue.frame), CGRectGetMaxY(lbLiteratureValue.frame) + 2, CGRectGetWidth(lbLiteratureValue.frame), 20)];
    lbLiteratureValueAdd.backgroundColor = [UIColor clearColor];
    lbLiteratureValueAdd.textAlignment = NSTextAlignmentCenter;
    lbLiteratureValueAdd.textColor = [UIColor darkGrayColor];
    lbLiteratureValueAdd.font = [UIFont boldSystemFontOfSize:13];
    lbLiteratureValueAdd.tag = 40007;
    [_viewMainFir addSubview:lbLiteratureValueAdd];
    
    UILabel * lbMagicValueAdd = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lbMagicValue.frame), CGRectGetMaxY(lbMagicValue.frame) + 2, CGRectGetWidth(lbMagicValue.frame), 20)];
    lbMagicValueAdd.backgroundColor = [UIColor clearColor];
    lbMagicValueAdd.textAlignment = NSTextAlignmentCenter;
    lbMagicValueAdd.textColor = [UIColor darkGrayColor];
    lbMagicValueAdd.font = [UIFont boldSystemFontOfSize:13];
    lbMagicValueAdd.tag = 40008;
    [_viewMainFir addSubview:lbMagicValueAdd];
    
    UILabel * lbTotalValueAdd = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lbTotalValue.frame), CGRectGetMaxY(lbTotalValue.frame) + 2, CGRectGetWidth(lbTotalValue.frame), 20)];
    lbTotalValueAdd.backgroundColor = [UIColor clearColor];
    lbTotalValueAdd.textAlignment = NSTextAlignmentCenter;
    lbTotalValueAdd.textColor = [UIColor darkGrayColor];
    lbTotalValueAdd.font = [UIFont boldSystemFontOfSize:13];
    lbTotalValueAdd.tag = 40009;
    [_viewMainFir addSubview:lbTotalValueAdd];*/
}

-(void)updateMainFirView
{
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    SysConfig *sysConfig = [[ApplicationContext sharedInstance]systemConfigInfo];
    
    if (userInfo == nil || sysConfig == nil) {
        return;
    }
    
    NSUInteger nCurLevel = userInfo.proper_info.rankLevel;
    m_fProcess = (userInfo.proper_info.rankscore - [sysConfig.level_score.data[nCurLevel - 1] unsignedIntValue]) * 1.00 / ([sysConfig.level_score.data[nCurLevel] unsignedIntValue] - [sysConfig.level_score.data[nCurLevel - 1] unsignedIntValue]);
    [_labeledProgressView setPercent:m_fProcess animated:YES];

    _lbScoreCircle.text = [NSString stringWithFormat:@"%ld", userInfo.proper_info.rankscore];
    _lbTaskCircle.text = [NSString stringWithFormat:@"目标 %u", [sysConfig.level_score.data[nCurLevel] unsignedIntValue]];
    
    NSUInteger nLevel = userInfo.proper_info.rankLevel;
    NSUInteger nHorseCount = nLevel / 25;
    NSUInteger nRabbitCount = (nLevel - nHorseCount * 25) / 5;
    //NSUInteger nSnailCount = nLevel - nHorseCount * 25 - nRabbitCount * 5;
    
    NSString *strLevelImg = @"level-snail";
    UILabel *labelTitle = (UILabel*)[_viewMainFir viewWithTag:39999];
    
    if (nHorseCount > 0) {
        labelTitle.text = @"骏马训练营";
        strLevelImg = @"level-horse";
    }
    else if(nRabbitCount > 0)
    {
        labelTitle.text = @"懒兔训练营";
        strLevelImg = @"level-rabbit";
    }
    else
    {
        labelTitle.text = @"蜗牛训练营";
        strLevelImg = @"level-snail";
    }
    
    [_imgViewTips setImage:[UIImage imageNamed:strLevelImg]];
    
    UIImageView *imageViewUser = (UIImageView*)[_viewMainFir viewWithTag:40000];
    CSButton *btnUser = (CSButton*)[_viewMainFir viewWithTag:40001];
    UILabel *lbBoard = (UILabel*)[_viewMainFir viewWithTag:40002];
    
    [imageViewUser sd_setImageWithURL:[NSURL URLWithString:userInfo.profile_image]
                     placeholderImage:[UIImage imageNamed:@"image-placeholder"] withInset:0];
    btnUser.hidden = NO;
    lbBoard.text = [NSString stringWithFormat:@"第%ld名", userInfo.score_rank];
    /*
     UILabel * lbPhysiqueValue = (UILabel*)[_viewMainFir viewWithTag:40002];
     UILabel * lbLiteratureValue = (UILabel*)[_viewMainFir viewWithTag:40003];
     UILabel * lbMagicValue = (UILabel*)[_viewMainFir viewWithTag:40004];
     UILabel * lbTotalValue = (UILabel*)[_viewMainFir viewWithTag:40005];
     UILabel * lbPhysiqueValueAdd = (UILabel*)[_viewMainFir viewWithTag:40006];
     UILabel * lbLiteratureValueAdd = (UILabel*)[_viewMainFir viewWithTag:40007];
     UILabel * lbMagicValueAdd = (UILabel*)[_viewMainFir viewWithTag:40008];
     UILabel * lbTotalValueAdd = (UILabel*)[_viewMainFir viewWithTag:40009];
    lbPhysiqueValue.text = @"第4名";
    lbLiteratureValue.text = @"第5名";
    lbMagicValue.text = @"第10名";
    lbTotalValue.text = @"第5名";
    
    lbPhysiqueValueAdd.text = @"+10";
    lbPhysiqueValueAdd.textColor = [UIColor redColor];
    
    lbLiteratureValueAdd.text = @"+2";
    lbLiteratureValueAdd.textColor = [UIColor redColor];
    
    lbMagicValueAdd.text = @"-5";
    lbMagicValueAdd.textColor = [UIColor colorWithRed:103.0 / 255.0 green:201.0 / 255.0 blue:155.0 / 255.0 alpha:1.0];
    
    lbTotalValueAdd.text = @"-2";
    lbTotalValueAdd.textColor = [UIColor colorWithRed:103.0 / 255.0 green:201.0 / 255.0 blue:155.0 / 255.0 alpha:1.0];*/
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROCESS_TO_WATCH object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:@(m_fProcess * 100), @"LevelProcess", @(userInfo.proper_info.rankscore), @"CurrentScore", @([sysConfig.level_score.data[nCurLevel] unsignedIntValue]), @"LevelTotal", nil]];
}

-(void)generateMainSecView
{
    _viewMainSec = [self createCardWithColor];
    
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(_viewMainSec.frame) / 2 - 120, 10, 240, 20)];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = [UIColor blackColor];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.font = [UIFont boldSystemFontOfSize:16];
    labelTitle.tag = 42001;
    [_viewMainSec addSubview:labelTitle];
    
    _photoStack = [[PhotoStackView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(labelTitle.frame) + 15, CGRectGetWidth(_viewMainSec.frame) - 20, 240)];
    _photoStack.dataSource = self;
    _photoStack.delegate = self;
    [_viewMainSec addSubview:_photoStack];
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_photoStack.frame) + 30, CGRectGetWidth(_viewMainSec.frame) - 40, 15)];
    //设置颜色
    _pageControl.pageIndicatorTintColor=[UIColor colorWithRed:193/255.0 green:219/255.0 blue:249/255.0 alpha:1];
    //设置当前页颜色
    _pageControl.currentPageIndicatorTintColor=[UIColor colorWithRed:0 green:150/255.0 blue:1 alpha:1];
    [_viewMainSec addSubview:_pageControl];

    UIView *viewBg = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(labelTitle.frame) + 5, CGRectGetWidth(_viewMainSec.frame), 230 + 30 + 36 + 60)];
    viewBg.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
    [_viewMainSec addSubview:viewBg];
    [_viewMainSec sendSubviewToBack:viewBg];
    
    UIImageView *imgViewProfile = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_photoStack.frame) + 20, 55, 55)];
    imgViewProfile.tag = 42002;
    [_viewMainSec addSubview:imgViewProfile];
    
    UIImageView *sexTypeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(75, CGRectGetMinY(imgViewProfile.frame), 45, 20)];
    sexTypeImageView.backgroundColor = [UIColor clearColor];
    sexTypeImageView.tag = 42003;
    [_viewMainSec addSubview:sexTypeImageView];
    
    UILabel *lbAge = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(sexTypeImageView.frame) - 25, CGRectGetMinY(imgViewProfile.frame) + 2, 20, 15)];
    lbAge.backgroundColor = [UIColor clearColor];
    lbAge.textColor = [UIColor whiteColor];
    lbAge.font = [UIFont systemFontOfSize:12];
    lbAge.textAlignment = NSTextAlignmentRight;
    lbAge.tag = 42004;
    [_viewMainSec addSubview:lbAge];
    
    UIImageView *imgViePhone = [[UIImageView alloc]initWithFrame:CGRectZero];
    [imgViePhone setImage:[UIImage imageNamed:@"phone-verified-small"]];
    imgViePhone.backgroundColor = [UIColor clearColor];
    imgViePhone.tag = 42005;
    imgViePhone.hidden = YES;
    [_viewMainSec addSubview:imgViePhone];
    
    UIImageView *imgVieCoach = [[UIImageView alloc]initWithFrame:CGRectZero];
    [imgVieCoach setImage:[UIImage imageNamed:@"other-info-coach-icon"]];
    imgVieCoach.backgroundColor = [UIColor clearColor];
    imgVieCoach.tag = 42006;
    imgVieCoach.hidden = YES;
    [_viewMainSec addSubview:imgVieCoach];
    
    UIImageView * imgLoc = [[UIImageView alloc] initWithFrame:CGRectZero];
    imgLoc.image = [UIImage imageNamed:@"location-icon"];
    imgLoc.tag = 42007;
    imgLoc.hidden = NO;
    [_viewMainSec addSubview:imgLoc];
    
    UILabel *lbLoc = [[UILabel alloc] initWithFrame:CGRectZero];
    lbLoc.backgroundColor = [UIColor clearColor];
    lbLoc.font = [UIFont systemFontOfSize:13];
    lbLoc.textColor = [UIColor darkGrayColor];
    lbLoc.tag = 42008;
    lbLoc.hidden = YES;
    [_viewMainSec addSubview:lbLoc];
    
    UILabel *lbDesc = [[UILabel alloc] initWithFrame:CGRectMake(75, CGRectGetMaxY(sexTypeImageView.frame) + 5, CGRectGetWidth(_viewMainSec.frame) - 80, 25)];
    lbDesc.backgroundColor = [UIColor clearColor];
    lbDesc.font = [UIFont boldSystemFontOfSize:15];
    lbDesc.textColor = [UIColor darkGrayColor];
    lbDesc.textAlignment = NSTextAlignmentLeft;
    lbDesc.tag = 42009;
    [_viewMainSec addSubview:lbDesc];

    UILabel *lbRate = [[UILabel alloc] initWithFrame:CGRectMake(75, CGRectGetMaxY(lbDesc.frame) + 15, CGRectGetWidth(_viewMainSec.frame) - 80, 20)];
    lbRate.backgroundColor = [UIColor clearColor];
    lbRate.font = [UIFont systemFontOfSize:13];
    lbRate.textColor = [UIColor darkGrayColor];
    lbRate.textAlignment = NSTextAlignmentLeft;
    lbRate.tag = 42020;
    [_viewMainSec addSubview:lbRate];
    
    CSButton *btnPK = [CSButton buttonWithType:UIButtonTypeCustom];
    btnPK.backgroundColor = [UIColor clearColor];
    [btnPK setImage:[UIImage imageNamed:@"home-challenge"] forState:UIControlStateNormal];
    [btnPK setTitle:@"PK" forState:UIControlStateNormal];
    [btnPK setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btnPK.frame = CGRectMake(30, CGRectGetMaxY(viewBg.frame) + 20, 50, 80);
    btnPK.tag = 42012;
    btnPK.titleLabel.font = [UIFont boldSystemFontOfSize:14];//title字体大小
    btnPK.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnPK setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 30, 0)];
    [btnPK setTitleEdgeInsets:UIEdgeInsetsMake(60, -btnPK.titleLabel.bounds.size.width - 65, 0, 0)];
    [_viewMainSec addSubview:btnPK];
    
    CSButton *btnRun = [CSButton buttonWithType:UIButtonTypeCustom];
    btnRun.backgroundColor = [UIColor clearColor];
    [btnRun setImage:[UIImage imageNamed:@"home-run-together"] forState:UIControlStateNormal];
    [btnRun setTitle:@"约跑" forState:UIControlStateNormal];
    [btnRun setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btnRun.frame = CGRectMake(CGRectGetWidth(_viewMainSec.frame) / 2 - 25, CGRectGetMinY(btnPK.frame), 50, 80);
    btnRun.tag = 42013;
    btnRun.titleLabel.font = [UIFont boldSystemFontOfSize:14];//title字体大小
    btnRun.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnRun setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 30, 0)];
    [btnRun setTitleEdgeInsets:UIEdgeInsetsMake(60, -btnRun.titleLabel.bounds.size.width - 65, 0, 0)];
    [_viewMainSec addSubview:btnRun];
    
    CSButton *btnPass = [CSButton buttonWithType:UIButtonTypeCustom];
    btnPass.backgroundColor = [UIColor clearColor];
    [btnPass setImage:[UIImage imageNamed:@"home-pass"] forState:UIControlStateNormal];
    [btnPass setTitle:@"飘过" forState:UIControlStateNormal];
    [btnPass setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btnPass.frame = CGRectMake(CGRectGetWidth(_viewMainSec.frame) - 100, CGRectGetMinY(btnPK.frame) - 10, 70, 100);
    btnPass.tag = 42014;
    btnPass.titleLabel.font = [UIFont boldSystemFontOfSize:14];//title字体大小
    btnPass.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnPass setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 40, 0)];
    [btnPass setTitleEdgeInsets:UIEdgeInsetsMake(50, -btnPass.titleLabel.bounds.size.width - 55, 0, 0)];
    [_viewMainSec addSubview:btnPass];

    __weak __typeof(self) weakSelf = self;
    
    btnPK.actionBlock = ^()
    {
        __typeof(self) strongSelf = weakSelf;
        
        if ([strongSelf checkFirstActionFree]) {
            [strongSelf taskShared:YES ShareType:e_accept_pk];
        }
        else
        {
            if ([strongSelf checkFirstActionPopWin]) {
                strongSelf->_alertView = [[UIAlertView alloc] initWithTitle:@"邀请" message:@"今天免费次数已用完，本次邀请会花费1个金币，确认邀请吗？" delegate:strongSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                strongSelf->_alertView.tag = 10;
                [strongSelf->_alertView show];
            }
            else
            {
                [strongSelf taskShared:NO ShareType:e_accept_pk];
            }
        }
    };
    
    btnPass.actionBlock = ^()
    {
        __typeof(self) strongSelf = weakSelf;
    
        [[CommonUtility sharedInstance]playAudioFromName:@"ignore.wav"];
        
        TasksReferInfo *tasksReferInfo = strongSelf->_arrReferInfo.firstObject;
        
        id processWin = [AlertManager showCommonProgressInView:strongSelf->_viewMainSec];
        
        [[SportForumAPI sharedInstance]tasksReferralPassByUserId:tasksReferInfo.userid FinishedBlock:^(int errorCode)
         {
             [AlertManager dissmiss:processWin];
             
             [strongSelf->_arrReferInfo removeObjectAtIndex:0];
             [strongSelf reloadReferralControls:YES];
         }];

//        [strongSelf->_arrReferInfo removeObjectAtIndex:0];
//        [strongSelf reloadReferralControls:YES];
    };
}

-(NSString*)reGenerateLocPosiStr:(TasksReferInfo*)tasksReferInfo
{
    float dMyLon = [[ApplicationContext sharedInstance] accountInfo].longitude;
    float dMyLat = [[ApplicationContext sharedInstance] accountInfo].latitude;
    float dOtherLon =  tasksReferInfo.longitude;
    float dOtherLat = tasksReferInfo.latitude;
    double dDistance = [[CommonUtility sharedInstance] getDistanceBySelfLon:dMyLon SelfLantitude:dMyLat OtherLon:dOtherLon OtherLat:dOtherLat];
    
    NSString * strDate = @"";
    
    if (tasksReferInfo.last_login_time > 0) {
        NSDate * dateLastLogin = [NSDate dateWithTimeIntervalSince1970:tasksReferInfo.last_login_time];
        NSDate * today = [NSDate date];
        long long llInterval = [today timeIntervalSinceDate:dateLastLogin];
        long long llMinute = llInterval / 60;
        long long llHour = llInterval / 3600;
        
        if (llMinute == 0) {
            strDate = @"刚刚登录";
        }
        
        if(llMinute > 0)
        {
            strDate = [NSString stringWithFormat:@"%lld分钟前", llMinute];
        }
        
        if(llMinute >= 60)
        {
            strDate = [NSString stringWithFormat:@"%lld小时前", llHour];
        }
        
        if(llHour >= 24)
        {
            strDate = [NSString stringWithFormat:@"%lld天前", llHour / 24];
        }
    }
    
    if (dDistance < 1000 && dDistance >= 0) {
        if (strDate.length > 0) {
            strDate = [NSString stringWithFormat:@"%@,距离%.f米", strDate, dDistance];
        }
        else
        {
            strDate = [NSString stringWithFormat:@"距离%.f米", dDistance];
        }
    }
    else if(dDistance >= 1000)
    {
        if (strDate.length > 0) {
            strDate = [NSString stringWithFormat:@"%@, 距离%.f公里", strDate, dDistance / 1000];
        }
        else
        {
            strDate = [NSString stringWithFormat:@"距离%.f公里", dDistance / 1000];
        }
    }
    
    return strDate;
}

-(void)updateMainSecView
{
    TasksReferInfo *tasksReferInfo = _arrReferInfo.firstObject;

    NSString *strTitle = @"任务即将开始的Ta";
    e_task_status eTaskStatus = [CommonFunction ConvertStringToTaskStatusType:_taskInfo.task_status];
    switch (eTaskStatus) {
        case e_task_normal:
            strTitle = @"任务即将开始的Ta";
            break;
        case e_task_finish:
            strTitle = @"任务也已完成的Ta";
            break;
        case e_task_unfinish:
            strTitle = @"任务也未完成的Ta";
            break;
        case e_task_authentication:
            strTitle = @"任务也在审核中的Ta";
            break;
        default:
            break;
    }
    
    UILabel *labelTitle = (UILabel*)[_viewMainSec viewWithTag:42001];
    labelTitle.text = strTitle;
    
    UIImageView *imgViewProfile = (UIImageView*)[_viewMainSec viewWithTag:42002];
    [imgViewProfile sd_setImageWithURL:[NSURL URLWithString:tasksReferInfo.profile_image]
                      placeholderImage:[UIImage imageNamed:@"image-placeholder"] withInset:0];

    UIImageView *sexTypeImageView = (UIImageView*)[_viewMainSec viewWithTag:42003];
    [sexTypeImageView setImage:[UIImage imageNamed:([CommonFunction ConvertStringToSexType:tasksReferInfo.sex_type] == e_sex_male ? @"gender-male" : @"gender-female")]];
    
    UILabel *lbAge = (UILabel*)[_viewMainSec viewWithTag:42004];
    lbAge.text = [[CommonUtility sharedInstance]convertBirthdayToAge:tasksReferInfo.birthday];

    /*CGFloat fStartPoint = CGRectGetMaxX(sexTypeImageView.frame) + 5;
    
    if (tasksReferInfo.phone_number.length > 0) {
        UIImageView *imgViePhone = (UIImageView*)[_viewMainSec viewWithTag:42005];
        [imgViePhone setImage:[UIImage imageNamed:@"phone-verified-small"]];
        imgViePhone.hidden = NO;
        imgViePhone.frame = CGRectMake(fStartPoint, CGRectGetMinY(sexTypeImageView.frame), 8, 14);
        fStartPoint = CGRectGetMaxX(imgViePhone.frame) + 2;
    }
    
    if ([userInfo.actor isEqualToString:@"coach"]) {
        UIImageView *imgVieCoach = (UIImageView*)[_viewMainSec viewWithTag:42006];
        [imgVieCoach setImage:[UIImage imageNamed:@"other-info-coach-icon"]];
        imgVieCoach.hidden = NO;
        imgVieCoach.frame = CGRectMake(fStartPoint, CGRectGetMinY(sexTypeImageView.frame), 20, 20);
        fStartPoint = CGRectGetMaxX(imgVieCoach.frame) + 2;
    }*/
    
    float dMyLon = [[ApplicationContext sharedInstance] accountInfo].longitude;
    float dMyLat = [[ApplicationContext sharedInstance] accountInfo].latitude;
    float dOtherLon =  tasksReferInfo.longitude;
    float dOtherLat = tasksReferInfo.latitude;
    double dDistance = [[CommonUtility sharedInstance] getDistanceBySelfLon:dMyLon SelfLantitude:dMyLat OtherLon:dOtherLon OtherLat:dOtherLat];
    
    NSString * strDate = @"";
    
    if (tasksReferInfo.last_login_time > 0) {
        NSDate * dateLastLogin = [NSDate dateWithTimeIntervalSince1970:tasksReferInfo.last_login_time];
        NSDate * today = [NSDate date];
        long long llInterval = [today timeIntervalSinceDate:dateLastLogin];
        long long llMinute = llInterval / 60;
        long long llHour = llInterval / 3600;
        
        if (llMinute == 0) {
            strDate = @"刚刚登录";
        }
        
        if(llMinute > 0)
        {
            strDate = [NSString stringWithFormat:@"%lld分钟前登录", llMinute];
        }
        
        if(llMinute >= 60)
        {
            strDate = [NSString stringWithFormat:@"%lld小时前登录", llHour];
        }
        
        if(llHour >= 24)
        {
            strDate = [NSString stringWithFormat:@"%lld天前登录", llHour / 24];
        }
    }
    
    if (dDistance < 1000 && dDistance >= 0) {
        if (strDate.length > 0) {
            strDate = [NSString stringWithFormat:@"%@, 距离%.2f米", strDate, dDistance];
        }
        else
        {
            strDate = [NSString stringWithFormat:@"距离%.2f米", dDistance];
        }
    }
    else if(dDistance >= 1000)
    {
        if (strDate.length > 0) {
            strDate = [NSString stringWithFormat:@"%@, 距离%.2f公里", strDate, dDistance / 1000];
        }
        else
        {
            strDate = [NSString stringWithFormat:@"距离%.2f公里", dDistance / 1000];
        }
    }
    
    if (strDate.length > 0) {
        UIImageView * imgLoc = (UIImageView*)[_viewMainSec viewWithTag:42007];
        imgLoc.hidden = NO;
        
        UILabel *lbLoc = (UILabel*)[_viewMainSec viewWithTag:42008];
        lbLoc.hidden = NO;
        lbLoc.text = strDate;
        
        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        CGSize lbSize = [lbLoc.text boundingRectWithSize:CGSizeMake(FLT_MAX, 20)
                                                 options:options
                                              attributes:@{NSFontAttributeName:lbLoc.font} context:nil].size;
        
        if (lbSize.width > CGRectGetWidth(_viewMainSec.frame) - CGRectGetMaxX(sexTypeImageView.frame) - 30 - 10) {
            strDate = [self reGenerateLocPosiStr:tasksReferInfo];
            lbLoc.text = strDate;
            lbSize = [lbLoc.text boundingRectWithSize:CGSizeMake(FLT_MAX, 20)
                                                     options:options
                                                  attributes:@{NSFontAttributeName:lbLoc.font} context:nil].size;
        }
        
        lbLoc.frame = CGRectMake(CGRectGetMaxX(sexTypeImageView.frame) + 30, CGRectGetMinY(sexTypeImageView.frame), lbSize.width, 20);
        imgLoc.frame = CGRectMake(CGRectGetMaxX(sexTypeImageView.frame) + 10, CGRectGetMinY(sexTypeImageView.frame), 17, 17);
    }

    e_task_type eTaskType = [CommonFunction ConvertStringToTaskType:_taskInfo.task_type];
    UILabel *lbDesc = (UILabel*)[_viewMainSec viewWithTag:42009];

    if (tasksReferInfo.last_time > 0) {
        NSDate * beginDay = [NSDate dateWithTimeIntervalSince1970:tasksReferInfo.last_time];
        NSDateComponents * comps =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:beginDay];
        NSString *strDate = [NSString stringWithFormat:@"%02ld/%02ld/%04ld %.2ld:%.2ld", [comps month], [comps day], [comps year], [comps hour], [comps minute]];
        
        if (eTaskType == e_task_physique || eTaskType == e_task_magic) {
            NSDictionary *attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
            NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 跑步", strDate] attributes:attribs];
            
            attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:22], NSForegroundColorAttributeName:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0]};
            NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f", _taskInfo.distance / 1000.0] attributes:attribs];
            
            attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
            NSAttributedString * strPart3Value = [[NSAttributedString alloc] initWithString:@"公里" attributes:attribs];
            
            NSMutableAttributedString * strPer = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
            [strPer appendAttributedString:strPart2Value];
            [strPer appendAttributedString:strPart3Value];
            lbDesc.attributedText = strPer;
        }
        else if(eTaskType == e_task_literature)
        {
            lbDesc.text = [NSString stringWithFormat:@"%@ 发表了1篇博文", strDate];
        }
    }
    else
    {
        lbDesc.text = @"Ta很懒，邀请Ta互动一下吧！";
    }
    
    UILabel *lbRate = (UILabel*)[_viewMainSec viewWithTag:42020];
    lbRate.frame = CGRectMake(75, ([lbDesc isHidden] ? CGRectGetMaxY(imgViewProfile.frame) - 20 : CGRectGetMaxY(lbDesc.frame)) + 5, CGRectGetWidth(_viewMainSec.frame) - 80, 20);
    
    CSButton *btnPK = (CSButton*)[_viewMainSec viewWithTag:42012];
    CSButton *btnRun = (CSButton*)[_viewMainSec viewWithTag:42013];
    CSButton *btnPass = (CSButton*)[_viewMainSec viewWithTag:42014];
    btnRun.hidden = NO;
    
    if (eTaskType == e_task_physique) {
        NSDictionary *attribs = @{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0]};
        NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:@"●" attributes:attribs];
        
        attribs = @{NSFontAttributeName: [UIFont systemFontOfSize:13], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"PK回应率 %.f%%     ", tasksReferInfo.pk_ratio * 100] attributes:attribs];
        
        attribs = @{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0]};
        NSAttributedString * strPart3Value = [[NSAttributedString alloc] initWithString:@"●" attributes:attribs];
        
        attribs = @{NSFontAttributeName: [UIFont systemFontOfSize:13], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSAttributedString * strPart4Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"约跑回应率 %.f%%", tasksReferInfo.run_ratio * 100] attributes:attribs];
        
        NSMutableAttributedString * strPer = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
        [strPer appendAttributedString:strPart2Value];
        [strPer appendAttributedString:strPart3Value];
        [strPer appendAttributedString:strPart4Value];
        lbRate.attributedText = strPer;
        
        btnPK.frame = CGRectMake(30, CGRectGetMinY(btnPK.frame), 50, 80);
        btnRun.frame = CGRectMake(CGRectGetWidth(_viewMainSec.frame) / 2 - 25, CGRectGetMinY(btnPK.frame), 50, 80);
        btnPass.frame = CGRectMake(CGRectGetWidth(_viewMainSec.frame) - 100, CGRectGetMinY(btnPK.frame) - 5, 70, 100);
        
        [btnRun setTitle:@"约跑" forState:UIControlStateNormal];
        [btnRun setImage:[UIImage imageNamed:@"home-run-together"] forState:UIControlStateNormal];
        
        __weak __typeof(self) weakSelf = self;
            
        btnRun.actionBlock = ^()
        {
            __typeof(self) strongSelf = weakSelf;
            
            TasksReferInfo *tasksReferInfo = strongSelf->_arrReferInfo.firstObject;
            
            TaskRunShareViewController *taskRunShareViewController = [[TaskRunShareViewController alloc]init];
            taskRunShareViewController.nTaskId = strongSelf->_taskInfo.task_id;
            taskRunShareViewController.strUserId = tasksReferInfo.userid;
            taskRunShareViewController.finishBlock = ^()
            {
                [strongSelf->_arrReferInfo removeObjectAtIndex:0];
                [strongSelf reloadReferralControls:YES];
            };
            
            [strongSelf.navigationController pushViewController:taskRunShareViewController animated:YES];
        };
    }
    else if(eTaskType == e_task_literature)
    {
        NSDictionary *attribs = @{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0]};
        NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:@"●" attributes:attribs];
        
        attribs = @{NSFontAttributeName: [UIFont systemFontOfSize:13], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"PK回应率 %.f%%     ", tasksReferInfo.pk_ratio * 100] attributes:attribs];
        
        attribs = @{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0]};
        NSAttributedString * strPart3Value = [[NSAttributedString alloc] initWithString:@"●" attributes:attribs];
        
        attribs = @{NSFontAttributeName: [UIFont systemFontOfSize:13], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSAttributedString * strPart4Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"约赞回应率 %.f%%", tasksReferInfo.post_ratio * 100] attributes:attribs];
        
        NSMutableAttributedString * strPer = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
        [strPer appendAttributedString:strPart2Value];
        [strPer appendAttributedString:strPart3Value];
        [strPer appendAttributedString:strPart4Value];
        lbRate.attributedText = strPer;
        
        btnPK.frame = CGRectMake(30, CGRectGetMinY(btnPK.frame), 50, 80);
        btnRun.frame = CGRectMake(CGRectGetWidth(_viewMainSec.frame) / 2 - 25, CGRectGetMinY(btnPK.frame), 50, 80);
        btnPass.frame = CGRectMake(CGRectGetWidth(_viewMainSec.frame) - 100, CGRectGetMinY(btnPK.frame) - 5, 70, 100);
        [btnRun setTitle:@"约赞" forState:UIControlStateNormal];
        [btnRun setImage:[UIImage imageNamed:@"home-praise-ask"] forState:UIControlStateNormal];
        
        __weak __typeof(self) weakSelf = self;
        
        btnRun.actionBlock = ^()
        {
            __typeof(self) strongSelf = weakSelf;
            
            if ([strongSelf checkFirstActionFree]) {
                [strongSelf taskShared:YES ShareType:e_accept_literature];
            }
            else
            {
                if ([strongSelf checkFirstActionPopWin]) {
                    strongSelf->_alertView = [[UIAlertView alloc] initWithTitle:@"邀请" message:@"今天免费次数已用完，本次邀请会花费1个金币，确认邀请吗？" delegate:strongSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                    strongSelf->_alertView.tag = 11;
                    [strongSelf->_alertView show];
                }
                else
                {
                    [strongSelf taskShared:NO ShareType:e_accept_literature];
                }
            }
        };
    }
    else
    {
        NSDictionary *attribs = @{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0]};
        NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:@"●" attributes:attribs];
        
        attribs = @{NSFontAttributeName: [UIFont systemFontOfSize:13], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"PK回应率 %.f%%", tasksReferInfo.pk_ratio * 100] attributes:attribs];
        
        NSMutableAttributedString * strPer = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
        [strPer appendAttributedString:strPart2Value];
        lbRate.attributedText = strPer;
        
        btnPK.frame = CGRectMake(CGRectGetWidth(_viewMainSec.frame) / 2 - 80, CGRectGetMinY(btnPK.frame), 50, 80);
        btnPass.frame = CGRectMake(CGRectGetWidth(_viewMainSec.frame) / 2 + 30, CGRectGetMinY(btnPK.frame) - 5, 70, 100);
        btnRun.hidden = YES;
    }
    
    if (tasksReferInfo.user_images.data.count > 0) {
        _imageData = [NSMutableArray arrayWithArray:tasksReferInfo.user_images.data];
    }
    else
    {
        _imageData = [NSMutableArray arrayWithObject:tasksReferInfo.profile_image];
    }
    
    [_photoStack reloadData];
    
    CGSize size= [_pageControl sizeForNumberOfPages:[_imageData count]];
    _pageControl.bounds=CGRectMake(0, 0, size.width, size.height);
    _pageControl.center = CGPointMake(CGRectGetWidth(_viewMainSec.frame) / 2, CGRectGetMaxY(_photoStack.frame) + 10);
    _pageControl.numberOfPages=[_imageData count];
    _pageControl.hidden = _imageData.count > 1 ? NO : YES;
}

#pragma mark - AlertView Logic

-(void)dismissAlertView {
    if (_alertView) {
        [_alertView dismissWithClickedButtonIndex:0 animated:YES];
        _alertView.delegate = nil;
        _alertView = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10)
    {
        if (buttonIndex == 1)
        {
            [self dismissAlertView];
            [self taskShared:NO ShareType:e_accept_pk];
        }
    }
    else if (alertView.tag == 11)
    {
        if (buttonIndex == 1)
        {
            [self dismissAlertView];
            [self taskShared:NO ShareType:e_accept_literature];
        }
    }
}

#pragma mark Deck DataSource Protocol Methods

-(NSUInteger)numberOfPhotosInPhotoStackView:(PhotoStackView *)photoStack {
    return [_imageData count];
}

-(NSString *)photoStackView:(PhotoStackView *)photoStack photoForIndex:(NSUInteger)index {
    return [_imageData objectAtIndex:index];
}

#pragma mark Deck Delegate Protocol Methods

-(void)photoStackView:(PhotoStackView *)photoStackView willStartMovingPhotoAtIndex:(NSUInteger)index {
    // User started moving a photo
}

-(void)photoStackView:(PhotoStackView *)photoStackView willFlickAwayPhotoAtIndex:(NSUInteger)index {
    // User flicked the photo away, revealing the next one in the stack
}

-(void)photoStackView:(PhotoStackView *)photoStackView didRevealPhotoAtIndex:(NSUInteger)index {
    _pageControl.currentPage = index;
}

-(void)photoStackView:(PhotoStackView *)photoStackView didSelectPhotoAtIndex:(NSUInteger)index {
    [self onClickImageViewByIndex:index];
}

#pragma mark - MWPhotoBrowserDelegate

-(void)onClickImageViewByIndex:(NSUInteger)index
{
    [_photos removeAllObjects];
    
    for (NSString *strUrl in _imageData) {
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

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

#pragma mark - viewload begin

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initLayout];
    [self initNotifyMsg];
    [self generateGameItems];
    
    _photos = [[NSMutableArray alloc]init];
    _arrReferInfo = [[NSMutableArray alloc]init];
}

- (void)viewDidUnload {
    _pageControl = nil;
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"主页 - MainViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"主页 - MainViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"主页 - MainViewController"];
}

-(void)initNotifyMsg
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleGetMainInfo) name:NOTIFY_MESSAGE_GET_MAIN_INFO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleGetSysConfig) name:NOTIFY_MESSAGE_GET_SYSCONFIG_INFO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateTaskStatus) name:NOTIFY_MESSAGE_UPDATE_TASK_STATUS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateProfileInfo:) name:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleProgramResign) name:NOTIFY_MESSAGE_PROGRAM_RESIGNACTIVE object:nil];
}

-(void)dealloc
{
    NSLog(@"MainViewController dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Event Logic
-(void)taskShared:(BOOL)bFree ShareType:(e_accept_type)eShareType
{
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    NSInteger nCoinValue = userInfo.proper_info.coin_value / 100000000;

    if(!bFree && nCoinValue == 0)
    {
        [JDStatusBarNotification showWithStatus:@"金币余额为0，不能发送邀请，赶快去赚取金币吧!" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
        return;
    }

    if (eShareType == e_accept_pk) {
        [[CommonUtility sharedInstance]playAudioFromName:@"pk.wav"];
        [JDStatusBarNotification showWithStatus:@"PK邀请已发送!" dismissAfter:0.7 styleName:JDStatusBarStyleSuccess];
    }
    else if(eShareType == e_accept_literature)
    {
        [[CommonUtility sharedInstance]playAudioFromName:@"invitetobeliked.wav"];
        [JDStatusBarNotification showWithStatus:@"约赞邀请已发送!" dismissAfter:0.7 styleName:JDStatusBarStyleSuccess];
    }
    
    TasksReferInfo *tasksReferInfo = _arrReferInfo.firstObject;
    
    id processWin = [AlertManager showCommonProgressInView:_viewMainSec];
    
    [[SportForumAPI sharedInstance]tasksShareByUserId:tasksReferInfo.userid TaskId:_taskInfo.task_id ShareType:eShareType CostCoin:bFree ? 0 : 100000000 Latitude:0 Longitude:0 AddDesc:@"" MapImgUrl:@"" RunBeginTime:0 FinishedBlock:^(int errorCode)
     {
         [AlertManager dissmiss:processWin];

         [_arrReferInfo removeObjectAtIndex:0];
         [self reloadReferralControls:YES];
     }];
}

-(void)generateGameItems
{
    _gameItems = [[NSMutableArray alloc]init];

    GameItem *gameItem = [[GameItem alloc]init];
    gameItem.gameTitle = @"熊出没";
    gameItem.gameImg = @"game-bear";
    gameItem.eGameType = e_game_xiongchumo;
    [_gameItems addObject:gameItem];

    gameItem = [[GameItem alloc]init];
    gameItem.gameTitle = @"爱之跳跳";
    gameItem.gameImg = @"game-qixi";
    gameItem.eGameType = e_game_qixi;
    [_gameItems addObject:gameItem];

    gameItem = [[GameItem alloc]init];
    gameItem.gameTitle = @"蜘蛛侠";
    gameItem.gameImg = @"game-lineLife";
    gameItem.eGameType = e_game_spiderman;
    [_gameItems addObject:gameItem];

    gameItem = [[GameItem alloc]init];
    gameItem.gameTitle = @"古墓历险";
    gameItem.gameImg = @"game-escape";
    gameItem.eGameType = e_game_mishi;
    [_gameItems addObject:gameItem];

    gameItem = [[GameItem alloc]init];
    gameItem.gameTitle = @"幸运转盘";
    gameItem.gameImg = @"game-rotate";
    gameItem.eGameType = e_game_znm;
    [_gameItems addObject:gameItem];
}

-(void)onClickVideoPreView:(NSString*)strUrl
{
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2);
    [moviePlayerViewController.view setTransform:transform];
    
    // Remove the movie player view controller from the "playback did finish" notification observers
    [[NSNotificationCenter defaultCenter] removeObserver:moviePlayerViewController
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayerViewController.moviePlayer];
    
    // Register this class as an observer instead
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayerViewController.moviePlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:moviePlayerViewController name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [self presentMoviePlayerViewControllerAnimated:moviePlayerViewController];
}

- (void)movieFinishedCallback:(NSNotification*)aNotification
{
    // Obtain the reason why the movie playback finished
    NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    // Dismiss the view controller ONLY when the reason is not "playback ended"
    if ([finishReason intValue] != MPMovieFinishReasonPlaybackEnded)
    {
        MPMoviePlayerController *moviePlayer = [aNotification object];
        
        // Remove this class from the observers
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];
        
        // Dismiss the view controller
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)onClickStartTaskBtn
{
    e_task_type eTaskType = [CommonFunction ConvertStringToTaskType:_taskInfo.task_type];
    e_task_status eTaskStatus = [CommonFunction ConvertStringToTaskStatusType:_taskInfo.task_status];
    
    if (eTaskStatus == e_task_normal || eTaskStatus == e_task_unfinish) {
        if (eTaskType == e_task_physique) {
            RecordSportViewController *recordSportViewController = [[RecordSportViewController alloc]init];
            recordSportViewController.taskInfo = _taskInfo;
            [self.navigationController pushViewController:recordSportViewController animated:YES];
        }
        else if(eTaskType == e_task_literature)
        {
            ArticlePublicViewController* articlePublicViewController = [[ArticlePublicViewController alloc]init];
            articlePublicViewController.taskInfo = _taskInfo;
            articlePublicViewController.strTitle = @"发表博文任务";
            [self.navigationController pushViewController:articlePublicViewController animated:YES];
        }
        else
        {
            NSString *strGameDir = @"";
            GameItem *gameItem = _gameItems[arc4random() % (_gameItems.count)];
            
            if ([gameItem.gameTitle isEqualToString:@"熊出没"]) {
                strGameDir = @"xiongchumo";
            }
            else if([gameItem.gameTitle isEqualToString:@"爱之跳跳"])
            {
                strGameDir = @"qixi";
            }
            else if([gameItem.gameTitle isEqualToString:@"蜘蛛侠"])
            {
                strGameDir = @"spiderman";
            }
            else if([gameItem.gameTitle isEqualToString:@"古墓历险"])
            {
                strGameDir = @"mishi";
            }
            else if([gameItem.gameTitle isEqualToString:@"幸运转盘"])
            {
                strGameDir = @"znm";
            }
            
            WebGameViewController *webGameViewController = [[WebGameViewController alloc]init];
            webGameViewController.gameTitle = gameItem.gameTitle;
            webGameViewController.eGameType = gameItem.eGameType;
            webGameViewController.gameDir = strGameDir;
            webGameViewController.taskInfo = _taskInfo;
            [self.navigationController pushViewController:webGameViewController animated:YES];
        }
    }
    else if(eTaskStatus == e_task_finish)
    {
        [self reloadTasksData:YES];
    }
}

-(void)handleGetMainInfo
{
    //Load current week task
    [self reloadTasksData:NO];
    
    //Check First Reward
    [self checkDailyFirstLogin];
}

-(void)handleGetSysConfig
{
    [self updateMainFirView];
}

-(void)handleUpdateTaskStatus
{
    //Load current week task
    [self reloadTasksData:NO];
}

-(void)handleUpdateProfileInfo:(NSNotification*) notification
{
    BOOL bAddEffect = NO;
    ExpEffect* expEffect = [notification.userInfo objectForKey:@"RewardEffect"];
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    
    if (userInfo != nil && expEffect != nil && (expEffect.exp_physique > 0 || expEffect.exp_literature > 0 || expEffect.exp_magic > 0 || expEffect.exp_coin > 0)) {
        bAddEffect = YES;
        userInfo.proper_info.physique_value += expEffect.exp_physique;
        userInfo.proper_info.literature_value += expEffect.exp_literature;
        userInfo.proper_info.magic_value += expEffect.exp_magic;
        userInfo.proper_info.coin_value += expEffect.exp_coin;
    }
    
    //Load user Properties
    [self updateMainFirView];
}

-(void)handleProgramResign
{
    if (m_timeReward != nil) {
        [m_timeReward invalidate];
        m_timeReward = nil;
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)checkDailyFirstLogin
{
    NSDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"LoginInfo"];
    
    if (dict != nil) {
        int nLoginTimes = [[dict objectForKey:@"login_count"]intValue];
        
        if (nLoginTimes == 1) {
            [[SportForumAPI sharedInstance]userGetDailyLoginReward:^(int errorCode, int nLoginedDays, NSMutableArray* arrLoginReward){
                if (errorCode == RSA_ERROR_NONE) {
                    NSString *strReward = [NSString stringWithFormat:@"您已连续登录%d天，今日首次登录奖励%ld金币~", nLoginedDays, [arrLoginReward[(nLoginedDays - 1) % 7] unsignedLongValue] / 100000000];
                    
                    if (nLoginedDays == 1) {
                        strReward = [NSString stringWithFormat:@"今日首次登录奖励%ld金币，连续登录会得到更多金币哦~", [arrLoginReward[(nLoginedDays - 1) % 7] unsignedLongValue] / 100000000];
                    }
                    
                    [JDStatusBarNotification showWithStatus:strReward dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleSuccess];
                    
                    ExpEffect *expEffect = [[ExpEffect alloc]init];
                    expEffect.exp_coin = [arrLoginReward[(nLoginedDays - 1) % 7] unsignedLongValue];
                    
                    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
                    
                    [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
                     {
                         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", nil]];
                     }];
                }
            }];
        }
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginInfo"];
    }
    else
    {
        if (m_timeReward != nil) {
            [m_timeReward invalidate];
            m_timeReward = nil;
        }
        
        m_timeReward = [NSTimer scheduledTimerWithTimeInterval: 2
                                                        target: self
                                                      selector: @selector(checkDailyFirstLogin)
                                                      userInfo: nil
                                                       repeats: NO];
    }
}

-(BOOL)checkFirstActionFree
{
    BOOL bFirstAction= NO;
    NSDate * nowDate = [NSDate date];
    NSDateComponents * comps =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:nowDate];
    NSString *strDate = [NSString stringWithFormat:@"%02ld/%02ld/%04ld", [comps month], [comps day], [comps year]];
    
    NSDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"FirstActionInfo"];
    BOOL bFirst = [[dict objectForKey:strDate]boolValue];
    
    if (!bFirst) {
        bFirstAction = YES;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FirstActionInfo"];
        NSMutableDictionary *actionDict = [NSMutableDictionary dictionaryWithObjectsAndKeys: @(YES), strDate, nil];
        [[ApplicationContext sharedInstance] saveObject:actionDict byKey:@"FirstActionInfo"];
    }
    
    return bFirstAction;
}

-(BOOL)checkFirstActionPopWin
{
    BOOL bFirstAction= NO;
    NSDate * nowDate = [NSDate date];
    NSDateComponents * comps =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:nowDate];
    NSString *strDate = [NSString stringWithFormat:@"%02ld/%02ld/%04ld", [comps month], [comps day], [comps year]];
    
    NSDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"FirstActionPop"];
    BOOL bFirst = [[dict objectForKey:strDate]boolValue];
    
    if (!bFirst) {
        bFirstAction = YES;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FirstActionPop"];
        NSMutableDictionary *actionDict = [NSMutableDictionary dictionaryWithObjectsAndKeys: @(YES), strDate, nil];
        [[ApplicationContext sharedInstance] saveObject:actionDict byKey:@"FirstActionPop"];
    }
    
    return bFirstAction;
}

-(void)reloadTasksData:(BOOL)bNextTasks
{
    [[SportForumAPI sharedInstance]tasksGetInfo:bNextTasks FinishedBlock:^(int errorCode, TasksCurInfo *tasksCurInfo)
     {
         if (errorCode == 0) {
             _taskInfo = tasksCurInfo.task;
             e_task_type eTaskType = [CommonFunction ConvertStringToTaskType:_taskInfo.task_type];
             e_task_status eTaskStatus = [CommonFunction ConvertStringToTaskStatusType:_taskInfo.task_status];
             
             switch (eTaskType) {
                 case e_task_physique:
                     _lbTaskTitle.text = @"跑步任务";
                     [_imgViewBg setImage:[UIImage imageNamedWithWebP:@"run_bg"]];
                     [_imgViewTask setImage:[UIImage imageNamed:@"me-level-runner"]];
                     break;
                 case e_task_literature:
                     _lbTaskTitle.text = @"博文任务";
                     [_imgViewBg setImage:[UIImage imageNamedWithWebP:@"literature_bg"]];
                     [_imgViewTask setImage:[UIImage imageNamed:@"me-level-pen"]];
                     break;
                 case e_task_magic:
                     _lbTaskTitle.text = @"魔法任务";
                     [_imgViewBg setImage:[UIImage imageNamedWithWebP:@"magic_bg"]];
                     [_imgViewTask setImage:[UIImage imageNamed:@"me-level-magic"]];
                     break;
                 default:
                     break;
             }
             
             _btnTask.enabled = YES;
             _btnFailDetails.hidden = YES;
             
             UIImage *imageStatus = nil;
             
             switch (eTaskStatus) {
                 case e_task_normal:
                     if (eTaskType == e_task_physique) {
                         NSDictionary *attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
                         NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:@"距离：" attributes:attribs];
                         
                         attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:20], NSForegroundColorAttributeName:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0]};
                         NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f ", _taskInfo.distance / 1000.0] attributes:attribs];
                         
                         attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
                         NSAttributedString * strPart3Value = [[NSAttributedString alloc] initWithString:@"公里， 时长：" attributes:attribs];
                         
                         attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:20], NSForegroundColorAttributeName:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0]};
                         NSAttributedString * strPart4Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lld ", _taskInfo.duration / 60] attributes:attribs];
                         
                         attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
                         NSAttributedString * strPart5Value = [[NSAttributedString alloc] initWithString:@"分钟\n" attributes:attribs];
                         
                         attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
                         NSAttributedString * strPart6Value = [[NSAttributedString alloc] initWithString:_taskInfo.task_desc attributes:attribs];
                         
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
                         _lbTaskDesc.attributedText = strPer;
                     }
                     else if(eTaskType == e_task_literature)
                     {
                         NSDictionary *attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
                         NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:@"发表文章，分享你的运动经验吧\n" attributes:attribs];
                         
                         attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
                         NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:@"15个字，一张图片或一段视频" attributes:attribs];
                         
                         NSMutableAttributedString * strPer = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
                         [strPer appendAttributedString:strPart2Value];
                         
                         NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                         [paragraphStyle setParagraphSpacing:10];
                         paragraphStyle.alignment = NSTextAlignmentCenter;
                         [strPer addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [strPer length])];
                         _lbTaskDesc.attributedText = strPer;
                     }
                     else if(eTaskType == e_task_magic)
                     {
                         NSDictionary *attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
                         NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:@"开始奇遇旅行，提升自己的魔法力\n" attributes:attribs];
                         
                         attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
                         NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:@"收获一个金币" attributes:attribs];
                         
                         NSMutableAttributedString * strPer = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
                         [strPer appendAttributedString:strPart2Value];
                         
                         NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                         [paragraphStyle setParagraphSpacing:10];
                         paragraphStyle.alignment = NSTextAlignmentCenter;
                         [strPer addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [strPer length])];
                         _lbTaskDesc.attributedText = strPer;
                     }
                     
                     [_btnTask setTitle:@"开始任务" forState:UIControlStateNormal];
                     break;
                 case e_task_finish:
                     _lbTaskDesc.text = @"恭喜，你的任务已经成功完成!";
                     [_btnTask setTitle:@"下一个任务" forState:UIControlStateNormal];
                     imageStatus = [UIImage imageNamed:@"task-finished"];
                     break;
                 case e_task_unfinish:
                     _lbTaskDesc.text = @"任务失败，点击查看任务详情!";
                     [_btnTask setTitle:@"重新开始任务" forState:UIControlStateNormal];
                     imageStatus = [UIImage imageNamed:@"task-fail"];
                     break;
                 case e_task_authentication:
                     _lbTaskDesc.text = @"你的任务正在审核中，请耐心等待！";
                     [_btnTask setTitle:@"开始任务" forState:UIControlStateNormal];
                     imageStatus = [UIImage imageNamed:@"task-pendding"];
                     _btnTask.enabled = NO;
                     break;
                 default:
                     break;
             }
             
             _imageStatus.hidden = YES;

             if (imageStatus != nil) {
                 [_imageStatus setImage:imageStatus];
                 _imageStatus.hidden = NO;
                 _lbTaskDesc.frame = CGRectMake(CGRectGetMinX(_lbTaskDesc.frame), CGRectGetMaxY(_imageStatus.frame) + 5, CGRectGetWidth(_lbTaskDesc.frame), 30);
                 
                 if (eTaskStatus == e_task_unfinish) {
                     _lbTaskDesc.frame = CGRectMake(CGRectGetMinX(_lbTaskDesc.frame), CGRectGetMaxY(_imageStatus.frame) + 5, CGRectGetWidth(_lbTaskDesc.frame), 30);
                     _btnFailDetails.frame = CGRectMake(CGRectGetWidth(_viewMainFir.frame) - 65, CGRectGetMaxY(_imageStatus.frame) + 5, 25, 25);
                     _btnFailDetails.hidden = NO;
                 }
             }
             else
             {
                 if (eTaskType == e_task_physique)
                 {
                     _lbTaskDesc.frame = CGRectMake(CGRectGetMinX(_lbTaskDesc.frame), CGRectGetMaxY(_imgViewTask.frame) + 10, CGRectGetWidth(_lbTaskDesc.frame), 60);
                 }
                 else if(eTaskType == e_task_literature)
                 {
                     _lbTaskDesc.frame = CGRectMake(CGRectGetMinX(_lbTaskDesc.frame), CGRectGetMaxY(_imgViewTask.frame) + 20, CGRectGetWidth(_lbTaskDesc.frame), 60);
                 }
                 else
                 {
                    _lbTaskDesc.frame = CGRectMake(CGRectGetMinX(_lbTaskDesc.frame), CGRectGetMaxY(_imgViewTask.frame) + 15, CGRectGetWidth(_lbTaskDesc.frame), 60);
                 }
             }

             //Load ReferralsMembers
             [self getReferralsMembers];
         }
     }];
}

-(void)getReferralsMembers
{
    [[SportForumAPI sharedInstance]tasksReferrals:^(int errorCode, TasksReferList* tasksReferList)
     {
         if (errorCode == 0) {
             [_arrReferInfo removeAllObjects];
             [_arrReferInfo addObjectsFromArray:tasksReferList.referrals.data];
             [self reloadReferralControls:NO];
         }
     }];
}

-(void)generateReferralView
{
    _viewRefer = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_scrollView.frame) - 49.0 - 50 - 20, CGRectGetWidth(_scrollView.frame), 50)];
    _viewRefer.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
    [_viewMainFir addSubview:_viewRefer];
    
    UILabel *lbRefer = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 150, 20)];
    lbRefer.backgroundColor = [UIColor clearColor];
    lbRefer.font = [UIFont boldSystemFontOfSize:13];
    lbRefer.textColor = [UIColor darkGrayColor];
    lbRefer.textAlignment = NSTextAlignmentLeft;
    lbRefer.text = @"认识也在做这个任务的Ta";
    [_viewRefer addSubview:lbRefer];
    
    UIImageView *imgViewArrow = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_viewMainFir.frame) - 15, 17, 8, 16)];
    [imgViewArrow setImage:[UIImage imageNamed:@"arrow-11"]];
    [_viewRefer addSubview:imgViewArrow];
    
    UIImageView *imageViewUser1 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(imgViewArrow.frame) - 65, 5, 40, 40)];
    imageViewUser1.tag = 60000;
    [_viewRefer addSubview:imageViewUser1];
    
    UIImageView *imageViewUser2 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageViewUser1.frame) - 45, 5, 40, 40)];
    imageViewUser2.tag = 60001;
    [_viewRefer addSubview:imageViewUser2];
    
    UILabel *lbReferCount = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imgViewArrow.frame) - 20, 15, 15, 20)];
    lbReferCount.backgroundColor = [UIColor clearColor];
    lbReferCount.font = [UIFont systemFontOfSize:12];
    lbReferCount.textColor = [UIColor lightGrayColor];
    lbReferCount.textAlignment = NSTextAlignmentRight;
    lbReferCount.tag = 60002;
    [_viewRefer addSubview:lbReferCount];
    
    CSButton *btnAction = [CSButton buttonWithType:UIButtonTypeCustom];
    btnAction.frame = CGRectMake(0, 0, CGRectGetWidth(_viewMainFir.frame), 50);
    btnAction.backgroundColor = [UIColor clearColor];
    [_viewRefer addSubview:btnAction];
    
    __weak __typeof(self) weakSelf = self;
    
    btnAction.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        
        if (strongSelf->_scrollView.contentOffset.x < CGRectGetWidth(strongSelf->_scrollView.frame)) {
            [strongSelf->_scrollView setContentOffset:CGPointMake(CGRectGetWidth(strongSelf->_scrollView.frame), strongSelf->_scrollView.contentOffset.y) animated:YES];
        }
    };
}

-(void)generateInviteFriendsView
{
    _viewFriend = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_scrollView.frame) - 49.0 - 50 - 20, CGRectGetWidth(_scrollView.frame), 50)];
    _viewFriend.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
    [_viewMainFir addSubview:_viewFriend];
    
    
    UILabel *lbFriend = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 270, 20)];
    lbFriend.backgroundColor = [UIColor clearColor];
    lbFriend.font = [UIFont boldSystemFontOfSize:13];
    lbFriend.textColor = [UIColor darkGrayColor];
    lbFriend.textAlignment = NSTextAlignmentLeft;
    lbFriend.text = @"暂无做这个任务的Ta了，去邀请好友来玩吧！";
    [_viewFriend addSubview:lbFriend];
    
    UIImageView *imgViewArrow = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_viewMainFir.frame) - 15, 17, 8, 16)];
    [imgViewArrow setImage:[UIImage imageNamed:@"arrow-11"]];
    [_viewFriend addSubview:imgViewArrow];
    
    CSButton *btnAction = [CSButton buttonWithType:UIButtonTypeCustom];
    btnAction.frame = CGRectMake(0, 0, CGRectGetWidth(_viewMainFir.frame), 50);
    btnAction.backgroundColor = [UIColor clearColor];
    [_viewFriend addSubview:btnAction];
    
    __weak __typeof(self) weakSelf = self;
    
    btnAction.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        
        MobileFriendViewController *mobileFriendViewController = [[MobileFriendViewController alloc]init];
        [strongSelf.navigationController pushViewController:mobileFriendViewController animated:YES];
    };
}

-(void)reloadReferralControls:(BOOL)bAnimate
{
    if (_arrReferInfo.count > 0) {
        if (_viewMainSec == nil) {
            [self generateMainSecView];
        }
        
        if (_viewRefer == nil) {
            [self generateReferralView];
        }

        if (bAnimate) {
            CATransition *animation = [CATransition animation];
            animation.delegate = self;
            animation.duration = 1.0;
            animation.timingFunction = UIViewAnimationCurveEaseInOut;
            animation.type = @"rippleEffect";//kCATransitionPush;
            //animation.subtype = kCATransitionFromLeft;
            [[_viewMainSec layer] addAnimation:animation forKey:@"animation"];
        }

        [UIView animateWithDuration:1.0 animations:^()
         {
             _viewFriend.alpha = 0.0;
             _viewRefer.alpha = 1.0;
         }];
        
        UIImageView *imageViewUser1 = (UIImageView*)[_viewRefer viewWithTag:60000];
        UIImageView *imageViewUser2 = (UIImageView*)[_viewRefer viewWithTag:60001];
        
        UILabel *lbReferCount = (UILabel*)[_viewRefer viewWithTag:60002];
        [lbReferCount setText:[NSString stringWithFormat:@"%ld", _arrReferInfo.count]];
        
        CGSize constraint = CGSizeMake(20000.0f, 20.0f);
        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        
        CGSize size = [lbReferCount.text boundingRectWithSize:constraint
                                                      options:options
                                                   attributes:@{NSFontAttributeName:lbReferCount.font} context:nil].size;
        
        lbReferCount.frame = CGRectMake(CGRectGetWidth(_viewMainFir.frame) - 15 - size.width - 5, 15, size.width, 20);
        imageViewUser1.frame = CGRectMake(CGRectGetMinX(lbReferCount.frame) - 45, 5, 40, 40);
        imageViewUser2.frame = CGRectMake(CGRectGetMinX(imageViewUser1.frame) - 45, 5, 40, 40);
        
        if (_arrReferInfo.count == 1) {
            TasksReferInfo *tasksReferInfo = _arrReferInfo.firstObject;
            [imageViewUser1 sd_setImageWithURL:[NSURL URLWithString:tasksReferInfo.profile_image]
                             placeholderImage:[UIImage imageNamed:@"image-placeholder"] withInset:0];
            imageViewUser2.hidden = YES;
            [lbReferCount setText:@""];
            imageViewUser1.frame = CGRectMake(CGRectGetWidth(_viewMainFir.frame) - 65, 5, 40, 40);
        }
        else
        {
            TasksReferInfo *tasksReferInfo0 = _arrReferInfo.firstObject;
            TasksReferInfo *tasksReferInfo1 = _arrReferInfo[1];
            
            imageViewUser2.hidden = NO;
            [imageViewUser1 sd_setImageWithURL:[NSURL URLWithString:tasksReferInfo1.profile_image]
                              placeholderImage:[UIImage imageNamed:@"image-placeholder"] withInset:0];
            [imageViewUser2 sd_setImageWithURL:[NSURL URLWithString:tasksReferInfo0.profile_image]
                              placeholderImage:[UIImage imageNamed:@"image-placeholder"] withInset:0];
        }
        
        [self updateMainSecView];
    }
    else
    {
        BOOL bShowSecView = NO;
        
        if (_scrollView.contentOffset.x >= CGRectGetWidth(_scrollView.frame)) {
            bShowSecView = YES;
            _viewMainFir.alpha = 0.0;
        }
        
        [UIView animateWithDuration:0.5 animations:^void()
         {
             _viewMainSec.alpha = 0.0;
         }completion:^(BOOL finished)
         {
             if (finished) {
                 [self removeViewFromScroll:_viewMainSec];
                 _viewMainSec = nil;
                 
                 if (bShowSecView) {
                     [UIView animateWithDuration:1.0 animations:^(void){
                         _viewMainFir.alpha = 1.0;
                     }];
                 }
             }
         }];
        
        if (_viewFriend == nil) {
            [self generateInviteFriendsView];
        }
        
        [UIView animateWithDuration:1.0 animations:^()
         {
             _viewFriend.alpha = 1.0;
             _viewRefer.alpha = 0.0;
         }];
    }
}

@end

//#import "MainViewController.h"
//#import "CSButton.h"
//#import "BoardCell.h"
//#import "EGORefreshTableHeaderView.h"
//#import "TaskViewController.h"
//#import "UIImageView+WebCache.h"
//#import "AlertManager.h"
//#import "PKViewController.h"
//#import "UIImage+Utility.h"
//#import "AccountPreViewController.h"
//#import "TaskHistoryViewController.h"
//#import "MobileFriendViewController.h"
//#import "SFUIScrollView.h"
//#import "AAAScoreView.h"
//#import "HelpUsedViewController.h"
//#import "MLPSpotlight.h"
//#import "UIViewController+Tutorial.h"
//#import "AppDelegate.h"
//#import "FBShimmeringView.h"
//#import "AccountPreViewController.h"
//
//#import "ArticlePublicViewController.h"
//#import "RecordSportViewController.h"
//#import "GameViewController.h"
//#import "WebGameViewController.h"
//#import "CoinCardViewController.h"
//
//#define VIEW_TASKS_ACTIVITY_INDICATORVIEW 10
//#define VIEW_BOARD_BOTTOM_VIEW 9
//
//@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
//
//@end
//
//@implementation MainViewController
//{
//    NSMutableDictionary * _dicUpdateControl;
//    NSMutableArray * _boardArray;
//    NSString *_strFirstPageId;
//    NSString *_strLastPageId;
//    BOOL _blDownHandleLoading;
//    UIActivityIndicatorView *_tableFooterActivityIndicator;
//    
//    EGORefreshTableHeaderView* _egoRefreshTableHeaderView;
//    BOOL _bUpHandleLoading;
//    
//    UITableView *m_tableBoard;
//    UIView *m_viewWeekTasks;
//    UIView *m_viewFriendBoard;
//    SFUIScrollView *m_scrollView;
//    
//    NSTimer * m_timeReward;
//    NSTimer *m_timerReward;
//    id m_processWindow;
//    
//    TasksInfoList *m_tasksInfoList;
//    NSMutableArray* m_gameItems;
//}
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//-(BOOL)bShowFooterViewController {
//    return YES;
//}
//
//-(void)initBoardTestData {
//    [_boardArray removeAllObjects];
//    
//    /*BoardItem *boardItem = [[BoardItem alloc]init];
//    boardItem.userImage = @"enemy-profile";
//    boardItem.nickName = @"五月天";
//    boardItem.unTotalScore = 312;
//    boardItem.nBoardRank = 1;
//    boardItem.nAge = 24;
//    boardItem.nLevel = 3;
//    boardItem.eSexType = e_sex_male;
//    [_boardArray addObject:boardItem];
//    
//    boardItem = [[BoardItem alloc]init];
//    boardItem.userImage = @"enemy-profile";
//    boardItem.nickName = @"番茄炒蛋";
//    boardItem.unTotalScore = 301;
//    boardItem.nBoardRank = 2;
//    boardItem.nAge = 27;
//    boardItem.nLevel = 2;
//    boardItem.eSexType = e_sex_female;
//    [_boardArray addObject:boardItem];
//    
//    boardItem = [[BoardItem alloc]init];
//    boardItem.userImage = @"image-placeholder";
//    boardItem.nickName = @"小幽灵";
//    boardItem.unTotalScore = 289;
//    boardItem.nBoardRank = 3;
//    boardItem.nAge = 30;
//    boardItem.nLevel = 3;
//    boardItem.eSexType = e_sex_female;
//    [_boardArray addObject:boardItem];
//    
//    boardItem = [[BoardItem alloc]init];
//    boardItem.userImage = @"enemy-profile";
//    boardItem.nickName = @"么么哒";
//    boardItem.unTotalScore = 266;
//    boardItem.nBoardRank = 4;
//    boardItem.nAge = 21;
//    boardItem.nLevel = 2;
//    boardItem.eSexType = e_sex_male;
//    [_boardArray addObject:boardItem];*/
//}
//
//-(void)initNotifyMsg
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleGetMainInfo) name:NOTIFY_MESSAGE_GET_MAIN_INFO object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateTaskStatus) name:NOTIFY_MESSAGE_UPDATE_TASK_STATUS object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateProfileInfo:) name:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateLeadBoard) name:NOTIFY_MESSAGE_UPDATE_LEADBOARD object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleProgramResign) name:NOTIFY_MESSAGE_PROGRAM_RESIGNACTIVE object:nil];
//    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdatePkTimes:) name:NOTIFY_MESSAGE_UPDATE_PK_TIMES object:nil];
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//	// Do any additional setup after loading the view.
//    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"the-lowest-bg"]];
//    
//    UIImage *image = [UIImage imageNamed:@"the-lowest-bg"];
//    self.view.layer.contents = (id) image.CGImage;
//    
//    _boardArray = [[NSMutableArray alloc]init];
//    _dicUpdateControl = [[NSMutableDictionary alloc]init];
//    
//    _strFirstPageId = @"";
//    _strLastPageId = @"";
//    _bUpHandleLoading = NO;
//    _blDownHandleLoading = NO;
//    
//    [self generateGameItems];
//    [self initNotifyMsg];
//    [self generateMainTitleView];
//    [self generateMainContentView];
//}
//
///*- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
//    
//    if (userInfo != nil) {
//        //Load Friend LeadBoard
//        [self handleUpdateLeadBoard];
//
//        //Load current week task
//        [self reloadTasksData];
//    }
//}*/
//
//#pragma mark Statistics Function Interface Logic
//-(UIImage *)getImageFromImage:(UIImage*) superImage Position:(CGRect) subImageRect
//{
//    CGFloat scale = [[UIScreen mainScreen] scale];
//    subImageRect = CGRectMake(subImageRect.origin.x * scale, subImageRect.origin.y * scale, subImageRect.size.width * scale, subImageRect.size.height * scale);
//    CGSize subImageSize = CGSizeMake(subImageRect.size.width, subImageRect.size.height);
//    CGImageRef imageRef = superImage.CGImage;
//    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
//    UIGraphicsBeginImageContext(subImageSize);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextScaleCTM(context, scale, scale);
//    CGContextDrawImage(context, subImageRect, subImageRef);
//    UIImage* subImage = [UIImage imageWithCGImage:subImageRef];
//    CGImageRelease(subImageRef);
//    UIGraphicsEndImageContext();
//    return subImage;
//}
//
//-(void)setMainTaskViewValue:(NSString*)strPre Value:(CGFloat)fValue
//{
//    NSDictionary *attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:12], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
//    NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:strPre attributes:attribs];
//    
//    attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:20], NSForegroundColorAttributeName:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0]};
//    NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %.1f ", fValue] attributes:attribs];
//    
//    attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:12], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
//    NSAttributedString * strPart3Value = [[NSAttributedString alloc] initWithString:@"KM" attributes:attribs];
//    
//    NSMutableAttributedString * strValue = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
//    [strValue appendAttributedString:strPart2Value];
//    [strValue appendAttributedString:strPart3Value];
//    
//    UILabel *lbValue = (UILabel*)[_dicUpdateControl objectForKey:@"ActualLabel"];
//    lbValue.attributedText = strValue;
//}
//
//#pragma mark - Generate Controls
//
//-(UIView*)generateMainTitleViewItem:(NSString*)strTitle BgView:(NSString*)strBgViewPng ScoreValue:(NSString*)strScoreValue
//{
//    UIImage *imgBk = [UIImage imageNamed:strBgViewPng];
//    UIView* viewItem = [[UIView alloc]init];
//    viewItem.layer.contents = (id) imgBk.CGImage;
//    //viewItem.backgroundColor = [UIColor colorWithPatternImage:imgBk];
//
//    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 30, 10)];
//    labelTitle.backgroundColor = [UIColor clearColor];
//    labelTitle.textColor = [UIColor colorWithRed:112.0 / 255.0 green:230.0 / 255.0 blue:243.0 / 255.0 alpha:1.0];
//    labelTitle.text = strTitle;
//    labelTitle.textAlignment = NSTextAlignmentLeft;
//    labelTitle.font = [UIFont boldSystemFontOfSize:11];
//    [viewItem addSubview:labelTitle];
//    
//    AAAScoreView *scoreView = [[AAAScoreView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(labelTitle.frame) + 5, 35, 10)];
//    scoreView.backgroundColor = [UIColor clearColor];
//    [scoreView setScoreLabelColor:[UIColor whiteColor]];
//    [scoreView setChangeScoreLabelColor:[UIColor colorWithRed:244 / 255.0 green:237 / 255.0 blue:0 / 255.0 alpha:1.0]];
//    [scoreView setScoreLabelFont:[UIFont systemFontOfSize:11]];
//    [scoreView setScoreTextAlignment:NSTextAlignmentRight];
//    /*UILabel *labelScore = [[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(labelTitle.frame) + 5, 30, 10)];
//    labelScore.backgroundColor = [UIColor clearColor];
//    labelScore.textColor = [UIColor whiteColor];
//    labelScore.text = strScoreValue;
//    labelScore.textAlignment = NSTextAlignmentLeft;
//    labelScore.font = [UIFont systemFontOfSize:11];
//    [viewItem addSubview:labelScore];*/
//    [viewItem addSubview:scoreView];
//    
//    viewItem.frame = CGRectMake(0, 0, imgBk.size.width, imgBk.size.height);
//    [_dicUpdateControl setObject:scoreView forKey:strTitle];
//    
//    return viewItem;
//}
//
//-(void)generateMainTitleView
//{
//    UIView *viewSport = [self generateMainTitleViewItem:@"体魄" BgView:@"status-run" ScoreValue:@"0"];
//    CGRect rect = viewSport.frame;
//    rect.origin = CGPointMake(5, 25);
//    viewSport.frame = rect;
//    [self.view addSubview:viewSport];
//    
//    CSButton *btnSport = [CSButton buttonWithType:UIButtonTypeCustom];
//    btnSport.frame = viewSport.frame;
//    btnSport.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:btnSport];
//    
//    __weak __typeof(self) weakSelf = self;
//    
//    btnSport.actionBlock = ^void()
//    {
//        __typeof(self) strongSelf = weakSelf;
//        
//        RecordSportViewController *recordSportViewController = [[RecordSportViewController alloc]init];
//        [strongSelf.navigationController pushViewController:recordSportViewController animated:YES];
//    };
//    
//    UIView *viewLiterature = [self generateMainTitleViewItem:@"文学" BgView:@"status-blog" ScoreValue:@"0"];
//    rect = viewLiterature.frame;
//    rect.origin = CGPointMake(CGRectGetMaxX(viewSport.frame) + 7, 25);
//    viewLiterature.frame = rect;
//    [self.view addSubview:viewLiterature];
//    
//    CSButton *btnLiterature = [CSButton buttonWithType:UIButtonTypeCustom];
//    btnLiterature.frame = viewLiterature.frame;
//    btnLiterature.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:btnLiterature];
//    
//    btnLiterature.actionBlock = ^void()
//    {
//        __typeof(self) strongSelf = weakSelf;
//        
//        ArticlePublicViewController* articlePublicViewController = [[ArticlePublicViewController alloc]init];
//        [strongSelf.navigationController pushViewController:articlePublicViewController animated:YES];
//    };
//    
//    UIView *viewMagic = [self generateMainTitleViewItem:@"魔法" BgView:@"status-magic" ScoreValue:@"0"];
//    rect = viewMagic.frame;
//    rect.origin = CGPointMake(CGRectGetMaxX(viewLiterature.frame) + 7, 25);
//    viewMagic.frame = rect;
//    [self.view addSubview:viewMagic];
//    
//    CSButton *btnMagic = [CSButton buttonWithType:UIButtonTypeCustom];
//    btnMagic.frame = viewMagic.frame;
//    btnMagic.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:btnMagic];
//    
//    btnMagic.actionBlock = ^void()
//    {
//        __typeof(self) strongSelf = weakSelf;
//        
//        GameViewController *gameViewController = [[GameViewController alloc]init];
//        [strongSelf.navigationController pushViewController:gameViewController animated:YES];
//    };
//    
//    UIView *viewBtc = [self generateMainTitleViewItem:@"金币" BgView:@"status-money" ScoreValue:@"0"];
//    rect = viewBtc.frame;
//    rect.origin = CGPointMake(CGRectGetMaxX(viewMagic.frame) + 7, 25);
//    viewBtc.frame = rect;
//    [self.view addSubview:viewBtc];
//    
//    CSButton *btnBtc = [CSButton buttonWithType:UIButtonTypeCustom];
//    btnBtc.frame = viewBtc.frame;
//    btnBtc.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:btnBtc];
//    
//    btnBtc.actionBlock = ^void()
//    {
//        __typeof(self) strongSelf = weakSelf;
//        
//        CoinCardViewController *coinCardViewController = [[CoinCardViewController alloc]init];
//        [strongSelf.navigationController pushViewController:coinCardViewController animated:YES];
//    };
//}
//
//-(UIView*)generateMainContentViewItem:(NSString*)strTitle
//{
//    CGFloat fHeight = 0.0;
//    
//    if ([strTitle isEqualToString:@"好友排行榜"]) {
//        fHeight = 190;
//    }
//    else
//    {
//        fHeight = 250;
//    }
//    
//    UIView *viewItem = [[UIView alloc]init];
//    viewItem.backgroundColor = [UIColor clearColor];
//    viewItem.frame = CGRectMake(5, 0, m_scrollView.frame.size.width - 10, fHeight);
//    
//    UIImage *imgBk = [UIImage imageNamed:@"header-small"];
//    imgBk = [imgBk resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(imgBk.size.height / 2) - 2, floorf(imgBk.size.width / 2) - 2, floorf(imgBk.size.height / 2) + 2, floorf(imgBk.size.width / 2) + 2)];
//    
//    UIImageView *imageViewTop = [[UIImageView alloc]init];
//    imageViewTop.frame = CGRectMake(0, 0, CGRectGetWidth(viewItem.frame), imgBk.size.height);
//    imgBk = [UIImage imageFitForSize:CGSizeMake(CGRectGetWidth(viewItem.frame), imgBk.size.height) forSourceImage:imgBk];
//    [imageViewTop setImage:imgBk];
//    [viewItem addSubview:imageViewTop];
//
//    UIView *viewBottom = [[UIView alloc]init];
//    viewBottom.frame = CGRectMake(0, CGRectGetHeight(imageViewTop.frame), CGRectGetWidth(viewItem.frame), fHeight - CGRectGetHeight(imageViewTop.frame));
//    viewBottom.tag = VIEW_BOARD_BOTTOM_VIEW;
//    [viewItem addSubview:viewBottom];
//    
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:viewBottom.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = viewBottom.bounds;
//    maskLayer.path = maskPath.CGPath;
//    viewBottom.layer.mask = maskLayer;
//    
//    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake((m_scrollView.frame.size.width - 150) / 2, 5, 150, 20)];
//    labelTitle.backgroundColor = [UIColor clearColor];
//    labelTitle.textColor = [UIColor whiteColor];
//    labelTitle.text = strTitle;
//    labelTitle.textAlignment = NSTextAlignmentCenter;
//    labelTitle.font = [UIFont boldSystemFontOfSize:14];
//    [viewItem addSubview:labelTitle];
//    
//    return viewItem;
//}
//
//-(UIView*)generateMainTaskView:(CGRect)rectFrame
//{
//    UIView *viewMainTask = [[UIView alloc]init];
//    viewMainTask.backgroundColor = [UIColor clearColor];
//    viewMainTask.frame = CGRectMake(0, 0, rectFrame.size.width, rectFrame.size.height);
//
//    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 115, 115)];
//    [imgView setImage:[UIImage imageNamed:@"image-placeholder"]];
//    imgView.layer.cornerRadius = 10.0;
//    imgView.layer.masksToBounds = YES;
//    [viewMainTask addSubview:imgView];
//    
//    CSButton *btnProfiel = [CSButton buttonWithType:UIButtonTypeCustom];
//    btnProfiel.frame = imgView.frame;
//    btnProfiel.backgroundColor = [UIColor clearColor];
//    [viewMainTask addSubview:btnProfiel];
//    
//    __weak __typeof(self) weakSelf = self;
//
//    btnProfiel.actionBlock = ^void()
//    {
//        __typeof(self) strongSelf = weakSelf;
//        
//        UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
//        AccountPreViewController *accountPreViewController = [[AccountPreViewController alloc]init];
//        accountPreViewController.strUserId = userInfo.userid;
//        [strongSelf.navigationController pushViewController:accountPreViewController animated:YES];
//    };
//
//    UILabel *labelActual = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame) + 10, 120, 20)];
//    labelActual.backgroundColor = [UIColor clearColor];
//    labelActual.textAlignment = NSTextAlignmentCenter;
//    [viewMainTask addSubview:labelActual];
//    
//    UIImage *imgRunway = [UIImage imageNamed:@"home-task-progress-bg"];
//    UIImageView *imgViewRunway = [[UIImageView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(labelActual.frame) + 15, 110, 25)];
//    [imgViewRunway setImage:imgRunway];
//    [viewMainTask addSubview:imgViewRunway];
//    
//    UIImageView *imgViewBottom = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMinY(imgViewRunway.frame) + (25 / 2 - 3), 80, 6)];
//    [imgViewBottom setImage:[UIImage imageNamed:@"home-task-progress-white"]];
//    [viewMainTask addSubview:imgViewBottom];
//    
//    UIImageView *imgViewTop = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMinY(imgViewRunway.frame) + (25 / 2 - 3), 80, 6)];
//    [imgViewTop setImage:[UIImage imageNamed:@"home-task-progress-blue"]];
//    [viewMainTask addSubview:imgViewTop];
//    
//    UIImageView *imgViewRunner = [[UIImageView alloc]initWithFrame:CGRectMake(5, CGRectGetMinY(imgViewRunway.frame), 24, 25)];
//    [imgViewRunner setImage:[UIImage imageNamed:@"home-task-runner"]];
//    [viewMainTask addSubview:imgViewRunner];
//    
//    UILabel *labelTask = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgViewBottom.frame) + 2, CGRectGetMinY(imgViewRunway.frame), 15, 25)];
//    labelTask.backgroundColor = [UIColor clearColor];
//    labelTask.textAlignment = NSTextAlignmentCenter;
//    labelTask.textColor = [UIColor darkGrayColor];
//    labelTask.font = [UIFont systemFontOfSize:8];
//    labelTask.numberOfLines = 0;
//    labelTask.text = [NSString stringWithFormat:@"%d\n%@", 0, @"km"];
//    [viewMainTask addSubview:labelTask];
//    
//    /*UILabel *labelNickName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(imgView.frame) - 50, CGRectGetMaxY(imgView.frame) + 5, 100, 20)];
//    labelNickName.backgroundColor = [UIColor clearColor];
//    labelNickName.textColor = [UIColor blackColor];
//    labelNickName.text = @"";
//    labelNickName.textAlignment = NSTextAlignmentCenter;
//    labelNickName.font = [UIFont boldSystemFontOfSize:12];
//    [viewMainTask addSubview:labelNickName];
//    
//    UIImage *imgLev = [UIImage imageNamed:@"level-bg"];
//    UIImageView* imgLevelBK = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(imgView.frame) - imgLev.size.width / 2, CGRectGetMaxY(labelNickName.frame) + 5, imgLev.size.width, imgLev.size.height)];
//    //imgBK = [imgBK stretchableImageWithLeftCapWidth:floorf(imgBK.size.width/2) topCapHeight:floorf(imgBK.size.height/2)];
//    imgLevelBK.image = imgLev;
//    [viewMainTask addSubview:imgLevelBK];
//    
//    UILabel *labelLevel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(imgView.frame) - imgLev.size.width / 2, CGRectGetMaxY(labelNickName.frame) + 5, imgLev.size.width, imgLev.size.height)];
//    //labelLevel.backgroundColor = [UIColor colorWithPatternImage:imgLev];
//    //labelLevel.layer.contents = (id) imgLev.CGImage;
//    labelLevel.backgroundColor = [UIColor clearColor];
//    labelLevel.textColor = [UIColor whiteColor];
//    labelLevel.text = @"";
//    labelLevel.textAlignment = NSTextAlignmentCenter;
//    labelLevel.font = [UIFont italicSystemFontOfSize:10];
//    [viewMainTask addSubview:labelLevel];
//    
//    UILabel *labelTotal = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(imgView.frame) - 50, CGRectGetMaxY(labelLevel.frame) + 5, 100, 20)];
//    labelTotal.backgroundColor = [UIColor clearColor];
//    labelTotal.textColor = [UIColor colorWithRed:162.0 / 255.0 green:129.0 / 255.0 blue:0.0 / 255.0 alpha:1];
//    labelTotal.text = @"";
//    labelTotal.textAlignment = NSTextAlignmentCenter;
//    labelTotal.font = [UIFont boldSystemFontOfSize:12];
//    [viewMainTask addSubview:labelTotal];*/
//    
//    m_viewWeekTasks = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame) + 5, 10, CGRectGetWidth(viewMainTask.frame) - 20 -  CGRectGetMaxX(imgView.frame), CGRectGetHeight(viewMainTask.frame) - 10)];
//    m_viewWeekTasks.backgroundColor = [UIColor clearColor];
//    [viewMainTask addSubview:m_viewWeekTasks];
//    
//    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((CGRectGetWidth(m_viewWeekTasks.frame) - 20) / 2, (CGRectGetHeight(m_viewWeekTasks.frame) - 20) / 2, 20.0f, 20.0f)];
//    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
//    [activityIndicator setTag:VIEW_TASKS_ACTIVITY_INDICATORVIEW];
//    [m_viewWeekTasks addSubview:activityIndicator];
//    [activityIndicator startAnimating];
//
//    //[_dicUpdateControl setObject:labelNickName forKey:@"NickName"];
//    //[_dicUpdateControl setObject:labelLevel forKey:@"Level"];
//    [_dicUpdateControl setObject:imgView forKey:@"UserImg"];
//    [_dicUpdateControl setObject:labelActual forKey:@"ActualLabel"];
//    [_dicUpdateControl setObject:labelTask forKey:@"TaskLabel"];
//    [_dicUpdateControl setObject:imgViewTop forKey:@"ActualProcess"];
//    [_dicUpdateControl setObject:imgViewRunner forKey:@"ActualRunner"];
//    
//    //[_dicUpdateControl setObject:labelTotal forKey:@"TotalSocore"];
//    
//    [self setMainTaskViewValue:@"还需完成" Value:0.0];
//    
//    float fPercent = 0.0;
//    UIImage *image = [UIImage imageNamed:@"home-task-progress-blue"];
//    CGRect rectImageOver = CGRectMake(0, 0, image.size.width * fPercent, image.size.height);
//    UIImage *imageNew = [self getImageFromImage:image Position:rectImageOver];
//    imgViewTop.frame = CGRectMake(15, 180, image.size.width * fPercent, 6);
//    [imgViewTop setImage:imageNew];
//
//    imgViewRunner.frame = CGRectMake(5 + image.size.width * fPercent, 170, 24, 25);
//    
//    return viewMainTask;
//}
//
//-(void)generateGameItems
//{
//    m_gameItems = [[NSMutableArray alloc]init];
//    
//    GameItem *gameItem = [[GameItem alloc]init];
//    gameItem.gameTitle = @"熊出没";
//    gameItem.gameImg = @"game-bear";
//    gameItem.eGameType = e_game_xiongchumo;
//    [m_gameItems addObject:gameItem];
//    
//    gameItem = [[GameItem alloc]init];
//    gameItem.gameTitle = @"爱之跳跳";
//    gameItem.gameImg = @"game-qixi";
//    gameItem.eGameType = e_game_qixi;
//    [m_gameItems addObject:gameItem];
//    
//    gameItem = [[GameItem alloc]init];
//    gameItem.gameTitle = @"蜘蛛侠";
//    gameItem.gameImg = @"game-lineLife";
//    gameItem.eGameType = e_game_spiderman;
//    [m_gameItems addObject:gameItem];
//    
//    gameItem = [[GameItem alloc]init];
//    gameItem.gameTitle = @"古墓历险";
//    gameItem.gameImg = @"game-escape";
//    gameItem.eGameType = e_game_mishi;
//    [m_gameItems addObject:gameItem];
//    
//    gameItem = [[GameItem alloc]init];
//    gameItem.gameTitle = @"幸运转盘";
//    gameItem.gameImg = @"game-rotate";
//    gameItem.eGameType = e_game_znm;
//    [m_gameItems addObject:gameItem];
//}
//
//-(void)createTaskItems:(NSArray*)arrTaskItems
//{
//    BOOL bFinished = YES;
//    CGFloat fBtnY = 0;
//
//    for (UIView *view in [m_viewWeekTasks subviews]){
//        [view removeFromSuperview];
//    }
//    
//    for (int i = 0; i < [arrTaskItems count]; i++) {
//        TasksInfo *taskInfo = arrTaskItems[i];
//        e_task_status eTaskStatus = [CommonFunction ConvertStringToTaskStatusType:taskInfo.task_status];
//        
//        CSButton *btnTaskItem = [CSButton buttonWithType:UIButtonTypeCustom];
//        
//        UIImage *image = nil;
//        UIImage *imageDisable = nil;
//        e_task_type eTaskType = [CommonFunction ConvertStringToTaskType:taskInfo.task_type];
//        
//        if (taskInfo.task_id == 1) {
//            image = [UIImage imageNamed:@"task-tutorial"];
//            imageDisable = [UIImage imageNamed:@"task-tutorial"];
//        }
//        else if (eTaskType == e_task_physique) {
//            image = [UIImage imageNamed:@"task-run"];
//            imageDisable = [UIImage imageNamed:@"task-run-finished"];
//        }
//        else if(eTaskType == e_task_literature)
//        {
//            image = [UIImage imageNamed:@"task-blog"];
//            imageDisable = [UIImage imageNamed:@"task-blog-finished"];
//        }
//        else
//        {
//            image = [UIImage imageNamed:@"task-magic"];
//            imageDisable = [UIImage imageNamed:@"task-magic-finished"];
//        }
//
//        CGFloat fBtnWidth = image.size.width;
//        
//        if (i % 3 == 0 && i > 0) {
//            fBtnY += (7 + fBtnWidth);
//        }
//        
//        btnTaskItem.frame = CGRectMake((5 + fBtnWidth) * (i % 3), fBtnY, fBtnWidth, fBtnWidth);
//        [btnTaskItem setBackgroundImage:image forState:UIControlStateNormal];
//        [btnTaskItem setBackgroundImage:imageDisable forState:UIControlStateDisabled];
//        [m_viewWeekTasks addSubview:btnTaskItem];
//        
//        __weak __typeof(self) weakSelf = self;
//
//        btnTaskItem.actionBlock = ^void()
//        {
//            __typeof(self) strongSelf = weakSelf;
//            
//            if (taskInfo.task_id == 1) {
//                HelpUsedViewController *helpUsedViewController = [[HelpUsedViewController alloc]init];
//                helpUsedViewController.taskInfo = taskInfo;
//                [strongSelf.navigationController pushViewController:helpUsedViewController animated:YES];
//            }
//            else if (eTaskStatus == e_task_normal) {
//                NSLog(@"Current Task Id is %ld!", taskInfo.task_id);
//                
//                if (eTaskType == e_task_physique) {
//                    TaskViewController *taskViewController = [[TaskViewController alloc]init];
//                    taskViewController.taskInfo = taskInfo;
//                    [strongSelf.navigationController pushViewController:taskViewController animated:YES];
//                }
//                else if(eTaskType == e_task_literature)
//                {
//                    ArticlePublicViewController* articlePublicViewController = [[ArticlePublicViewController alloc]init];
//                    articlePublicViewController.taskInfo = taskInfo;
//                    articlePublicViewController.strTitle = @"发表博文任务";
//                    [strongSelf.navigationController pushViewController:articlePublicViewController animated:YES];
//                }
//                else
//                {
//                    NSString *strGameDir = @"";
//                    GameItem *gameItem = strongSelf->m_gameItems[arc4random() % (strongSelf->m_gameItems.count)];
//                    
//                    if ([gameItem.gameTitle isEqualToString:@"熊出没"]) {
//                        strGameDir = @"xiongchumo";
//                    }
//                    else if([gameItem.gameTitle isEqualToString:@"爱之跳跳"])
//                    {
//                        strGameDir = @"qixi";
//                    }
//                    else if([gameItem.gameTitle isEqualToString:@"蜘蛛侠"])
//                    {
//                        strGameDir = @"spiderman";
//                    }
//                    else if([gameItem.gameTitle isEqualToString:@"古墓历险"])
//                    {
//                        strGameDir = @"mishi";
//                    }
//                    else if([gameItem.gameTitle isEqualToString:@"幸运转盘"])
//                    {
//                        strGameDir = @"znm";
//                    }
//                    
//                    WebGameViewController *webGameViewController = [[WebGameViewController alloc]init];
//                    webGameViewController.gameTitle = gameItem.gameTitle;
//                    webGameViewController.eGameType = gameItem.eGameType;
//                    webGameViewController.gameDir = strGameDir;
//                    webGameViewController.taskInfo = taskInfo;
//                    [strongSelf.navigationController pushViewController:webGameViewController animated:YES];
//                }
//            }
//            else
//            {
//                TaskHistoryViewController *taskHistoryViewController = [[TaskHistoryViewController alloc]init];
//                taskHistoryViewController.taskId = taskInfo.task_id;
//                taskHistoryViewController.eTaskType = eTaskType;
//                [strongSelf.navigationController pushViewController:taskHistoryViewController animated:YES];
//            }
//        };
//        
//        UIImage *imageStatus = nil;
//        
//        if (eTaskStatus == e_task_finish) {
//            imageStatus = [UIImage imageNamed:@"task-finished"];
//        }
//        else if(eTaskStatus == e_task_authentication)
//        {
//            imageStatus = [UIImage imageNamed:@"task-waiting"];
//        }
//        else if(eTaskStatus == e_task_unfinish)
//        {
//            imageStatus = [UIImage imageNamed:@"task-fail"];
//        }
//        
//        if (imageStatus != nil) {
//            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(btnTaskItem.frame) + 5, CGRectGetMaxY(btnTaskItem.frame) - imageStatus.size.width - 5, imageStatus.size.width, imageStatus.size.height)];
//            [imageView setImage:imageStatus];
//            [m_viewWeekTasks addSubview:imageView];
//        }
//        
//        if (eTaskStatus != e_task_finish) {
//            bFinished = NO;
//        }
//    }
//    
//    [self checkFirstRegsiter];
//    
//    //Update Task Process
//    UILabel *labelTask = (UILabel*)[_dicUpdateControl objectForKey:@"TaskLabel"];
//    UIImageView *imgViewTop = (UIImageView*)[_dicUpdateControl objectForKey:@"ActualProcess"];
//    UIImageView *imgViewRunner = (UIImageView*)[_dicUpdateControl objectForKey:@"ActualRunner"];
//    
//    labelTask.text = [NSString stringWithFormat:@"%.1f\n%@", m_tasksInfoList.task_target_distance / 1000.0, @"km"];
//    
//    if (m_tasksInfoList.task_target_distance >= m_tasksInfoList.task_actual_distance) {
//        [self setMainTaskViewValue: @"还需完成" Value:(m_tasksInfoList.task_target_distance - m_tasksInfoList.task_actual_distance) / 1000.0];
//    }
//    else
//    {
//        [self setMainTaskViewValue: @"超额完成" Value:(m_tasksInfoList.task_actual_distance - m_tasksInfoList.task_target_distance) / 1000.0];
//    }
//    
//    float fPercent = m_tasksInfoList.task_actual_distance * 1.0 / m_tasksInfoList.task_target_distance;
//    UIImage *image = [UIImage imageNamed:@"home-task-progress-blue"];
//    CGRect rectImageOver = CGRectMake(0, 0, image.size.width * (fPercent >= 1 ? 1.0 : fPercent), image.size.height);
//    UIImage *imageNew = [self getImageFromImage:image Position:rectImageOver];
//    [imgViewTop setImage:imageNew];
//    [imgViewRunner setImage:[UIImage imageNamed:bFinished ? @"home-task-runner-finished" : @"home-task-runner"]];
//    
//    [UIView animateWithDuration:1.0 animations:^{
//        imgViewTop.frame = CGRectMake(15, 180, image.size.width * (fPercent >= 1 ? 1.0 : fPercent), 6);
//        imgViewRunner.frame = CGRectMake(5 + image.size.width * (fPercent >= 1 ? 0.95 : fPercent), 170, 24, 25);
//    } completion:^(BOOL finished){
//    }];
//}
//
//-(void)createBoardTable:(CGRect)rectTable
//{
//    m_tableBoard = [[UITableView alloc] initWithFrame:rectTable style:UITableViewStylePlain];
//    m_tableBoard.delegate = self;
//    m_tableBoard.dataSource = self;
//    m_tableBoard.scrollEnabled = YES;
//    m_tableBoard.backgroundColor = [UIColor clearColor];
//    m_tableBoard.separatorColor = [UIColor clearColor];
//    
//    if ([m_tableBoard respondsToSelector:@selector(setSeparatorInset:)]) {
//        [m_tableBoard setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    //Create BottomView For Table
//    m_tableBoard.tableFooterView = nil;
//    m_tableBoard.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, m_tableBoard.frame.size.width, 10.0f)];
//    _tableFooterActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
//    [_tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
//    [_tableFooterActivityIndicator setCenter:[m_tableBoard.tableFooterView center]];
//    [m_tableBoard.tableFooterView addSubview:_tableFooterActivityIndicator];
//    
//    //Create TopView For Table
//    _egoRefreshTableHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - m_tableBoard.frame.size.height, m_tableBoard.frame.size.width, m_tableBoard.frame.size.height)];
//    _egoRefreshTableHeaderView.delegate = (id<EGORefreshTableHeaderDelegate>)self;
//    _egoRefreshTableHeaderView.backgroundColor = [UIColor clearColor];
//    [m_tableBoard addSubview:_egoRefreshTableHeaderView];
//    
//    //  update the last update date
//    [_egoRefreshTableHeaderView refreshLastUpdatedDate];
//}
//
//-(void)generateMainContentView
//{
//    m_scrollView = [[SFUIScrollView alloc]initWithFrame:CGRectMake(0, 70, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 49 - 65)];
//    m_scrollView.backgroundColor = [UIColor clearColor];
//    m_scrollView.scrollEnabled = YES;
//    [self.view addSubview:m_scrollView];
//    
//    UIView *viewSpord = [self generateMainContentViewItem:@"好友排行榜"];
//    CGRect rect = viewSpord.frame;
//    rect.origin = CGPointMake(5, 0);
//    viewSpord.frame = rect;
//
//    UIView *viewBottom = [viewSpord viewWithTag:VIEW_BOARD_BOTTOM_VIEW];
//    viewBottom.backgroundColor = APP_MAIN_BG_COLOR;
//    rect = CGRectMake(2, 2, viewBottom.frame.size.width - 4, viewBottom.frame.size.height - 2);
//    [self createBoardTable:rect];
//    [viewBottom addSubview:m_tableBoard];
//    [viewBottom bringSubviewToFront:m_tableBoard];
//    
//    m_viewFriendBoard = [[UIView alloc]initWithFrame:CGRectMake(10, 20, CGRectGetWidth(viewBottom.frame) - 20, 80)];
//    m_viewFriendBoard.backgroundColor = [UIColor clearColor];
//    m_viewFriendBoard.hidden = YES;
//    [viewBottom addSubview:m_viewFriendBoard];
//    
//    UILabel *lbFriend = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, CGRectGetWidth(m_viewFriendBoard.frame) - 20, 20)];
//    lbFriend.backgroundColor = [UIColor clearColor];
//    lbFriend.text = @"你还没有朋友~快去邀请吧";
//    lbFriend.textColor = [UIColor darkGrayColor];
//    lbFriend.textAlignment = NSTextAlignmentCenter;
//    lbFriend.font = [UIFont boldSystemFontOfSize:14];
//    [m_viewFriendBoard addSubview:lbFriend];
//    
//    CSButton *btnFriend = [CSButton buttonWithType:UIButtonTypeCustom];
//    btnFriend.frame = CGRectMake((CGRectGetWidth(m_viewFriendBoard.frame) - 123) / 2, CGRectGetMaxY(lbFriend.frame) + 10, 123, 38);
//    [btnFriend setTitle:@"添加好友" forState:UIControlStateNormal];
//    [btnFriend setBackgroundImage:[UIImage imageNamed:@"btn-3-blue"] forState:UIControlStateNormal];
//    btnFriend.titleLabel.font = [UIFont boldSystemFontOfSize:14];
//    [btnFriend setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [btnFriend setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//    [m_viewFriendBoard addSubview:btnFriend];
//    
//    __weak typeof (self) thisPoint = self;
//    
//    btnFriend.actionBlock = ^void()
//    {
//        typeof(self) thisStrongPoint = thisPoint;
//        MobileFriendViewController *mobileFriendViewController = [[MobileFriendViewController alloc]init];
//        [thisStrongPoint.navigationController pushViewController:mobileFriendViewController animated:YES];
//    };
//    
//    [m_scrollView addSubview:viewSpord];
//
//    UIView *viewTasks = [self generateMainContentViewItem:@"任务"];
//    rect = viewTasks.frame;
//    rect.origin = CGPointMake(5, CGRectGetMaxY(viewSpord.frame) + 5);
//    viewTasks.frame = rect;
//    
//    UIView *viewBottomDown = [viewTasks viewWithTag:VIEW_BOARD_BOTTOM_VIEW];
//    viewBottomDown.backgroundColor = APP_MAIN_BG_COLOR;
//    
//    UIView *viewTaskContent = [self generateMainTaskView:viewBottomDown.frame];
//    [viewBottomDown addSubview:viewTaskContent];
//    [m_scrollView addSubview:viewTasks];
//    
//    CGSize contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetHeight(viewTasks.frame) + CGRectGetMinY(viewTasks.frame) + 10);
//    [m_scrollView setContentSize:contentSize];
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//-(void)dealloc
//{
//    NSLog(@"MainViewController dealloc");
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [_boardArray count];
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    LeaderBoardItem *leaderBoardItem = _boardArray[indexPath.row];
//    leaderBoardItem.index = indexPath.row + 1;
//    BoardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BoardCell"];
//    
//    if (cell == nil) {
//        cell = [[BoardCell alloc]initWithReuseIdentifier:@"BoardCell"];
//    }
//    
//    __weak __typeof(self) weakSelf = self;
//    
//    cell.pkClickBlock = ^void()
//    {
//        __typeof(self) strongSelf = weakSelf;
//        
//        //[strongSelf updateBoardPkTimes:leaderBoardItem.userid];
//        PKViewController *pkViewController = [[PKViewController alloc]init];
//        pkViewController.leaderBoardItem = leaderBoardItem;
//        [strongSelf.navigationController pushViewController:pkViewController animated:YES];
//    };
//    
//    cell.leaderBoardItem = leaderBoardItem;
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [BoardCell heightOfCell];
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_boardArray count] > 0) {
//        LeaderBoardItem *leaderBoardItem = _boardArray[indexPath.row];
//        AccountPreViewController *accountPreViewController = [[AccountPreViewController alloc]init];
//        accountPreViewController.strUserId = leaderBoardItem.userid;
//        [self.navigationController pushViewController:accountPreViewController animated:YES];
//    }
//}
//
///*-(void)handleUpdatePkTimes:(NSNotification*) notification
//{
//    NSString *strPKUserId = [notification.userInfo objectForKey:@"PKUserId"];
//    NSString *strPKName = [notification.userInfo objectForKey:@"PKNikeName"];
//    
//    NSMutableDictionary * boardDict = [[ApplicationContext sharedInstance] getObjectByKey:@"BoardPkTimes"];
//
//    if ([boardDict objectForKey:strPKUserId] != nil) {
//        NSUInteger nTimes = [[boardDict objectForKey:strPKUserId]unsignedIntegerValue];
//        NSString *strTips = @"";
//        
//        if (nTimes > 0) {
//            strTips = [NSString stringWithFormat:@"亲，您已与%@PK了%lu次，今天还剩余%lu次机会哦~", strPKName, (3 - nTimes), (unsigned long)nTimes];
//        }
//        else
//        {
//            strTips = [NSString stringWithFormat:@"亲，您已与%@PK了3次，请明天继续挑战他(她)哦~", strPKName];
//        }
//        
//        [AlertManager showAlertText:strTips];
//    }
//    
//    [self handleUpdateLeadBoard];
//}*/
//
//-(void)handleGetMainInfo
//{
//    //Load Friend LeadBoard
//    [self handleUpdateLeadBoard];
//    
//    //Load current week task
//    [self reloadTasksData];
//    
//    //Load user Properties
//    [self reloadUserPropertiesData:NO];
//    
//    //Check First Reward
//    [self checkDailyFirstLogin];
//    
//    //Get System Config Info
//    [[ApplicationContext sharedInstance]getSysConfigInfo];
//}
//
//-(void)handleUpdateLeadBoard
//{
//    _strFirstPageId = @"";
//    
//    //Load Friend LeadBoard
//    [self reloadLeadBoardData];
//}
//
//-(void)handleUpdateTaskStatus
//{
//    //Load current week task
//    [self reloadTasksData];
//}
//
//-(void)handleUpdateProfileInfo:(NSNotification*) notification
//{
//    BOOL bAddEffect = NO;
//    ExpEffect* expEffect = [notification.userInfo objectForKey:@"RewardEffect"];
//    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
//    
//    if (userInfo != nil && expEffect != nil && (expEffect.exp_physique > 0 || expEffect.exp_literature > 0 || expEffect.exp_magic > 0 || expEffect.exp_coin > 0)) {
//        bAddEffect = YES;
//        userInfo.proper_info.physique_value += expEffect.exp_physique;
//        userInfo.proper_info.literature_value += expEffect.exp_literature;
//        userInfo.proper_info.magic_value += expEffect.exp_magic;
//        userInfo.proper_info.coin_value += expEffect.exp_coin;
//    }
//    
//    //Load user Properties
//    [self reloadUserPropertiesData:bAddEffect];
//}
//
//-(void)handleProgramResign
//{
//    if (m_timeReward != nil) {
//        [m_timeReward invalidate];
//        m_timeReward = nil;
//    }
//}
//
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//-(void)reloadUserPropertiesData:(BOOL)bAddScore
//{
//    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
//    
//    if(userInfo.userid.length > 0)
//    {
//        AAAScoreView *scoreViewPhysique = [_dicUpdateControl objectForKey:@"体魄"];
//        AAAScoreView *scoreViewLiterature = [_dicUpdateControl objectForKey:@"文学"];
//        AAAScoreView *scoreViewMagic = [_dicUpdateControl objectForKey:@"魔法"];
//        AAAScoreView *scoreViewCoin = [_dicUpdateControl objectForKey:@"金币"];
//        
//        if (bAddScore) {
//            NSInteger oldScore = [[scoreViewPhysique labelScoreText]integerValue];
//            (userInfo.proper_info.physique_value - oldScore) > 0 ? ([scoreViewPhysique setScoreTo:userInfo.proper_info.physique_value scoreChange:userInfo.proper_info.physique_value - oldScore]) : [scoreViewPhysique setScoreWithoutAnimation:userInfo.proper_info.physique_value];
//            
//            oldScore = [[scoreViewLiterature labelScoreText]integerValue];
//            (userInfo.proper_info.literature_value - oldScore) > 0 ? [scoreViewLiterature setScoreTo:userInfo.proper_info.literature_value scoreChange:userInfo.proper_info.literature_value - oldScore] : [scoreViewLiterature setScoreWithoutAnimation:userInfo.proper_info.literature_value];
//            
//            oldScore = [[scoreViewMagic labelScoreText]integerValue];
//            (userInfo.proper_info.magic_value - oldScore) > 0 ? [scoreViewMagic setScoreTo:userInfo.proper_info.magic_value scoreChange:userInfo.proper_info.magic_value - oldScore] : [scoreViewMagic setScoreWithoutAnimation:userInfo.proper_info.magic_value];
//
//            oldScore = [[scoreViewCoin labelScoreText]integerValue];
//            (userInfo.proper_info.coin_value / 100000000 - oldScore) > 0 ? [scoreViewCoin setScoreTo:userInfo.proper_info.coin_value / 100000000 scoreChange:userInfo.proper_info.coin_value / 100000000 - oldScore] : [scoreViewCoin setScoreWithoutAnimation:userInfo.proper_info.coin_value / 100000000];
//        }
//        else
//        {
//            [scoreViewPhysique setScoreWithoutAnimation:userInfo.proper_info.physique_value];
//            [scoreViewLiterature setScoreWithoutAnimation:userInfo.proper_info.literature_value];
//            [scoreViewMagic setScoreWithoutAnimation:userInfo.proper_info.magic_value];
//            [scoreViewCoin setScoreWithoutAnimation:userInfo.proper_info.coin_value / 100000000];
//        }
//        
//        /*UILabel *lbPhysique = [_dicUpdateControl objectForKey:@"体魄"];
//        lbPhysique.text = [NSString stringWithFormat:@"%ld", userInfo.proper_info.physique_value];
//        
//        UILabel *lbLiterature = [_dicUpdateControl objectForKey:@"文学"];
//        lbLiterature.text = [NSString stringWithFormat:@"%ld", userInfo.proper_info.literature_value];
//        
//        UILabel *lbMagic = [_dicUpdateControl objectForKey:@"魔法"];
//        lbMagic.text = [NSString stringWithFormat:@"%ld", userInfo.proper_info.magic_value];
//        
//        UILabel *lbCoin = [_dicUpdateControl objectForKey:@"金币"];
//        lbCoin.text = [NSString stringWithFormat:@"%lld", userInfo.proper_info.coin_value / 100000000];*/
//        
//        UILabel *lbNickName = [_dicUpdateControl objectForKey:@"NickName"];
//        lbNickName.text = userInfo.nikename;
//        
//        UILabel *lbLevel = [_dicUpdateControl objectForKey:@"Level"];
//        lbLevel.text = [NSString stringWithFormat:@"LV.%ld", userInfo.proper_info.rankLevel];
//        
//        UILabel *lbTotal = [_dicUpdateControl objectForKey:@"TotalSocore"];
//        lbTotal.text = [NSString stringWithFormat:@"总分数: %ld", userInfo.proper_info.rankscore];
//    
//        UIImageView *imgViewUser = [_dicUpdateControl objectForKey:@"UserImg"];
//        [imgViewUser sd_setImageWithURL:[NSURL URLWithString:userInfo.profile_image]
//                           placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
//    }
//}
//
//-(NSString*)generateDaysStringById:(int)nId
//{
//    NSString *strDays = @"第一天";
//    
//    switch (nId) {
//        case 0:
//            strDays = @"第一天";
//            break;
//        case 1:
//            strDays = @"第二天";
//            break;
//        case 2:
//            strDays = @"第三天";
//            break;
//        case 3:
//            strDays = @"第四天";
//            break;
//        case 4:
//            strDays = @"第五天";
//            break;
//        case 5:
//            strDays = @"第六天";
//            break;
//        case 6:
//            strDays = @"第七天";
//            break;
//        default:
//            break;
//    }
//    
//    return strDays;
//}
//
//-(UIView*)generateViewByContinuesLoginDays:(int)nLoginDays LoginRewardList:(NSArray*)arrRewardList
//{
//    UIView *viewDailyReward = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 280, 190)];
//    viewDailyReward.backgroundColor = [UIColor clearColor];
//    
//    for (int i = 0; i < [arrRewardList count]; i++) {
//        int nReward = [arrRewardList[i] intValue];
//        NSString *strBg = @"everyday-prize-bg";
//        
//        if (i < nLoginDays) {
//            strBg = @"everyday-prize-bg-sel";
//        }
//        
//        UIView *viewReward = [[UIView alloc]initWithFrame:CGRectMake(73 * i, 10, 68, 95)];
//        UIImage *image = [UIImage imageNamed:strBg];
//        viewReward.layer.contents = (id) image.CGImage;
//        //viewReward.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:strBg]];
//        
//        UILabel *lbDays = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 50, 15)];
//        lbDays.backgroundColor = [UIColor clearColor];
//        lbDays.textColor = [UIColor whiteColor];
//        lbDays.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//        lbDays.shadowOffset = CGSizeMake(0.0f, 0.5f);
//        lbDays.text = [self generateDaysStringById:i];
//        lbDays.textAlignment = NSTextAlignmentCenter;
//        lbDays.font = [UIFont boldSystemFontOfSize:12];
//        [viewReward addSubview:lbDays];
//        
//        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(viewReward.frame) - 64) / 2, (CGRectGetHeight(viewReward.frame) - 30) / 2, 64, 30)];
//        imgView.backgroundColor = [UIColor clearColor];
//        [imgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"everyday-prize-%d", i + 1]]];
//        [viewReward addSubview:imgView];
//        
//        UILabel *lbCoins = [[UILabel alloc]initWithFrame:CGRectMake((CGRectGetWidth(viewReward.frame) - 50) / 2 , CGRectGetHeight(viewReward.frame) - 20, 50, 15)];
//        lbCoins.backgroundColor = [UIColor clearColor];
//        lbCoins.textColor = [UIColor whiteColor];
//        lbDays.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//        lbDays.shadowOffset = CGSizeMake(0.0f, 0.5f);
//        lbCoins.text = [NSString stringWithFormat:@"%d个金币", nReward / 100000000];
//        lbCoins.textAlignment = NSTextAlignmentCenter;
//        lbCoins.font = [UIFont boldSystemFontOfSize:12];
//        [viewReward addSubview:lbCoins];
//        
//        if (i > 3) {
//            viewReward.frame = CGRectMake(37 + 73 * (i - 4), 115, 68, 95);
//        }
//        
//        [viewDailyReward addSubview:viewReward];
//    }
//    
//    return viewDailyReward;
//}
//
///*-(void)updateProfileInfo:(NSDictionary*) dictUserInfo
//{
//    if (m_timerReward != nil) {
//        dictUserInfo = m_timerReward.userInfo;
//    }
//    
//    NSUInteger nExpCoin = [[dictUserInfo objectForKey:@"Exp_Coins"]unsignedLongValue];
//    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
//    
//    [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
//     {
//         if (errorCode == 0)
//         {
//             ExpEffect *expEffect = [[ExpEffect alloc]init];
//             expEffect.exp_coin = nExpCoin;
//             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", nil]];
//         }
//         
//         [m_timerReward invalidate];
//         m_timerReward = nil;
//     }];
//}*/
//
//-(void)updateProfileInfo
//{
//    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
//    
//    [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
//     {
//         if (errorCode == 0)
//         {
//             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil];
//         }
//     }];
//}
//
//-(void)checkFirstRegsiter
//{
//    BOOL bCheckRegsiter = [[[ApplicationContext sharedInstance]getObjectByKey:@"CheckRegsiter"]boolValue];
//    
//    if (!bCheckRegsiter) {
//        AppDelegate* delegate = [UIApplication sharedApplication].delegate;
//        
//        if([delegate.mainNavigationController.topViewController isKindOfClass:[MainViewController class]])
//        {
//            CGRect rect = [m_viewWeekTasks convertRect:m_viewWeekTasks.frame toView:self.view];
//            //[MLPSpotlight addSpotlightInView:self.view atPoint:CGPointMake(rect.origin.x, rect.origin.y)];
//            //inView = delegate.mainNavigationController.view;
//            
//            [delegate.mainNavigationController startTapTutorialWithInfo:@"点击熟悉任务流程"
//                                                                atPoint:CGPointMake(CGRectGetWidth(self.view.frame) / 2, rect.origin.y - 30)
//                                                   withFingerprintPoint:CGPointMake(CGRectGetWidth(self.view.frame) / 2 - 5, rect.origin.y + 57 / 2.0 - 8)
//                                                   shouldHideBackground:NO];
//        }
//        
//        [[ApplicationContext sharedInstance] saveObject:@(YES) byKey:@"CheckRegsiter"];
//    }
//}
//
//-(void)checkDailyFirstLogin
//{
//    NSDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"LoginInfo"];
//    BOOL bCheckRegsiter = [[[ApplicationContext sharedInstance]getObjectByKey:@"CheckRegsiter"]boolValue];
//    
//    [m_timerReward invalidate];
//    m_timerReward = nil;
//    
//    if (dict != nil && bCheckRegsiter) {
//        int nLoginTimes = [[dict objectForKey:@"login_count"]intValue];
//        
//        if (nLoginTimes == 1) {
//            [self resetAllBoardPkTimes];
//            
//            [[SportForumAPI sharedInstance]userGetDailyLoginReward:^(int errorCode, int nLoginedDays, NSMutableArray* arrLoginReward){
//                if (errorCode == RSA_ERROR_NONE) {
//                    NSString *strReward = [NSString stringWithFormat:@"您已连续登录%d天，今日首次登录奖励%ld金币~", nLoginedDays, [arrLoginReward[(nLoginedDays - 1) % 7] unsignedLongValue] / 100000000];
//                    
//                    if (nLoginedDays == 1) {
//                        strReward = [NSString stringWithFormat:@"今日首次登录奖励%ld金币，连续登录会得到更多金币哦~", [arrLoginReward[(nLoginedDays - 1) % 7] unsignedLongValue] / 100000000];
//                    }
//                    
//                    [AlertManager showAlertText:strReward];
//                    
//                    ExpEffect *expEffect = [[ExpEffect alloc]init];
//                    expEffect.exp_coin = [arrLoginReward[(nLoginedDays - 1) % 7] unsignedLongValue];
//                    
//                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", nil]];
//                    
//                    /*m_timerReward = [NSTimer scheduledTimerWithTimeInterval: 2
//                                                     target: self
//                                                   selector: @selector(updateProfileInfo:)
//                                                   userInfo: [NSDictionary dictionaryWithObjectsAndKeys:@([arrLoginReward[nLoginedDays - 1] unsignedLongValue]), @"Exp_Coins", nil]
//                                                    repeats: NO];*/
//                 
//                    /*[AlertManager showConfirmAlertWithTitle:@"每日登录奖励" ContentView:[self generateViewByContinuesLoginDays:nLoginedDays LoginRewardList:arrLoginReward] ConfirmButtonTitle:@"领取每日奖励" ConfirmBlock:^BOOL(id window){
//                        
//                        UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
//                        [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
//                         {
//                             if (errorCode == 0)
//                             {
//                                 [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil];
//                             }
//                         }];
//                        
//                        return YES;
//                    } WithCancelButton:NO];*/
//                }
//            }];
//        }
//        
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginInfo"];
//    }
//    else
//    {
//        if (m_timeReward != nil) {
//            [m_timeReward invalidate];
//            m_timeReward = nil;
//        }
//        
//        m_timeReward = [NSTimer scheduledTimerWithTimeInterval: 2
//                                                        target: self
//                                                      selector: @selector(checkDailyFirstLogin)
//                                                      userInfo: nil
//                                                       repeats: NO];
//    }
//}
//
//-(void)reloadTasksData
//{
//    [[SportForumAPI sharedInstance]tasksGetList:^(int errorCode, TasksInfoList *tasksInfoList)
//    {
//        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView*)[m_viewWeekTasks viewWithTag:VIEW_TASKS_ACTIVITY_INDICATORVIEW];
//        [activityIndicator stopAnimating];
//        
//        if (errorCode == 0) {
//            if (m_tasksInfoList != nil && m_tasksInfoList.week_id == tasksInfoList.week_id) {
//                for (int i = 0; i < [tasksInfoList.task_list.data count]; i++) {
//                    TasksInfo *taskInfo1 = m_tasksInfoList.task_list.data[i];
//                    TasksInfo *taskInfo2 = tasksInfoList.task_list.data[i];
//                    
//                    e_task_type eTaskType1 = [CommonFunction ConvertStringToTaskType:taskInfo1.task_type];
//                    
//                    if (eTaskType1 == e_task_physique) {
//                        e_task_status eTaskStatus1 = [CommonFunction ConvertStringToTaskStatusType:taskInfo1.task_status];
//                        e_task_status eTaskStatus2 = [CommonFunction ConvertStringToTaskStatusType:taskInfo2.task_status];
//                        
//                        if (eTaskStatus1 != eTaskStatus2) {
//                            [NSTimer scheduledTimerWithTimeInterval: 2
//                                                             target: self
//                                                           selector: @selector(updateProfileInfo)
//                                                           userInfo: nil
//                                                            repeats: NO];
//                            break;
//                        }
//                    }
//                }
//            }
//            
//            m_tasksInfoList = tasksInfoList;
//            [self createTaskItems:tasksInfoList.task_list.data];
//        }
//    }];
//}
//
//-(void)generateAllBoardPkTimes
//{
//    NSMutableDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"BoardPkTimes"];
//    NSMutableDictionary * boardDict = [NSMutableDictionary dictionaryWithDictionary:dict];
//    
//    if (boardDict == nil) {
//        boardDict = [[NSMutableDictionary alloc]init];
//    }
//    
//    for (LeaderBoardItem *leadBoardItem in _boardArray) {
//        if ([boardDict objectForKey:leadBoardItem.userid] == nil) {
//            [boardDict setObject:@(4) forKey:leadBoardItem.userid];
//        }
//    }
//    
//    [[ApplicationContext sharedInstance] saveObject:boardDict byKey:@"BoardPkTimes"];
//}
//
///*-(void)updateBoardPkTimes:(NSString *)userid
//{
//    NSMutableDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"BoardPkTimes"];
//    NSMutableDictionary * boardDict = [NSMutableDictionary dictionaryWithDictionary:dict];
//    
//    if ([boardDict objectForKey:userid] != nil) {
//        NSUInteger nTimes = [[boardDict objectForKey:userid]unsignedIntegerValue];
//        
//        if (nTimes > 0) {
//            [boardDict setObject:@(nTimes - 1) forKey:userid];
//        }
//    }
//
//    [[ApplicationContext sharedInstance] saveObject:boardDict byKey:@"BoardPkTimes"];
//}*/
//
//-(void)resetAllBoardPkTimes
//{
//    NSMutableDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"BoardPkTimes"];
//    NSMutableDictionary * boardDict = [NSMutableDictionary dictionaryWithDictionary:dict];
//    
//    if (boardDict != nil) {
//        for (NSString *key in [boardDict allKeys]) {
//            [boardDict setObject:@(3) forKey:key];
//        }
//        
//        [[ApplicationContext sharedInstance] saveObject:boardDict byKey:@"BoardPkTimes"];
//    }
//}
//
//-(void)reloadLeadBoardData
//{
//    [self loadServerData:_strFirstPageId LastPageId:@""];
//}
//
//-(void)loadServerData:(NSString*)strFirstrPageId LastPageId:(NSString*)strLastPageId
//{
//    if (0) {
//        [self initBoardTestData];
//        [self stopRefresh];
//        [m_tableBoard reloadData];
//    }
//    else
//    {
//        [[SportForumAPI sharedInstance]leaderBoardListByQueryType:board_query_type_friend QueryInfo:@"" FirstPageId:strFirstrPageId LastPageId:strLastPageId PageItemNum:20 FinishedBlock:^void(int errorCode, LeaderBoardItemList *leaderBoardItemList){
//            [self stopRefresh];
//            
//            if (errorCode == 0) {
//                if ([leaderBoardItemList.members_list.data count] > 0) {
//                    if (strFirstrPageId.length == 0 && strLastPageId.length == 0) {
//                        [_boardArray removeAllObjects];
//                        
//                        _strFirstPageId = leaderBoardItemList.page_frist_id;
//                        _strLastPageId = leaderBoardItemList.page_last_id;
//                    }
//                    else if (strFirstrPageId.length == 0 && strLastPageId.length > 0)
//                    {
//                        _strLastPageId = leaderBoardItemList.page_last_id;
//                    }
//                    else if(strFirstrPageId.length > 0 && strLastPageId.length == 0)
//                    {
//                        _strFirstPageId = leaderBoardItemList.page_frist_id;
//                    }
//                    
//                    [_boardArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//                        LeaderBoardItem *leadBoardData1 = obj1;
//                        LeaderBoardItem *leadBoardData2 = obj2;
//                        return [[NSNumber numberWithUnsignedInteger:leadBoardData2.score] compare:[NSNumber numberWithUnsignedInteger:leadBoardData1.score]];
//                    }];
//                    
//                    m_viewFriendBoard.hidden = YES;
//                    m_tableBoard.hidden = NO;
//                    [_boardArray addObjectsFromArray:leaderBoardItemList.members_list.data];
//                    [self generateAllBoardPkTimes];
//                    [m_tableBoard reloadData];
//                }
//                else if(strFirstrPageId.length == 0 && strLastPageId.length == 0)
//                {
//                    [_boardArray removeAllObjects];
//                    [m_tableBoard reloadData];
//                    
//                    m_viewFriendBoard.hidden = NO;
//                    m_tableBoard.hidden = YES;
//                }
//            }
//        }];
//    }
//}
//
//-(void)stopRefresh {
//    if (_bUpHandleLoading) {
//        _bUpHandleLoading = NO;
//        [_egoRefreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:m_tableBoard];
//    }
//    
//    if (_blDownHandleLoading) {
//        _blDownHandleLoading = NO;
//        [self tableBootomShow:NO];
//    }
//}
//
//-(void)tableBootomShow:(BOOL)blShow {
//    if (blShow) {
//        [_tableFooterActivityIndicator startAnimating];
//    }
//    else {
//        [_tableFooterActivityIndicator stopAnimating];
//    }
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    CGPoint offset = m_tableBoard.contentOffset;
//    CGRect bounds = m_tableBoard.bounds;
//    CGSize size = m_tableBoard.contentSize;
//    UIEdgeInsets inset = m_tableBoard.contentInset;
//    CGFloat y = offset.y + bounds.size.height - inset.bottom;
//    CGFloat h = size.height;
//    
//    NSLog(@"%.2f %.2f %d", y, h, _blDownHandleLoading);
//    
//    if((y > (h + 30) && h > bounds.size.height) && _blDownHandleLoading == NO) {
//        [self tableBootomShow:YES];
//        _blDownHandleLoading = YES;
//        [self loadServerData:@"" LastPageId:_strLastPageId];
//    }
//    
//    if (_bUpHandleLoading == NO) {
//        [_egoRefreshTableHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
//    }
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//	[_egoRefreshTableHeaderView egoRefreshScrollViewDidScroll:scrollView];
//}
//
//#pragma mark -
//#pragma mark EGORefreshTableHeaderDelegate Methods
//- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
//	_bUpHandleLoading = YES;
//    [self performSelector:@selector(handleUpdateLeadBoard) withObject:nil afterDelay:1];
//}
//
//- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
//	
//	return _bUpHandleLoading; // should return if data source model is reloading
//}
//
//- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
//	
//	return [NSDate date]; // should return date data source was last changed
//}
//
//@end
