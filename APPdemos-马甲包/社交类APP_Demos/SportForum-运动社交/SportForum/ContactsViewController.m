//
//  ContactsViewController.m
//  SportForum
//
//  Created by liyuan on 14-8-15.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "ContactsViewController.h"
#import "ChatDetailViewController.h"
#import "UIViewController+SportFormu.h"
#import "RelatedPeoplesViewController.h"
#import "CSButton.h"
#import "EGORefreshTableHeaderView.h"
#import "SystemNotifyViewController.h"
#import "SearchViewController.h"

#define CONTACT_DESC_LABEL_TAG 1000
#define CONTACT_ARRAY_IMAGE_TAG 1001
#define CONTACT_DESC_IMAGE_TAG 1002
#define CONTACT_CONTENT_VIEW_TAG 1003
#define CONTACT_CONTENT_LABEL_TAG 1004
#define CONTACT_NUM_IMAGE_TAG 1005
#define CONTACT_NUM_LABEL_TAG 1006

@interface ContactItem : NSObject

@property(nonatomic, copy) NSString* contactTitle;
@property(nonatomic, copy) NSString* contactContent;
@property(nonatomic, copy) NSString* contactImg;

@property(nonatomic, assign) NSInteger unReadCount;
@property(nonatomic, assign) e_related_type eRelatedType;

@end

@implementation ContactItem

@end

@interface ContactsViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@end

