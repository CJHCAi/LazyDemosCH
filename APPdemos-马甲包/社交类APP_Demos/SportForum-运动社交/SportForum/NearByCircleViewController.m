//
//  NearByCircleViewController.m
//  SportForum
//
//  Created by liyuan on 14-9-2.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "NearByCircleViewController.h"
#import "NearByViewController.h"
#import "UIViewController+SportFormu.h"
#import "CircleDetailViewController.h"

#define NEARBY_CONTENT_VIEW 9
#define NEARBY_TITLE_LABEL_TAG 10
#define NEARBY_DESC_LABEL_TAG 11
#define NEARBY_DESC_IMAGE_TAG 12
#define NEARBY_ARROW_IMAGE_TAG 13

@interface NearByCircleViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@end

@implementation NearByCircleViewController
{
    NSMutableArray* m_nearByCircleItems;
    UITableView *m_tableNearCircleBy;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadTestData
{
    m_nearByCircleItems = [[NSMutableArray alloc]init];
    
    NearByItem *nearByItem = [[NearByItem alloc]init];
    nearByItem.nearByTitle = @"运动日志";
    nearByItem.nearByImg = @"circle-blog";
    nearByItem.eArticleTagType = e_article_log;
    [m_nearByCircleItems addObject:nearByItem];
    
    nearByItem = [[NearByItem alloc]init];
    nearByItem.nearByTitle = @"跑步圣经";
    nearByItem.nearByImg = @"circle-bible";
    nearByItem.eArticleTagType = e_article_theory;
    [m_nearByCircleItems addObject:nearByItem];
    
    nearByItem = [[NearByItem alloc]init];
    nearByItem.nearByTitle = @"我爱装备";
    nearByItem.nearByImg = @"circle-equipment";
    nearByItem.eArticleTagType = e_article_equip;
    [m_nearByCircleItems addObject:nearByItem];
    
    nearByItem = [[NearByItem alloc]init];
    nearByItem.nearByTitle = @"跑步人生";
    nearByItem.nearByImg = @"circle-life";
    nearByItem.eArticleTagType = e_article_life;
    [m_nearByCircleItems addObject:nearByItem];
    
    nearByItem = [[NearByItem alloc]init];
    nearByItem.nearByTitle = @"产品建议";
    nearByItem.nearByImg = @"circle-suggestion";
    nearByItem.eArticleTagType = e_article_proposal;
    [m_nearByCircleItems addObject:nearByItem];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self generateCommonViewInParent:self.view Title:@"圈子" IsNeedBackBtn:YES];
    [self loadTestData];
    
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
    
    rect = CGRectMake(0, 0, viewBody.frame.size.width, viewBody.frame.size.height);
    m_tableNearCircleBy = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    m_tableNearCircleBy.delegate = self;
    m_tableNearCircleBy.dataSource = self;
    [viewBody addSubview:m_tableNearCircleBy];
    
    [m_tableNearCircleBy reloadData];
    m_tableNearCircleBy.backgroundColor = [UIColor clearColor];
    m_tableNearCircleBy.separatorColor = [UIColor clearColor];
    
    if ([m_tableNearCircleBy respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [m_tableNearCircleBy setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_nearByCircleItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellTableIdentifier = @"NearByIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: CellTableIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView* viewContent = [[UIImageView alloc]init];
        viewContent.tag = NEARBY_CONTENT_VIEW;
        [cell.contentView addSubview:viewContent];
        
        UIImageView * imgDescImage = [[UIImageView alloc] init];
        imgDescImage.tag = NEARBY_DESC_IMAGE_TAG;
        [viewContent addSubview:imgDescImage];
        
        UILabel * lbNearByTitle = [[UILabel alloc]init];
        lbNearByTitle.font = [UIFont boldSystemFontOfSize:14.0];
        lbNearByTitle.textAlignment = NSTextAlignmentLeft;
        lbNearByTitle.backgroundColor = [UIColor clearColor];
        lbNearByTitle.textColor = [UIColor blackColor];
        lbNearByTitle.tag = NEARBY_TITLE_LABEL_TAG;
        [viewContent addSubview:lbNearByTitle];
        
        UIImageView * imgArrow = [[UIImageView alloc] init];
        imgArrow.tag = NEARBY_ARROW_IMAGE_TAG;
        [viewContent addSubview:imgArrow];
    }
    
    NearByItem *nearByItem = m_nearByCircleItems[[indexPath row]];
    
    UIImage *imgBk = [UIImage imageNamed:@"transaction-block-bg"];
    imgBk = [imgBk resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(imgBk.size.height / 2) - 2, floorf(imgBk.size.width / 2) - 2, floorf(imgBk.size.height / 2) + 2, floorf(imgBk.size.width / 2) + 2)];
    
    UIImageView *viewContent = (UIImageView*)[cell.contentView viewWithTag:NEARBY_CONTENT_VIEW];
    viewContent.frame = CGRectMake(5, 1, 300, 50);
    [viewContent setImage:imgBk];

    UIImageView *imgDescImage = (UIImageView*)[viewContent viewWithTag:NEARBY_DESC_IMAGE_TAG];
    UIImage *image = [UIImage imageNamed:nearByItem.nearByImg];
    [imgDescImage setImage:image];
    imgDescImage.frame = CGRectMake(8, 3, 40, 40);
    
    UILabel * lbNearByTitle = (UILabel*)[viewContent viewWithTag:NEARBY_TITLE_LABEL_TAG];
    lbNearByTitle.text = nearByItem.nearByTitle;
    //CGSize lbLeftSize = [lbNearByTitle.text sizeWithFont:lbNearByTitle.font
    //                                   constrainedToSize:CGSizeMake(150, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize lbLeftSize = [lbNearByTitle.text boundingRectWithSize:CGSizeMake(150, FLT_MAX)
                                                       options:options
                                                    attributes:@{NSFontAttributeName:lbNearByTitle.font} context:nil].size;
    
    lbNearByTitle.frame = CGRectMake(15 + image.size.width, 15, lbLeftSize.width, 20);
    
    UIImageView * imgArrow = (UIImageView*)[cell.contentView viewWithTag:NEARBY_ARROW_IMAGE_TAG];
    image = [UIImage imageNamed:@"arrow-1"];
    [imgArrow setImage:image];
    imgArrow.frame = CGRectMake(viewContent.frame.size.width - 15 - image.size.width, 15, image.size.width, image.size.height);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NearByItem *nearByItem = m_nearByCircleItems[[indexPath row]];
    
    CircleDetailViewController *circleDetailViewController = [[CircleDetailViewController alloc]init];
    circleDetailViewController.strCircleType = nearByItem.nearByTitle;
    circleDetailViewController.eArticleTagType = nearByItem.eArticleTagType;
    [self.navigationController pushViewController:circleDetailViewController animated:YES];
}

@end
