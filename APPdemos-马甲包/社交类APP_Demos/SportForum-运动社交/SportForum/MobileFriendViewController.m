//
//  MobileFriendViewController.m
//  SportForum
//
//  Created by liyuan on 1/6/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "MobileFriendViewController.h"
#import "UIViewController+SportFormu.h"
#import "SMS_SDK/SMS_SDK.h"
#import "SMS_SDK/SMS_AddressBook.h"
#import "AlertManager.h"
#import "MobileTableViewCell.h"
#import "SMS_SDK/SMS_SDK.h"

@interface MobileFriendViewController ()<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>

@end

@implementation MobileFriendViewController
{
    id m_processWindow;
    UILabel *m_lbTips;
    UITableView *m_table;
    UISearchBar *m_search;
    BOOL m_isSearching;

    NSMutableArray* _arrAddJoined;
    NSMutableArray* _arrAddBook;
    NSMutableArray* _addressBookData;
    NSMutableArray* _addressJoinedData;
    NSMutableArray *_sessionKeys;
    NSMutableDictionary *_sessionNames;
    
    UIActivityIndicatorView* _activityIndicatorView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self generateCommonViewInParent:self.view Title:@"已经加入的朋友" IsNeedBackBtn:YES];
    
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
    
    m_search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 5.0, viewBody.frame.size.width, 34.0)];
    m_search.delegate = self;
    m_search.backgroundColor = [UIColor clearColor];
    [viewBody addSubview:m_search];
    
    for (UIView *view in m_search.subviews) {
        // for before iOS7.0
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    
    m_table = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, viewBody.frame.size.width, viewBody.frame.size.height - 45) style:UITableViewStylePlain];
    m_table.dataSource = self;
    m_table.delegate = self;
    m_table.backgroundColor = [UIColor clearColor];
    m_table.separatorColor = [UIColor clearColor];
    
    if ([m_table respondsToSelector:@selector(setSeparatorInset:)]) {
        [m_table setSeparatorInset:UIEdgeInsetsZero];
    }
    
    [viewBody addSubview:m_table];
    
    m_lbTips = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, viewBody.frame.size.width - 20, 60)];
    m_lbTips.backgroundColor = [UIColor clearColor];
    m_lbTips.textColor = [UIColor darkGrayColor];
    m_lbTips.font = [UIFont systemFontOfSize:14];
    m_lbTips.numberOfLines = 0;
    m_lbTips.text = @"您未授权访问联系人，请在【设置>隐私>通讯录】中授权访问，就可以看到通讯录好友了哦~";
    m_lbTips.hidden = YES;
    [viewBody addSubview:m_lbTips];
    
    //Create Add View
    UIImageView *viewTitleBar = (UIImageView *)[self.view viewWithTag:GENERATE_VIEW_TITLE_BAR];
    UIImageView *imgViewNew = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(viewTitleBar.frame) - 39, 27, 37, 37)];
    [imgViewNew setImage:[UIImage imageNamed:@"nav-plus-btn"]];
    [self.view addSubview:imgViewNew];
    
    CSButton *btnAdd = [CSButton buttonWithType:UIButtonTypeCustom];
    btnAdd.frame = CGRectMake(CGRectGetMinX(imgViewNew.frame) - 10, CGRectGetMinY(imgViewNew.frame) - 5, 50, 45);
    btnAdd.backgroundColor = [UIColor clearColor];
    [self.view addSubview:btnAdd];
    [self.view bringSubviewToFront:btnAdd];
    
    btnAdd.actionBlock = ^void()
    {
        [SMS_SDK sendSMS:@" " AndMessage:SMS_INVITE];
    };

    _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 48, 48)];
    _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityIndicatorView.color = [UIColor colorWithRed:0 green:137.0 / 255.0 blue:207.0 / 255.0 alpha:1.0];
    _activityIndicatorView.center = viewBody.center;
    _activityIndicatorView.hidden = NO;
    _activityIndicatorView.hidesWhenStopped = YES;
    [viewBody addSubview:_activityIndicatorView];
    
    _arrAddJoined = [[NSMutableArray alloc]init];
    _arrAddBook = [[NSMutableArray alloc]init];
    _addressBookData = [[NSMutableArray alloc]init];
    _addressJoinedData = [[NSMutableArray alloc]init];
    _sessionKeys = [[NSMutableArray alloc]init];
    _sessionNames = [[NSMutableDictionary alloc]init];
    
    [self getAddressBookFriends];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"MobileFriendViewController dealloc called!");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"已经加入的朋友 - MobileFriendViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"已经加入的朋友 - MobileFriendViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hidenCommonProgress];
    [self loadProcessShow:NO];
    [MobClick endLogPageView:@"已经加入的朋友 - MobileFriendViewController"];
    [[ApplicationContext sharedInstance]cancelCurrentRequests:[NSArray arrayWithObjects:urlImportContacts, nil]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)loadProcessShow:(BOOL)blShow {
    if (blShow) {
        [_activityIndicatorView startAnimating];
    } else {
        [_activityIndicatorView stopAnimating];
    }
}