@implementation ContactsViewController
{
    NSArray * _arrTableStruct;
    NSMutableArray *_arrayRelated;
    NSMutableArray *_arrayMsg;
    NSMutableArray *_arraySearch;
    UITableView *m_tableContact;
    
    EGORefreshTableHeaderView* _egoRefreshTableHeaderView;
    BOOL _bUpHandleLoading;
    NSString *_strLatestUserMsg;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadRelatedCount:(int)nFriendCount AttentCount:(int)nAttentCount FansCount:(int)nFansCount DeFriendCount:(int)nDeFriendCount
{
    [_arrayRelated removeAllObjects];
    
    ContactItem *contactItem = [[ContactItem alloc]init];
    contactItem.contactTitle = [NSString stringWithFormat:@"朋友 (%d)", nFriendCount];
    contactItem.contactImg = @"contact-friends";
    contactItem.eRelatedType = e_related_friend;
    [_arrayRelated addObject:contactItem];
    
    contactItem = [[ContactItem alloc]init];
    contactItem.contactTitle = [NSString stringWithFormat:@"关注 (%d)", nAttentCount];
    contactItem.contactImg = @"contact-follow";
    contactItem.eRelatedType = e_related_attention;
    [_arrayRelated addObject:contactItem];
    
    contactItem = [[ContactItem alloc]init];
    contactItem.contactTitle = [NSString stringWithFormat:@"粉丝 (%d)", nFansCount];
    contactItem.contactImg = @"contact-followers";
    contactItem.eRelatedType = e_related_fans;
    [_arrayRelated addObject:contactItem];
    
    contactItem = [[ContactItem alloc]init];
    contactItem.contactTitle = [NSString stringWithFormat:@"黑名单 (%d)", nDeFriendCount];
    contactItem.contactImg = @"contact-blackList-1";
    contactItem.eRelatedType = e_related_defriend;
    [_arrayRelated addObject:contactItem];
    
    [m_tableContact reloadData];
}

-(void)loadMsgData
{
    EventNewsInfo *eventNewsInfo = [[ApplicationContext sharedInstance]eventNewsInfo];
    
    _arrTableStruct = [NSArray arrayWithObjects:
                       [NSNumber numberWithInt:1],
                       [NSNumber numberWithInt:(eventNewsInfo.new_comment_count > 0 || eventNewsInfo.new_thumb_count > 0
                                                || eventNewsInfo.new_reward_count > 0 || eventNewsInfo.new_attention_count > 0) ? 2 : 1],
                       [NSNumber numberWithInt:4],
                       nil];
    
    [_arrayMsg removeAllObjects];
    
    ContactItem *contactItem = [[ContactItem alloc]init];
    contactItem.contactTitle = @"个人消息";
    contactItem.contactContent = _strLatestUserMsg;
    contactItem.contactImg = @"contact-personal-info";
    contactItem.unReadCount = eventNewsInfo.new_chat_count;
    [_arrayMsg addObject:contactItem];
    
    if (eventNewsInfo.new_comment_count > 0 || eventNewsInfo.new_thumb_count > 0 || eventNewsInfo.new_reward_count > 0
        || eventNewsInfo.new_attention_count > 0) {
        contactItem = [[ContactItem alloc]init];
        contactItem.contactTitle = @"系统消息";
        contactItem.contactContent = @"";
        contactItem.contactImg = @"contact-system-info";
        contactItem.unReadCount = eventNewsInfo.new_comment_count + eventNewsInfo.new_thumb_count + eventNewsInfo.new_reward_count + eventNewsInfo.new_attention_count;
        contactItem.contactContent = [NSString stringWithFormat:@"您有%ld个系统消息",
                                      (long)contactItem.unReadCount];
        
        /*if (eventNewsInfo.new_comment_count > 0 && eventNewsInfo.new_thumb_count > 0 && eventNewsInfo.new_reward_count > 0 && eventNewsInfo.new_attention_count > 0) {
            
        }
        else if (eventNewsInfo.new_comment_count > 0 && eventNewsInfo.new_thumb_count > 0) {
            contactItem.contactContent = [NSString stringWithFormat:@"您有%d个新的赞, %d条新的回复",
                                          eventNewsInfo.new_thumb_count, eventNewsInfo.new_comment_count];
        }
        else if(eventNewsInfo.new_comment_count > 0)
        {
            contactItem.contactContent = [NSString stringWithFormat:@"您有%d条新的回复", eventNewsInfo.new_comment_count];
        }
        else
        {
            contactItem.contactContent = [NSString stringWithFormat:@"您有%d条新的赞", eventNewsInfo.new_thumb_count];
        }*/
        
        [_arrayMsg addObject:contactItem];
    }
}

-(BOOL)bShowFooterViewController {
    return YES;
}

-(void)initNotifyMsg
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWebSocketMsgComing:) name:NOTIFY_MESSAGE_WEBSOCKET_COMING object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _arrayRelated = [[NSMutableArray alloc]init];
    _arrayMsg = [[NSMutableArray alloc]init];
    _arraySearch = [[NSMutableArray alloc]init];
    
    ContactItem *contactItem = [[ContactItem alloc]init];
    contactItem.contactTitle = @"搜索";
    contactItem.contactImg = @"contact-search";
    [_arraySearch addObject:contactItem];
    
    _strLatestUserMsg = @"";
    
    [self generateCommonViewInParent:self.view Title:@"联系人" IsNeedBackBtn:NO];

    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    
    CGRect rect = CGRectMake(0, 0, viewBody.frame.size.width, viewBody.frame.size.height);
    m_tableContact = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    m_tableContact.delegate = self;
    m_tableContact.dataSource = self;
    [viewBody addSubview:m_tableContact];
    
    m_tableContact.backgroundColor = [UIColor clearColor];
    m_tableContact.separatorColor = [UIColor clearColor];
    
    if ([m_tableContact respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [m_tableContact setSeparatorInset:UIEdgeInsetsZero];
    }
    
    //Create TopView For Table
    _egoRefreshTableHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - m_tableContact.frame.size.height, m_tableContact.frame.size.width, m_tableContact.frame.size.height)];
    _egoRefreshTableHeaderView.delegate = (id<EGORefreshTableHeaderDelegate>)self;
    _egoRefreshTableHeaderView.backgroundColor = [UIColor clearColor];
    [m_tableContact addSubview:_egoRefreshTableHeaderView];
    
    //  update the last update date
    [_egoRefreshTableHeaderView refreshLastUpdatedDate];
    
    [self initNotifyMsg];
    
    [self stopRefresh];
    [self loadMsgData];
    [self loadRelatedCount:0 AttentCount:0 FansCount:0 DeFriendCount:0];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"联系人 - ContactsViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"联系人 - ContactsViewController"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self reLoadContactData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"联系人 - ContactsViewController"];
}

