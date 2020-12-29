//
//  AccountStatisticsViewController.m
//  SportForum
//
//  Created by liyuan on 4/20/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "AccountStatisticsViewController.h"
#import "UIViewController+SportFormu.h"
#import "GraphView.h"
#import "AccountBoardViewController.h"

@interface AccountStatisticsViewController ()<GraphViewDelegate>

@end

@implementation AccountStatisticsViewController
{
    UIScrollView *_scrollView;
    
    UIView *_viewSport;
    UIView *_viewWeidget;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self generateCommonViewInParent:self.view Title:@"统计" IsNeedBackBtn:YES];
    
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
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(viewBody.frame), CGRectGetHeight(viewBody.frame))];
    _scrollView.scrollEnabled = YES;
    [viewBody addSubview:_scrollView];
    
    [self generateSportView];
    [self generateWeidgetView];
    [self generateSportBoard];
    
    NSMutableArray *arraySport = [NSMutableArray array];
    NSMutableArray *arrayWeidget = [NSMutableArray array];
    
    GraphDataObject *object = [[GraphDataObject alloc] init];
    object.time = [NSDate date];
    object.value = [NSNumber numberWithFloat:0.0];
    [arraySport insertObject:object atIndex:0];
    
    object = [[GraphDataObject alloc] init];
    object.time = [NSDate date];
    object.value = [NSNumber numberWithInteger:0];
    [arrayWeidget insertObject:object atIndex:0];
    
    GraphView *graphViewWeidget = (GraphView*)[_viewWeidget viewWithTag:30010];
    [self updateStatisticsView:arrayWeidget Graphiew:graphViewWeidget];
    
    GraphView *graphViewSport = (GraphView*)[_viewSport viewWithTag:30000];
    [self updateStatisticsView:arraySport Graphiew:graphViewSport];
    
    [self loadStatisticsData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"统计 - AccountStatisticsViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"统计 - AccountStatisticsViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"统计 - AccountStatisticsViewController"];
}

- (void)updateStatisticsView:(NSArray*) dataArray Graphiew:(GraphView*)graphView{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if([dataArray count] > 0){
                graphView.graphViewData = dataArray;
                [graphView reloadData];
            }
        });
    });
}

-(void)setAttributedTextValue:(UILabel*)lbText FirstAtt:(NSString*)strFirAtt SecAtt:(NSString*)strSecAtt ThirdAtt:(NSString*)strThirdAtt
{
    NSDictionary *attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:strFirAtt attributes:attribs];
    
    attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName:[UIColor blackColor]};
    NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:strSecAtt attributes:attribs];
    
    attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    NSAttributedString * strPart3Value = [[NSAttributedString alloc] initWithString:strThirdAtt attributes:attribs];
    
    NSMutableAttributedString * strValue = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
    [strValue appendAttributedString:strPart2Value];
    [strValue appendAttributedString:strPart3Value];
    
    lbText.attributedText = strValue;
}