-(void)showCommonProgress{
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    m_processWindow = [AlertManager showCommonProgressInView:viewBody];
}

-(void)hidenCommonProgress {
    [AlertManager dissmiss:m_processWindow];
}

- (void)resetSearch {
    [_sessionKeys removeAllObjects];
    
    [_sessionKeys addObject:UITableViewIndexSearch];//add the search icon to index bar
    [_sessionKeys addObjectsFromArray:[[_sessionNames allKeys]
                                   sortedArrayUsingSelector:@selector(compare:)]];
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
    NSMutableArray *sectionsToRemove = [[NSMutableArray alloc] init];
    [self resetSearch];
    
    [_addressBookData removeAllObjects];
    [_addressJoinedData removeAllObjects];
    
    [_addressBookData addObjectsFromArray:_arrAddBook];
    [_addressJoinedData addObjectsFromArray:_arrAddJoined];
        
    for (NSString *key in _sessionKeys) {
        NSMutableArray *array = [_sessionNames valueForKey:key];
        NSMutableArray *toRemove = [[NSMutableArray alloc] init];
        
        if (array == _addressBookData) {
            for (SMS_AddressBook *smsAddress in array) {
                if ([smsAddress.name rangeOfString:searchTerm
                                options:NSCaseInsensitiveSearch].location == NSNotFound)
                    [toRemove addObject:smsAddress];//add the  unfit object to remove array
            }
        }
        else
        {
            for (UserInfo *userInfo in array) {
                if ([userInfo.nikename rangeOfString:searchTerm
                                options:NSCaseInsensitiveSearch].location == NSNotFound)
                    [toRemove addObject:userInfo];//add the  unfit object to remove array
            }
        }
        
        //if all of the object in this section are unfit
        //add whole array's key to  section remove array
        if ([array count] == [toRemove count])
            [sectionsToRemove addObject:key];
        
        //remove the unfit objects in toRemove array
        [array removeObjectsInArray:toRemove];
    }
    // remove the unfit sections in sectionsToRemove array
    [_sessionKeys removeObjectsInArray:sectionsToRemove];
    
    //reload tableView data
    [m_table reloadData];
}

-(void)getMobileRegeditedFriends:(NSArray*)arrPhones
{
    __weak __typeof(self) weakSelf = self;
        
    [[SportForumAPI sharedInstance]userGetMobileFriendsByPhones:arrPhones FinishedBlock:^void(int errorCode, ImportContactList *importContactList){
        __typeof(self) strongSelf = weakSelf;
        
        if (strongSelf != nil) {
            [self loadProcessShow:NO];
            [_addressJoinedData removeAllObjects];
            [_arrAddJoined removeAllObjects];
            [_addressJoinedData addObjectsFromArray:importContactList.users.data];
            [_arrAddJoined addObjectsFromArray:_addressJoinedData];
            
            if ([_addressJoinedData count] > 0) {
                [_sessionNames setObject:_addressJoinedData forKey:@"已加入悦动力的手机联系人"];
            }
            
            if ([_addressBookData count] > 0) {
                [_sessionNames setObject:_addressBookData forKey:@"邀请手机联系人"];
            }
            
            if (!m_isSearching) {
                [self resetSearch];
                [m_table reloadData];
            }
        }
    }];
}

