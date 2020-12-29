//
//  CircleDetailViewController.m
//  SportForum
//
//  Created by liyuan on 14-9-12.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "CircleDetailViewController.h"
#import "SFGridView.h"
#import "WallCell.h"
#import "ArticlePagesViewController.h"
#import "ArticlePublicViewController.h"
#import "UIViewController+SportFormu.h"
#import "AlertManager.h"

@interface CircleDetailViewController ()<SFGridViewDelegate>

@end

@implementation CircleDetailViewController
{
    NSMutableArray *_arrayForumDatas; //Articleobject
    SFGridView* _gridView;
    
    NSString *_pageLastID;
    NSString *_pageFristID;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoadGui
{
    [self generateCommonViewInParent:self.view Title:_strCircleType IsNeedBackBtn:YES];
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    CGRect rect = viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
    viewBody.frame = rect;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    viewBody.layer.mask = maskLayer;
    
    _gridView = [[SFGridView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(viewBody.frame), CGRectGetHeight(viewBody.frame))];
    _gridView.gridViewDelegate = self;
    _gridView.backgroundColor = [UIColor clearColor];
    [_gridView enablePullRefreshHeaderViewTarget:self DidTriggerRefreshAction:@selector(actionPullHeaderRefresh)];
    [_gridView enablePullRefreshFooterViewTarget:self DidTriggerRefreshAction:@selector(actionPullFooterRefresh)];
    [_gridView.tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [viewBody addSubview: _gridView];
    
    CSButton* button = [[CSButton alloc]initWithImage:[UIImage imageNamed:@"circles-write-blog-btn"]];
    button.frame = CGRectOffset(button.frame,
                                CGRectGetWidth(viewBody.frame)/2 - CGRectGetWidth(button.frame)/2,
                                CGRectGetHeight(viewBody.frame) - CGRectGetHeight(button.frame) - 10);
    
    [viewBody addSubview:button];
    [viewBody bringSubviewToFront:button];
    
    __weak __typeof(self) weakSelf = self;
    
    button.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
        
        if (userInfo != nil) {
            if (userInfo.ban_time > 0) {
                [JDStatusBarNotification showWithStatus:@"用户已被禁言，无法完成本次操作。" dismissAfter:3.0 styleName:JDStatusBarStyleWarning];
                return;
            }
            else if(userInfo.ban_time < 0)
            {
                [JDStatusBarNotification showWithStatus:@"用户已进入黑名单，无法完成本次操作。" dismissAfter:3.0 styleName:JDStatusBarStyleWarning];
                return;
            }
        }
        
        ArticlePublicViewController* articlePublicViewController = [[ArticlePublicViewController alloc]init];
        [strongSelf.navigationController pushViewController:articlePublicViewController animated:YES];
    };
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateProfileInfo:) name:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil];
    
    [self viewDidLoadGui];
    [self actionPullHeaderRefresh];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[ApplicationContext sharedInstance]cancelCurrentRequests:[NSArray arrayWithObjects:urlArticleTimeLines, nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"CircleDetailViewController dealloc called!");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)handleUpdateProfileInfo:(NSNotification*) notification
{
    BOOL bUpdateArticle = NO;
    bUpdateArticle = [[notification.userInfo objectForKey:@"UpdateArticle"]boolValue];
    
    if (bUpdateArticle) {
        [self actionPullHeaderRefresh];
    }
}