-(void)generateSportView
{
    _viewSport = [[UIView alloc] initWithFrame:CGRectMake(5, 10, CGRectGetWidth(_scrollView.frame) - 10, 400)];
    _viewSport.backgroundColor = [UIColor whiteColor];
    _viewSport.layer.borderColor = [UIColor colorWithRed:237.0 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1.0].CGColor;
    _viewSport.layer.borderWidth = 1.0;
    _viewSport.layer.cornerRadius = 5.0;
    [_scrollView addSubview:_viewSport];
    
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 20)];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = [UIColor darkGrayColor];
    labelTitle.text = @"运动曲线";
    labelTitle.textAlignment = NSTextAlignmentLeft;
    labelTitle.font = [UIFont boldSystemFontOfSize:15];
    [_viewSport addSubview:labelTitle];

    GraphView *graphViewSport = [[GraphView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(labelTitle.frame), 300, 160) delegate:self];
    graphViewSport.backgroundColor = [UIColor clearColor];
    [graphViewSport.layer setCornerRadius:8.0f];
    [graphViewSport.layer setMasksToBounds:YES];
    graphViewSport.bShowLineUp = YES;
    graphViewSport.bToRecent = YES;
    graphViewSport.xUnit = @"km";
    graphViewSport.tag = 30000;
    [_viewSport addSubview:graphViewSport];
    
    UILabel *lbTotalDis = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(graphViewSport.frame) + 5, 145, 20)];
    lbTotalDis.backgroundColor = [UIColor clearColor];
    lbTotalDis.tag = 30001;
    [_viewSport addSubview:lbTotalDis];
    
    [self setAttributedTextValue:lbTotalDis FirstAtt:@"总里程 " SecAtt:@"0.0" ThirdAtt:@" km"];
    
    UILabel *lbFastSpeed = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbTotalDis.frame), CGRectGetMinY(lbTotalDis.frame), 145, 20)];
    lbFastSpeed.backgroundColor = [UIColor clearColor];
    lbFastSpeed.textAlignment = NSTextAlignmentRight;
    lbFastSpeed.tag = 30002;
    [_viewSport addSubview:lbFastSpeed];
    
    [self setAttributedTextValue:lbTotalDis FirstAtt:@"最快速度 " SecAtt:@"0.0" ThirdAtt:@" km/h"];
    
    UILabel *lbLongDisPerDay = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(lbTotalDis.frame) + 5, 250, 20)];
    lbLongDisPerDay.backgroundColor = [UIColor clearColor];
    lbLongDisPerDay.tag = 30003;
    [_viewSport addSubview:lbLongDisPerDay];
    
    [self setAttributedTextValue:lbLongDisPerDay FirstAtt:@"单日运动最长距离 " SecAtt:@"0.0" ThirdAtt:@" km"];
    
    _viewSport.frame = CGRectMake(5, 10, CGRectGetWidth(_scrollView.frame) - 10, CGRectGetMaxY(lbLongDisPerDay.frame) + 5);
}

-(void)generateWeidgetView
{
    _viewWeidget = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_viewSport.frame) + 5, CGRectGetWidth(_scrollView.frame) - 10, 400)];
    _viewWeidget.backgroundColor = [UIColor whiteColor];
    _viewWeidget.layer.borderColor = [UIColor colorWithRed:237.0 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1.0].CGColor;
    _viewWeidget.layer.borderWidth = 1.0;
    _viewWeidget.layer.cornerRadius = 5.0;
    [_scrollView addSubview:_viewWeidget];
    
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 20)];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = [UIColor darkGrayColor];
    labelTitle.text = @"体重曲线";
    labelTitle.textAlignment = NSTextAlignmentLeft;
    labelTitle.font = [UIFont boldSystemFontOfSize:15];
    [_viewWeidget addSubview:labelTitle];
    
    GraphView *graphViewWeidget = [[GraphView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(labelTitle.frame), 300, 160) delegate:self];
    graphViewWeidget.backgroundColor = [UIColor clearColor];
    [graphViewWeidget.layer setCornerRadius:8.0f];
    [graphViewWeidget.layer setMasksToBounds:YES];
    graphViewWeidget.bShowLineUp = YES;
    graphViewWeidget.bToRecent = YES;
    graphViewWeidget.xUnit = @"kg";
    graphViewWeidget.tag = 30010;
    [_viewWeidget addSubview:graphViewWeidget];
    
    UILabel *lbBMI = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(graphViewWeidget.frame) + 5, 60, 20)];
    lbBMI.backgroundColor = [UIColor clearColor];
    lbBMI.tag = 30011;
    [_viewWeidget addSubview:lbBMI];
    
    UILabel *lbBMIDesc = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbBMI.frame), CGRectGetMinY(lbBMI.frame), CGRectGetWidth(_viewWeidget.frame) - CGRectGetMaxX(lbBMI.frame) - 5, 20)];
    lbBMIDesc.backgroundColor = [UIColor clearColor];
    lbBMIDesc.tag = 30012;
    lbBMIDesc.textAlignment = NSTextAlignmentRight;
    lbBMIDesc.textColor = [UIColor darkGrayColor];
    lbBMIDesc.font = [UIFont boldSystemFontOfSize:13];
    [_viewWeidget addSubview:lbBMIDesc];

    _viewWeidget.frame = CGRectMake(5, CGRectGetMaxY(_viewSport.frame) + 5, CGRectGetWidth(_scrollView.frame) - 10, CGRectGetMaxY(lbBMI.frame) + 5);
}