-(void)getAddressBookFriends
{
    [_arrAddJoined removeAllObjects];
    [_arrAddBook removeAllObjects];
    [_addressBookData removeAllObjects];
    [_addressJoinedData removeAllObjects];
    [_sessionNames removeAllObjects];
    _addressBookData = [SMS_SDK addressBook];
    
    if(ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized)
    {
        m_lbTips.hidden = NO;
        m_table.hidden = YES;

        //[AlertManager showAlertText:@"您未授权访问联系人，请在【设置>隐私>通讯录】中授权访问，就可以看到通讯录好友了哦" InView:self.view hiddenAfter:3];
    }
    else
    {
        m_lbTips.hidden = YES;
        m_table.hidden = NO;
        
        for (NSUInteger i = 0; i < _addressBookData.count; i++) {
            SMS_AddressBook* person = [_addressBookData objectAtIndex:i];
            
            if (person.phonesEx.count == 0) {
                [_addressBookData removeObjectAtIndex:i];
            }
        }
        
        [_arrAddBook addObjectsFromArray:_addressBookData];
        
        if ([_addressBookData count] > 0) {
            [_sessionNames setObject:_addressBookData forKey:@"邀请手机联系人"];
        }
        
        [self resetSearch];
        [m_table reloadData];

        [self loadProcessShow:YES];
        
        __weak __typeof(self) weakSelf = self;

        [SMS_SDK getAppContactFriends:1 result:^(enum SMS_ResponseState state, NSArray *array) {
            __typeof(self) strongSelf = weakSelf;
            
            if (strongSelf != nil) {
                if (1 == state)
                {
                    if ([array count] > 0) {
                        NSMutableArray *arrMobils = [[NSMutableArray alloc]init];
                        
                        for (int i = 0; i < array.count; i++) {
                            NSDictionary* dict1=[array objectAtIndex:i];
                            NSString* phone1=[dict1 objectForKey:@"phone"];
                            
                            [arrMobils addObject:phone1];
                            
                            for (int j = 0; j < _addressBookData.count; j++) {
                                SMS_AddressBook* person1=[_addressBookData objectAtIndex:j];
                                for (int k = 0; k < person1.phonesEx.count; k++) {
                                    if ([phone1 isEqualToString:[person1.phonesEx objectAtIndex:k]]) {
                                        [strongSelf->_addressBookData removeObjectAtIndex:j];
                                    }
                                }
                            }
                        }
                        
                        [strongSelf->_arrAddBook removeAllObjects];
                        [strongSelf->_arrAddBook addObjectsFromArray:strongSelf->_addressBookData];
                        
                        [strongSelf getMobileRegeditedFriends:arrMobils];
                    }
                    else
                    {
                        [strongSelf loadProcessShow:NO];
                    }
                }
                else if(0==state)
                {
                    [strongSelf loadProcessShow:NO];
                    [JDStatusBarNotification showWithStatus:@"获取手机联系人失败" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                }
            }
        }];
    }
}

-(void)refreshJoinedAfterAtttention:(UserInfo*)userItem
{
    [self showCommonProgress];
    
    __weak __typeof(self) weakSelf = self;
        
    [[SportForumAPI sharedInstance] userEnableAttentionByUserId:@[userItem.userid]
                                                      Attention:YES
                                                  FinishedBlock:^void(int errorCode, NSString* strDescErr, ExpEffect* expEffect)
     {
         __typeof(self) strongSelf = weakSelf;
         
         if (strongSelf != nil) {
             [self hidenCommonProgress];
             
             if(errorCode == 0)
             {
                 [_arrAddJoined removeAllObjects];
                 [_sessionNames removeAllObjects];
                 
                 for (int j = 0; j < _addressJoinedData.count; j++) {
                     UserInfo *userInfo = [_addressJoinedData objectAtIndex:j];
                     
                     if ([userInfo.userid isEqualToString:userItem.userid]) {
                         [_addressJoinedData removeObjectAtIndex:j];
                     }
                 }
                 
                 [_arrAddJoined addObjectsFromArray:_addressJoinedData];
                 
                 if ([_addressJoinedData count] > 0) {
                     [_sessionNames setObject:_addressJoinedData forKey:@"已加入悦动力的手机联系人"];
                 }
                 
                 if ([_addressBookData count] > 0) {
                     [_sessionNames setObject:_addressBookData forKey:@"邀请手机联系人"];
                 }
                 
                 [self resetSearch];
                 [m_table reloadData];
             }
             else
             {
                 [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
             }
         }
    }];
}

#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sessionKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    //for seaching mode,if not fit result return,nothing will be displayed
    if ([_sessionKeys count] == 0)
        return 0;
    
    NSString *key = [_sessionKeys objectAtIndex:section];
    NSArray *nameSection = [_sessionNames objectForKey:key];
    return [nameSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    
    NSString *key = [_sessionKeys objectAtIndex:section];
    NSArray *nameSection = [_sessionNames objectForKey:key];
    UserInfo *userInfoItem = [[UserInfo alloc]init];
    
    if (nameSection == _addressJoinedData) {
        userInfoItem = _addressJoinedData[indexPath.row];
    }
    else
    {
        SMS_AddressBook* person1 = [_addressBookData objectAtIndex:indexPath.row];
        userInfoItem.nikename = person1.name;
        userInfoItem.phone_number = person1.phones;
        
        int myindex = (indexPath.row) % 14;
        NSString* imagePath=[NSString stringWithFormat:@"Icon/%i.png",myindex+1];
        userInfoItem.profile_image = imagePath;
    }
    
    MobileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MobileTableViewCell"];
    
    if (cell == nil) {
        cell = [[MobileTableViewCell alloc]initWithReuseIdentifier:@"MobileTableViewCell"];
    }
    
    __weak __typeof(self) weakSelf = self;
    
    cell.attentionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
        
        if (userInfo != nil) {
            if (userInfo.ban_time > 0) {
                [JDStatusBarNotification showWithStatus:@"用户已被禁言，无法完成本次操作。" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                return;
            }
            else if(userInfo.ban_time < 0)
            {
                [JDStatusBarNotification showWithStatus:@"用户已进入黑名单，无法完成本次操作。" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                return;
            }
        }
        
        [strongSelf refreshJoinedAfterAtttention:userInfoItem];
    };
    
    cell.inviteBlock = ^void()
    {
        [SMS_SDK sendSMS:userInfoItem.phone_number.length > 0 ? userInfoItem.phone_number : @" " AndMessage:SMS_INVITE];
    };
    
    cell.userInfoItem = userInfoItem;
    return cell;
}

#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MobileTableViewCell heightOfCell];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    if ([_sessionKeys count] == 0)
        return nil;
    
    NSString *key = [_sessionKeys objectAtIndex:section];
    //the search bar section don't need header
    if (key == UITableViewIndexSearch)
        return nil;
    return key;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *key = [_sessionKeys objectAtIndex:section];
    //the search bar section don't need header
    if (key == UITableViewIndexSearch)
        return 0;
    return 35;
}

#pragma mark Table View Delegate Methods
- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //you can selectd a row to exit the searching mode
    [m_search resignFirstResponder];
    m_search.text = @"";
    m_isSearching = NO;
    [tableView reloadData];
    return indexPath;
}

- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index
{
    NSString *key = [_sessionKeys objectAtIndex:index];
    //if it is click the search title,show the search bar,else show the section at index
    if (key == UITableViewIndexSearch)
    {
        //show the search bar
        [tableView setContentOffset:CGPointZero animated:NO];
        return NSNotFound;
    }
    else return index;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *key = [_sessionKeys objectAtIndex:section];
    //the search bar section don't need header
    if (key == UITableViewIndexSearch)
        return nil;
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, m_table.frame.size.width, 35)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *lbSep1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, m_table.frame.size.width, 1)];
    lbSep1.backgroundColor = [UIColor colorWithRed:149.0 / 255.0 green:149.0 / 255.0 blue:149.0 / 255.0 alpha:1.0];
    [view addSubview:lbSep1];
    
    UILabel *lbSep2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 29, m_table.frame.size.width, 1)];
    lbSep2.backgroundColor = [UIColor colorWithRed:149.0 / 255.0 green:149.0 / 255.0 blue:149.0 / 255.0 alpha:1.0];
    [view addSubview:lbSep2];
    
    UILabel *lbTitle = [[UILabel alloc]initWithFrame:CGRectMake(8, 5, m_table.frame.size.width - 20, 20)];
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.text = key;
    lbTitle.textColor = [UIColor blackColor];
    lbTitle.font = [UIFont boldSystemFontOfSize:14];
    lbTitle.textAlignment = NSTextAlignmentLeft;
    [view addSubview:lbTitle];
    
    return view;
}

#pragma mark -
#pragma mark Search Bar Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //click search button at keyboard,will do something
    NSString *searchTerm = [searchBar text];
    [self handleSearchForTerm:searchTerm];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    m_isSearching = YES;
    [m_table reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchTerm
{
    if ([searchTerm length] == 0)
    {
        [self resetSearch];
        [_addressBookData removeAllObjects];
        [_addressJoinedData removeAllObjects];
        
        [_addressBookData addObjectsFromArray:_arrAddBook];
        [_addressJoinedData addObjectsFromArray:_arrAddJoined];
        [m_table reloadData];
        return;
    }
    
    //when you type something in text field,the search is beginning(synchronization)
    [self handleSearchForTerm:searchTerm];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //reset Search bar
    m_isSearching = NO;
    m_search.text = @"";
    
    [self resetSearch];
    [m_table reloadData];
    
    //dismiss the keyboard
    [searchBar resignFirstResponder];
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