-(void)testForumDatas {
    
    _arrayForumDatas = [[NSMutableArray alloc]init];
    
    ArticlesObject * articleObj = [[ArticlesObject alloc]init];
    
    articleObj.parent_article_id = nil;
    articleObj.article_id = @"000001";
    articleObj.author = @"00001";
    articleObj.cover_image = @"http://106.187.48.51:8081/4/ed922a484492/640X424.jpg";
    articleObj.cover_text = @"测试一下,看看";
    
    articleObj.article_segments = [[BaseArray alloc]init];
    articleObj.article_segments.data = [[NSMutableArray alloc]init];
    
    
    ArticleSegmentObject* segobj = [[ArticleSegmentObject alloc]init];
    segobj.seg_type = @"IMAGE";
    segobj.seg_content = @"http://106.187.48.51:8081/4/ed922a484492/640X424.jpg";
    [articleObj.article_segments.data addObject:segobj];
    
    segobj = [[ArticleSegmentObject alloc]init];
    segobj.seg_type = @"TEXT";
    segobj.seg_content = @"测试一下,看看";
    [articleObj.article_segments.data addObject:segobj];
    
    segobj = [[ArticleSegmentObject alloc]init];
    segobj.seg_type = @"IMAGE";
    segobj.seg_content = @"http://106.187.48.51:8081/4/ed922a484492/640X424.jpg";
    [articleObj.article_segments.data addObject:segobj];
    
    segobj = [[ArticleSegmentObject alloc]init];
    segobj.seg_type = @"TEXT";
    segobj.seg_content = @"长一点,看看，长一点,看看，长一点,看看,非常长，非常长，非常长，非常长，非常长，非常长，非常长，非常长";
    [articleObj.article_segments.data addObject:segobj];
    
    [_arrayForumDatas addObject:articleObj];
    
    
    articleObj = [[ArticlesObject alloc]init];
    
    articleObj.parent_article_id = nil;
    articleObj.article_id = @"000002";
    articleObj.author = @"00001";
    articleObj.cover_image = @"";
    articleObj.cover_text = @"哈哈";
    
    articleObj.article_segments = [[BaseArray alloc]init];
    articleObj.article_segments.data = [[NSMutableArray alloc]init];
    
    
    segobj = [[ArticleSegmentObject alloc]init];
    segobj.seg_type = @"IMAGE";
    segobj.seg_content = @"";
    [articleObj.article_segments.data addObject:segobj];
    
    segobj = [[ArticleSegmentObject alloc]init];
    segobj.seg_type = @"TEXT";
    segobj.seg_content = @"测试一下,看看";
    [articleObj.article_segments.data addObject:segobj];
    
    segobj = [[ArticleSegmentObject alloc]init];
    segobj.seg_type = @"IMAGE";
    segobj.seg_content = @"";
    [articleObj.article_segments.data addObject:segobj];
    
    segobj = [[ArticleSegmentObject alloc]init];
    segobj.seg_type = @"TEXT";
    segobj.seg_content = @"长一点,看看，长一点,看看，长一点,看看,非常长，非常长，非常长，非常长，非常长，非常长，非常长，非常长";
    [articleObj.article_segments.data addObject:segobj];
    
    [_arrayForumDatas addObject:articleObj];
    
    articleObj = [[ArticlesObject alloc]init];
    
    articleObj.parent_article_id = nil;
    articleObj.article_id = @"000001";
    articleObj.author = @"00001";
    articleObj.cover_image = @"";
    articleObj.cover_text = @"测试一下,看看";
    
    articleObj.article_segments = [[BaseArray alloc]init];
    articleObj.article_segments.data = [[NSMutableArray alloc]init];
    
    
    segobj = [[ArticleSegmentObject alloc]init];
    segobj.seg_type = @"IMAGE";
    segobj.seg_content = @"";
    [articleObj.article_segments.data addObject:segobj];
    
    segobj = [[ArticleSegmentObject alloc]init];
    segobj.seg_type = @"TEXT";
    segobj.seg_content = @"测试一下,看看";
    [articleObj.article_segments.data addObject:segobj];
    
    segobj = [[ArticleSegmentObject alloc]init];
    segobj.seg_type = @"IMAGE";
    segobj.seg_content = @"http://106.187.48.51:8081/4/ed922a484492/640X424.jpg";
    [articleObj.article_segments.data addObject:segobj];
    
    segobj = [[ArticleSegmentObject alloc]init];
    segobj.seg_type = @"TEXT";
    segobj.seg_content = @"长一点,看看，长一点,看看，长一点,看看,非常长，非常长，非常长，非常长，非常长，非常长，非常长，非常长";
    [articleObj.article_segments.data addObject:segobj];
    
    [_arrayForumDatas addObject:articleObj];
}