-(void)generateBoardItem:(CGFloat)fStartY ImgItem:(NSString*)strItem TextItem:(NSString*)strText
{
    UIImage *imgBk = [UIImage imageNamed:@"transaction-block-bg"];
    imgBk = [imgBk resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(imgBk.size.height / 2) - 2, floorf(imgBk.size.width / 2) - 2, floorf(imgBk.size.height / 2) + 2, floorf(imgBk.size.width / 2) + 2)];
    
    UIImageView *imgBkViewd = [[UIImageView alloc]initWithFrame:CGRectMake(5, fStartY, 300, 52)];
    [imgBkViewd setImage:imgBk];
    [_scrollView addSubview:imgBkViewd];
    
    UIImageView *imgViewItem = [[UIImageView alloc]initWithFrame:CGRectMake(5, CGRectGetMinY(imgBkViewd.frame) + 26 - 40 / 2, 40, 40)];
    [imgViewItem setImage:[UIImage imageNamed:strItem]];
    [_scrollView addSubview:imgViewItem];
    
    UILabel * lbItem = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgViewItem.frame) + 10, CGRectGetMinY(imgBkViewd.frame) + 26 - 15, imgBkViewd.frame.size.width - 30 - (CGRectGetMaxX(imgViewItem.frame) + 10), 30)];
    lbItem.backgroundColor = [UIColor clearColor];
    lbItem.textColor = [UIColor blackColor];
    lbItem.text = strText;
    lbItem.font = [UIFont boldSystemFontOfSize:14];
    lbItem.textAlignment = NSTextAlignmentLeft;
    [_scrollView addSubview:lbItem];
    
    UIImageView *imgArrowCoin = [[UIImageView alloc] initWithFrame:CGRectMake(310 - 18, CGRectGetMinY(imgBkViewd.frame) + 26 - 8, 8, 16)];
    imgArrowCoin.image = [UIImage imageNamed:@"arrow-1"];
    [_scrollView addSubview:imgArrowCoin];
    
    CSButton * btnItem = [CSButton buttonWithType:UIButtonTypeCustom];
    btnItem.frame = CGRectMake(5, fStartY, 300, 50);
    [_scrollView addSubview:btnItem];
    
    __weak __typeof(self) weakSelf = self;
    
    btnItem.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        AccountBoardViewController *accountBoardViewController = [[AccountBoardViewController alloc]init];
        
        if ([strText isEqualToString:@"体魄排行榜"]) {
            accountBoardViewController.strBoardType = @"physique";
        }
        else if([strText isEqualToString:@"文学排行榜"]) {
            accountBoardViewController.strBoardType = @"literature";
        }
        else if([strText isEqualToString:@"魔法排行榜"])
        {
            accountBoardViewController.strBoardType = @"magic";
        }
        
        [strongSelf.navigationController pushViewController:accountBoardViewController animated:YES];
    };
}

-(void)generateSportBoard
{
    CGFloat fStartY = CGRectGetMaxY(_viewWeidget.frame) + 5;
    
    [self generateBoardItem:fStartY ImgItem:@"me-level-runner" TextItem:@"体魄排行榜"];
    [self generateBoardItem:fStartY + 52 + 5 ImgItem:@"me-level-pen" TextItem:@"文学排行榜"];
    [self generateBoardItem:fStartY + (52 + 5) * 2 ImgItem:@"me-level-magic" TextItem:@"魔法排行榜"];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, fStartY + (52 + 5) * 2 + 52 + 20);
}