-(void)reLoadContactData
{
    [[SportForumAPI sharedInstance]userGetRelaterdMembersCount:^void(int errorCode, int nFriendCount, int nAttectionCount, int nFansCount, int nDeFriend){
        [self stopRefresh];
        [self loadMsgData];
        [self loadRelatedCount:nFriendCount AttentCount:nAttectionCount FansCount:nFansCount DeFriendCount:nDeFriend];
    }];
}

- (void)handleWebSocketMsgComing:(NSNotification*) notification
{
    NSMutableArray *arrChatInfo = [[notification userInfo]objectForKey:@"WSChatInfoList"];
    NSMutableArray *arrSystemInfo = [[notification userInfo]objectForKey:@"WSSystemNotifyList"];
    
    if ([arrChatInfo count] > 0) {
        MsgWsInfo *msgWsInfo = [arrChatInfo lastObject];
        NSString* strNikeName = @"";
        NSString* strNewCount = @"";
        
        for (MsgWsBodyItem *msgWsBodyItem in msgWsInfo.push.body.data) {
            if ([msgWsBodyItem.type isEqualToString:@"nikename"]) {
                strNikeName = msgWsBodyItem.content;
            }
            else if([msgWsBodyItem.type isEqualToString:@"new_count"])
            {
                strNewCount = msgWsBodyItem.content;
            }
        }
        
        _strLatestUserMsg = [NSString stringWithFormat:@"%@发来%@新消息", strNikeName, strNewCount];
    }
    
    if ([arrChatInfo count] > 0 || [arrSystemInfo count] > 0) {
        [self loadMsgData];
        [m_tableContact reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"ContactsViewController dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_arrTableStruct objectAtIndex:section] integerValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_arrTableStruct count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellTableIdentifier = @"AccountIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: CellTableIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView* viewContent = [[UIImageView alloc]init];
        viewContent.tag = CONTACT_CONTENT_VIEW_TAG;
        [cell.contentView addSubview:viewContent];
        
        UIImageView * imgDescImage = [[UIImageView alloc] init];
        imgDescImage.tag = CONTACT_DESC_IMAGE_TAG;
        [viewContent addSubview:imgDescImage];
        
        UILabel * lbNearByTitle = [[UILabel alloc]init];
        lbNearByTitle.font = [UIFont boldSystemFontOfSize:14.0];
        lbNearByTitle.textAlignment = NSTextAlignmentLeft;
        lbNearByTitle.backgroundColor = [UIColor clearColor];
        lbNearByTitle.textColor = [UIColor blackColor];
        lbNearByTitle.tag = CONTACT_DESC_LABEL_TAG;
        [viewContent addSubview:lbNearByTitle];
        
        UIImageView * imgArrow = [[UIImageView alloc] init];
        imgArrow.tag = CONTACT_ARRAY_IMAGE_TAG;
        [viewContent addSubview:imgArrow];
        
        UILabel *lbContent = [[UILabel alloc]initWithFrame:CGRectZero];
        lbContent.tag = CONTACT_CONTENT_LABEL_TAG;
        lbContent.font = [UIFont boldSystemFontOfSize:11.0];
        lbContent.textAlignment = NSTextAlignmentLeft;
        lbContent.backgroundColor = [UIColor clearColor];
        lbContent.textColor = [UIColor lightGrayColor];
        lbContent.hidden = YES;
        [viewContent addSubview:lbContent];
        
        UIImageView *imgViewNum = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgViewNum.tag = CONTACT_NUM_IMAGE_TAG;
        imgViewNum.hidden = YES;
        [viewContent addSubview:imgViewNum];
        
        UILabel *lbNum = [[UILabel alloc]initWithFrame:CGRectZero];
        lbNum.tag = CONTACT_NUM_LABEL_TAG;
        lbNum.hidden = YES;
        [viewContent addSubview:lbNum];
        [viewContent bringSubviewToFront:lbNum];
    }
    
    ContactItem *contactItem = nil;
    
    if ([indexPath section] == 0) {
        contactItem = _arraySearch[[indexPath row]];
    }
    else if([indexPath section] == 1)
    {
        contactItem = _arrayMsg[[indexPath row]];
    }
    else
    {
        contactItem = _arrayRelated[[indexPath row]];
    }

    UIImage *imgBk = [UIImage imageNamed:@"transaction-block-bg"];
    imgBk = [imgBk resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(imgBk.size.height / 2) - 2, floorf(imgBk.size.width / 2) - 2, floorf(imgBk.size.height / 2) + 2, floorf(imgBk.size.width / 2) + 2)];
    
    UIImageView *viewContent = (UIImageView*)[cell.contentView viewWithTag:CONTACT_CONTENT_VIEW_TAG];
    viewContent.frame = CGRectMake(5, 1, 300, 50);
    [viewContent setImage:imgBk];
        
    UIImageView *imgDescImage = (UIImageView*)[viewContent viewWithTag:CONTACT_DESC_IMAGE_TAG];
    UIImage *image = [UIImage imageNamed:contactItem.contactImg];
    [imgDescImage setImage:image];
    imgDescImage.frame = CGRectMake(8, 3, 40, 40);
    
    UILabel * lbNearByTitle = (UILabel*)[viewContent viewWithTag:CONTACT_DESC_LABEL_TAG];
    lbNearByTitle.text = contactItem.contactTitle;
    //CGSize lbLeftSize = [lbNearByTitle.text sizeWithFont:lbNearByTitle.font
     //                                  constrainedToSize:CGSizeMake(150, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize lbLeftSize = [lbNearByTitle.text boundingRectWithSize:CGSizeMake(150, FLT_MAX)
                                                       options:options
                                                    attributes:@{NSFontAttributeName:lbNearByTitle.font} context:nil].size;
    
    lbNearByTitle.frame = CGRectMake(15 + image.size.width, 15, lbLeftSize.width, 20);
    
    UIImageView * imgArrow = (UIImageView*)[cell.contentView viewWithTag:CONTACT_ARRAY_IMAGE_TAG];
    image = [UIImage imageNamed:@"arrow-1"];
    [imgArrow setImage:image];
    imgArrow.frame = CGRectMake(viewContent.frame.size.width - 15 - image.size.width, 15, image.size.width, image.size.height);
    
    UILabel *lbNum = (UILabel*)[viewContent viewWithTag:CONTACT_NUM_LABEL_TAG];
    UILabel *lbContent = (UILabel*)[viewContent viewWithTag:CONTACT_CONTENT_LABEL_TAG];
    UIImageView *imgViewNum = (UIImageView*)[viewContent viewWithTag:CONTACT_NUM_IMAGE_TAG];
    
    imgViewNum.hidden = YES;
    lbNum.hidden = YES;
    lbContent.hidden = YES;
    
    if ([indexPath section] == 1) {
        if (contactItem.unReadCount > 0) {
            imgViewNum.userInteractionEnabled = NO;
            imgViewNum.hidden = NO;
            
            lbNum.userInteractionEnabled = NO;
            lbNum.backgroundColor = [UIColor clearColor];
            lbNum.textColor = [UIColor whiteColor];
            lbNum.font = [UIFont boldSystemFontOfSize:10];
            lbNum.textAlignment = NSTextAlignmentCenter;
            lbNum.text = [NSString stringWithFormat:@"%ld", (long)contactItem.unReadCount];
            
            if (contactItem.unReadCount >= 100) {
                lbNum.hidden = YES;
                imgViewNum.frame = CGRectMake(CGRectGetMaxX(imgDescImage.frame) - 4, 1, 9, 9);
                imgViewNum.image = [UIImage imageNamed:@"info-reddot-small"];
            }
            else
            {
                lbNum.hidden = NO;
                imgViewNum.frame = CGRectMake(CGRectGetMaxX(imgDescImage.frame) - 8, 1, 16, 16);
                imgViewNum.image = [UIImage imageNamed:@"info-reddot"];
            }
            
            lbNum.frame = imgViewNum.frame;
            
            if (contactItem.contactContent.length > 0) {
                lbNearByTitle.frame = CGRectMake(10 + CGRectGetMaxX(imgDescImage.frame), 5, lbLeftSize.width, 20);
                
                lbContent.hidden = NO;
                lbContent.text = contactItem.contactContent;
                //CGSize lbLeftSize = [lbContent.text sizeWithFont:lbContent.font
                 //                              constrainedToSize:CGSizeMake(150, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
                
                NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
                CGSize lbLeftSize = [lbContent.text boundingRectWithSize:CGSizeMake(150, FLT_MAX)
                                                                   options:options
                                                                attributes:@{NSFontAttributeName:lbContent.font} context:nil].size;
                lbContent.frame = CGRectMake(CGRectGetMinX(lbNearByTitle.frame), CGRectGetMaxY(lbNearByTitle.frame), lbLeftSize.width, 20);
            }
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat fHeight = 5;
    
    if(section > 0)
    {
        fHeight = 8;
    }
    
    return fHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0)
    {
        SearchViewController *searchViewController = [[SearchViewController alloc]init];
        [self.navigationController pushViewController:searchViewController animated:YES];
    }
    else if(indexPath.section == 1)
    {
        if([indexPath row] == 0)
        {
            ChatDetailViewController *chatDetailViewController = [[ChatDetailViewController alloc]init];
            [self.navigationController pushViewController:chatDetailViewController animated:YES];
        }
        else
        {
            SystemNotifyViewController *systemNotifyViewController = [[SystemNotifyViewController alloc]init];
            [self.navigationController pushViewController:systemNotifyViewController animated:YES];
        }
    }
    else
    {
        ContactItem *contactItem = _arrayRelated[[indexPath row]];
        e_related_people_type eRelatedType = e_related_people_friend;
    
        if (contactItem.eRelatedType == e_related_friend) {
            eRelatedType = e_related_people_friend;
        }
        else if(contactItem.eRelatedType == e_related_attention)
        {
            eRelatedType = e_related_people_attention;
        }
        else if(contactItem.eRelatedType == e_related_fans)
        {
            eRelatedType = e_related_people_fans;
        }
        else if(contactItem.eRelatedType == e_related_defriend)
        {
            eRelatedType = e_related_people_defriend;
        }
        else if(contactItem.eRelatedType == e_related_weibo)
        {
            eRelatedType = e_related_people_weibo;
        }
    
        UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
        RelatedPeoplesViewController *relatedPeoplesViewController = [[RelatedPeoplesViewController alloc]init];
        relatedPeoplesViewController.eRelatedType = eRelatedType;
        relatedPeoplesViewController.strUserId = userInfo.userid;
        [self.navigationController pushViewController:relatedPeoplesViewController animated:YES];
    }
}

-(void)stopRefresh {
    if (_bUpHandleLoading) {
        _bUpHandleLoading = NO;
        [_egoRefreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:m_tableContact];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_bUpHandleLoading == NO) {
        [_egoRefreshTableHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[_egoRefreshTableHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	_bUpHandleLoading = YES;
    [self performSelector:@selector(reLoadContactData) withObject:nil afterDelay:0.2];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _bUpHandleLoading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
}

@end