-(void)actionPullHeaderRefresh {
    NSLog(@"loading header.....");
    
    __weak __typeof(self) weakself = self;
    [[SportForumAPI sharedInstance]articleTimeLinesByFirPagId:nil
                                                   LastPageId:nil
                                                PageItemCount:30
                                                   ArticleTag:_eArticleTagType
                                                  IsCircle:NO
                                                FinishedBlock:^(int errorCode, ArticlesInfo *articlesInfo) {
                                                    __typeof(self) strongself = weakself;
                                                    
                                                    if(strongself != nil)
                                                    {
                                                        [strongself->_gridView completePullHeaderRefresh];
                                                        strongself->_arrayForumDatas = [NSMutableArray arrayWithArray:articlesInfo.articles_without_content.data];
                                                        [strongself->_gridView reloadData];
                                                        strongself->_pageFristID = articlesInfo.page_frist_id;
                                                        strongself->_pageLastID = articlesInfo.page_last_id;
                                                    }
                                                }];
    
    
}

-(void)actionPullFooterRefresh {
    NSLog(@"loading footer.....");
    
    __weak __typeof(self) weakself = self;
    
    if ([_pageLastID isEqualToString:@""]) {
        [_gridView completePullFooterRefresh];
        return;
    }
    
    [[SportForumAPI sharedInstance]articleTimeLinesByFirPagId:@""
                                                   LastPageId:_pageLastID
                                                PageItemCount:30
                                                   ArticleTag:_eArticleTagType
                                                  IsCircle:NO
                                                FinishedBlock:^(int errorCode, ArticlesInfo *articlesInfo) {
                                                    __typeof(self) strongself = weakself;
                                                    
                                                    if (strongself != nil) {
                                                        [strongself->_gridView completePullFooterRefresh];
                                                        //strongself->_arrayForumDatas = articlesInfo.articles_without_content.data;
                                                        [strongself->_arrayForumDatas addObjectsFromArray:articlesInfo.articles_without_content.data];
                                                        [strongself->_gridView reloadData];
                                                        //strongself->_pageFristID = articlesInfo.page_frist_id;
                                                        strongself->_pageLastID = articlesInfo.page_last_id;
                                                    }
                                                }];
}

- (NSInteger) numberOfCells:(SFGridView *)gridView {
    return _arrayForumDatas.count;
}

- (SFGridViewCell *) gridView:(SFGridView *)gridView Row:(NSInteger)rowIndex Column:(NSInteger)columnIndex {
    WallCell *cell = (WallCell *)[gridView dequeueReusableCell];
    
    if (cell == nil) {
        cell = [[WallCell alloc]initWithFrame:CGRectMake(0, 0, gridView.cellWidth, gridView.cellHeight)];
    }
    
    ArticlesObject* articleObj = _arrayForumDatas[rowIndex * gridView.colCount + columnIndex];
    WallCellInfo *cellInfo = [[WallCellInfo alloc]init];
    cellInfo.imageURL = articleObj.cover_image;
    cellInfo.title = articleObj.cover_text;
    cellInfo.thumbCount = articleObj.thumb_count;
    cellInfo.commentCount = articleObj.sub_article_count;
    
    cell.cellInfo = cellInfo;
    
    return cell;
}

- (void) gridView:(SFGridView *)grid didSelectRow:(NSInteger)rowIndex Column:(NSInteger)columnIndex {
    NSLog(@"clicked %ld %ld", rowIndex, columnIndex);
    
    if ([_arrayForumDatas count] > 0) {
        ArticlePagesViewController* articlePagesViewController = [[ArticlePagesViewController alloc] init];
        articlePagesViewController.currentIndex = rowIndex * grid.colCount + columnIndex;
        articlePagesViewController.arrayArticleInfos = [NSMutableArray arrayWithArray:_arrayForumDatas];
        [self.navigationController pushViewController:articlePagesViewController animated:YES];
    }
}

@end