-(void)loadStatisticsData
{
    __weak __typeof(self) weakSelf = self;
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    CGFloat fBMI = 0.0;
    NSInteger nHeight = [[CommonUtility sharedInstance]generateHeightBySex:userInfo.sex_type Height:userInfo.height];
    NSInteger nWeight = [[CommonUtility sharedInstance]generateWeightBySex:userInfo.sex_type Weight:userInfo.weight];
    fBMI = nWeight / (nHeight * nHeight / 10000.0);

    UILabel *lbBMI = (UILabel*)[_viewWeidget viewWithTag:30011];
    [self setAttributedTextValue:lbBMI FirstAtt:@"BMI " SecAtt:[NSString stringWithFormat:@"%.1f", fBMI] ThirdAtt:@""];
    
    UILabel *lbBMIDesc = (UILabel*)[_viewWeidget viewWithTag:30012];
    lbBMIDesc.textColor = [UIColor darkGrayColor];
    
    if (fBMI == 0.0) {
        lbBMIDesc.text = @"体重和身高尚未记录";
    }
    else if (fBMI < 18.5 && fBMI > 0.0) {
        lbBMIDesc.text = @"体重过轻，请加强营养";
        lbBMIDesc.textColor = [UIColor redColor];
    }
    else if(fBMI >= 18.5 && fBMI < 24.99)
    {
        lbBMIDesc.text = @"体重正常，请保持";
    }
    else if(fBMI >= 25 && fBMI < 28)
    {
        lbBMIDesc.text = @"体重过重，请加强锻炼";
        lbBMIDesc.textColor = [UIColor orangeColor];
    }
    else if(fBMI >= 28 && fBMI < 32)
    {
        lbBMIDesc.text = @"体重肥胖，请加强锻炼和注意饮食";
        lbBMIDesc.textColor = [UIColor redColor];
    }
    else if(fBMI >= 32)
    {
        lbBMIDesc.text = @"体重非常肥胖";
        lbBMIDesc.textColor = [UIColor redColor];
    }
    
    [[SportForumAPI sharedInstance] recordTimeLineByUserId:userInfo.userid
                                               FirstPageId:nil
                                                LastPageId:nil
                                               PageItemNum:50
                                                RecordType:@"run"
                                             FinishedBlock:^void(int errorCode, SportRecordInfoList *sportRecordInfoList)
     {
         __typeof(self) strongSelf = weakSelf;
         
         if (strongSelf == nil) {
             return;
         }

         if (errorCode == 0 && sportRecordInfoList.record_list.data.count > 0)
         {
             NSMutableArray *arraySport = [NSMutableArray array];
             NSMutableArray *arrayWeidget = [NSMutableArray array];

             for (SportRecordInfo *sportRecordInfo in sportRecordInfoList.record_list.data) {
                 GraphDataObject *object = [[GraphDataObject alloc] init];
                 object.time = [NSDate dateWithTimeIntervalSince1970:sportRecordInfo.begin_time];
                 object.value = [NSNumber numberWithFloat:sportRecordInfo.distance / 1000.0];
                 [arraySport insertObject:object atIndex:0];
                 
                 object = [[GraphDataObject alloc] init];
                 object.time = [NSDate dateWithTimeIntervalSince1970:sportRecordInfo.begin_time];
                 object.value = [NSNumber numberWithInteger:sportRecordInfo.weight];
                 [arrayWeidget insertObject:object atIndex:0];
             }
             
             GraphView *graphViewWeidget = (GraphView*)[_viewWeidget viewWithTag:30010];
             [self updateStatisticsView:arrayWeidget Graphiew:graphViewWeidget];
             
             GraphView *graphViewSport = (GraphView*)[_viewSport viewWithTag:30000];
             [self updateStatisticsView:arraySport Graphiew:graphViewSport];
         }
     }];
    
    [[SportForumAPI sharedInstance] recordStatisticsByUserId:userInfo.userid
                                               FinishedBlock:^void(int errorCode, RecordStatisticsInfo *recordStatisticsInfo)
     {
         __typeof(self) strongSelf = weakSelf;
         
         if (strongSelf == nil) {
             return;
         }
         
         UILabel *lbTotalDis = (UILabel*)[_viewSport viewWithTag:30001];
         [self setAttributedTextValue:lbTotalDis FirstAtt:@"总里程 " SecAtt:[NSString stringWithFormat:@"%.2f", recordStatisticsInfo.total_distance / 1000.00] ThirdAtt:@" km"];
         
         UILabel *lbFastSpeed = (UILabel*)[_viewSport viewWithTag:30002];
         
         CGFloat nMaxSpeed = 0.0;
         if(recordStatisticsInfo.max_speed_record.duration != 0)
         {
             nMaxSpeed = (recordStatisticsInfo.max_speed_record.distance * 3600) / (recordStatisticsInfo.max_speed_record.duration * 1000.0);
             [self setAttributedTextValue:lbFastSpeed FirstAtt:@"最快速度 " SecAtt:[NSString stringWithFormat:@"%0.2f", nMaxSpeed] ThirdAtt:@" km/h"];
         }
         else
         {
             [self setAttributedTextValue:lbFastSpeed FirstAtt:@"最快速度 " SecAtt:@"0.00" ThirdAtt:@" km/h"];
         }
         
         UILabel *lbLongDisPerDay = (UILabel*)[_viewSport viewWithTag:30003];
         [self setAttributedTextValue:lbLongDisPerDay FirstAtt:@"单日运动最长距离 " SecAtt:[NSString stringWithFormat:@"%.2f", recordStatisticsInfo.max_distance_record.distance / 1000.00] ThirdAtt:@" km"];
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"AccountStatisticsViewController dealloc called!");
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
