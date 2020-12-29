//
//  SearchViewController.m
//  SportForum
//
//  Created by liyuan on 14-10-10.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "SearchViewController.h"
#import "UIViewController+SportFormu.h"
#import "INSSearchBar.h"
#import "RelatedPeopleCell.h"
#import "AccountPreViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "IQKeyboardManager.h"

#define SEARCH_NORMAL_WEIGHT 40
@interface SearchViewController ()<INSSearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextFieldDelegate,UITextViewDelegate>

@end

@implementation SearchViewController
{
    UITableView *m_tableReleated;
    UILabel *m_lbResult;
    NSMutableArray * _arrReleated;
    NSString *_strFirstPageId;
    NSString *_strLastPageId;
    BOOL _blDownHandleLoading;
    UIActivityIndicatorView *_tableFooterActivityIndicator;
    
    EGORefreshTableHeaderView* _egoRefreshTableHeaderView;
    BOOL _bUpHandleLoading;
    BOOL _bFirstShowSearch;
    
    NSString *_strSearchKey;
    INSSearchBar *_searchBarWithDelegate;
    IQKeyboardReturnKeyHandler *_returnKeyHandler;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)createBoardTable:(CGRect)rectTable
{
    m_tableReleated = [[UITableView alloc] initWithFrame:rectTable style:UITableViewStylePlain];
    m_tableReleated.delegate = self;
    m_tableReleated.dataSource = self;
    m_tableReleated.scrollEnabled = YES;
    m_tableReleated.backgroundColor = [UIColor clearColor];
    m_tableReleated.separatorColor = [UIColor clearColor];
    
    if ([m_tableReleated respondsToSelector:@selector(setSeparatorInset:)]) {
        [m_tableReleated setSeparatorInset:UIEdgeInsetsZero];
    }
    
    //Create BottomView For Table
    m_tableReleated.tableFooterView = nil;
    m_tableReleated.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, m_tableReleated.frame.size.width, 40.0f)];
    _tableFooterActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    [_tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [_tableFooterActivityIndicator setCenter:[m_tableReleated.tableFooterView center]];
    [m_tableReleated.tableFooterView addSubview:_tableFooterActivityIndicator];
    
    //Create TopView For Table
    _egoRefreshTableHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - m_tableReleated.frame.size.height, m_tableReleated.frame.size.width, m_tableReleated.frame.size.height)];
    _egoRefreshTableHeaderView.delegate = (id<EGORefreshTableHeaderDelegate>)self;
    _egoRefreshTableHeaderView.backgroundColor = [UIColor clearColor];
    [m_tableReleated addSubview:_egoRefreshTableHeaderView];
    
    //  update the last update date
    [_egoRefreshTableHeaderView refreshLastUpdatedDate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _arrReleated = [[NSMutableArray alloc]init];
    [self generateCommonViewInParent:self.view Title:@"搜索" IsNeedBackBtn:YES];
    
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
    
    UIImageView *viewTitleBar = (UIImageView *)[self.view viewWithTag:GENERATE_VIEW_TITLE_BAR];
    _searchBarWithDelegate = [[INSSearchBar alloc] initWithFrame:CGRectMake(CGRectGetMaxX(viewTitleBar.frame) - SEARCH_NORMAL_WEIGHT, CGRectGetMinY(viewTitleBar.frame) + 3, SEARCH_NORMAL_WEIGHT, 34.0)];
	_searchBarWithDelegate.delegate = self;
	[self.view addSubview:_searchBarWithDelegate];
    
    m_lbResult = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, viewBody.frame.size.width - 20, 30)];
    m_lbResult.backgroundColor = [UIColor clearColor];
    m_lbResult.text = @"没有搜到匹配的用户！";
    m_lbResult.textColor = [UIColor blackColor];
    m_lbResult.font = [UIFont boldSystemFontOfSize:14];
    m_lbResult.textAlignment = NSTextAlignmentLeft;
    m_lbResult.hidden = YES;
    [viewBody addSubview:m_lbResult];
    
    rect = CGRectMake(0, 0, viewBody.frame.size.width, viewBody.frame.size.height);
    [self createBoardTable:rect];
    [viewBody addSubview:m_tableReleated];
    
    _returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    [_returnKeyHandler setLastTextFieldReturnKeyType:UIReturnKeySearch];
    _returnKeyHandler.delegate = self;
    [_returnKeyHandler addTextFieldView:_searchBarWithDelegate.searchField];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    _strSearchKey = @"";
    _strFirstPageId = @"";
    _bFirstShowSearch = YES;
    //[self reloadLeadBoardData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_bFirstShowSearch) {
        _bFirstShowSearch = NO;
        [_searchBarWithDelegate initSearchBarPop];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_searchBarWithDelegate.searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_searchBarWithDelegate addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [MobClick beginLogPageView:@"搜索 - SearchViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"搜索 - SearchViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [_searchBarWithDelegate.searchField removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_searchBarWithDelegate removeObserver:self forKeyPath:@"frame"];
    [[ApplicationContext sharedInstance]cancelCurrentRequests:[NSArray arrayWithObjects:urlUserSearch, nil]];
    [MobClick endLogPageView:@"搜索 - SearchViewController"];
    [super viewWillDisappear:animated];
}

-(void)dealloc
{
    [_returnKeyHandler removeTextFieldView:_searchBarWithDelegate.searchField];
    _returnKeyHandler = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateSearchControl
{
    UIImageView *viewImgBack = (UIImageView*)[self.view viewWithTag:GENERATE_IMAGE_BACK];
    UIImageView *viewTitleBar = (UIImageView *)[self.view viewWithTag:GENERATE_VIEW_TITLE_BAR];
    UILabel *labelTitle = (UILabel*)[viewTitleBar viewWithTag:GENERATE_VIEW_TITLE];
    CSButton *btnBack = (CSButton*)[self.view viewWithTag:GENERATE_BTN_BACK];
    
    BOOL bHideControl = NO;
    CGRect rect = _searchBarWithDelegate.frame;
    
    if (rect.size.width != SEARCH_NORMAL_WEIGHT) {
        bHideControl = YES;
    }
    
    viewImgBack.hidden = bHideControl;
    labelTitle.hidden = bHideControl;
    btnBack.hidden = bHideControl;
}

#pragma mark - Key-value Observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == _searchBarWithDelegate && [keyPath isEqualToString:@"frame"]) {
        [self updateSearchControl];
    }
}

#pragma mark - search bar delegate

- (CGRect)destinationFrameForSearchBar:(INSSearchBar *)searchBar
{
    UIImageView *viewTitleBar = (UIImageView *)[self.view viewWithTag:GENERATE_VIEW_TITLE_BAR];
	return CGRectMake(10, CGRectGetMinY(viewTitleBar.frame) + 5, CGRectGetWidth(viewTitleBar.frame) - 10, 30);
}

- (void)searchBar:(INSSearchBar *)searchBar willStartTransitioningToState:(INSSearchBarState)destinationState
{
	// Do whatever you deem necessary.
    NSLog(@"sdas");
}

- (void)searchBar:(INSSearchBar *)searchBar didEndTransitioningFromState:(INSSearchBarState)previousState
{
	// Do whatever you deem necessary.
    NSLog(@"sdas");
}

- (void)searchBarDidTapReturn:(INSSearchBar *)searchBar
{
	// Do whatever you deem necessary.
	// Access the text from the search bar like searchBar.searchField.text
    NSLog(@"sdas");
}

- (void)searchBarTextDidChange:(INSSearchBar *)searchBar
{
	// Do whatever you deem necessary.
	// Access the text from the search bar like searchBar.searchField.text
    if ([searchBar.searchField.text isEqualToString:@""]) {
        _strSearchKey = @"";
        _strFirstPageId = @"";
        [_arrReleated removeAllObjects];
        [m_tableReleated reloadData];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.markedTextRange == nil && textField.text.length > 14) {
        textField.text = [textField.text substringToIndex:14];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.text.length > 0)
    {
        _strSearchKey = textField.text;
        _strFirstPageId = @"";
        [self reloadLeadBoardData];
    }
}

/*- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _strSearchKey = textField.text;
    _strFirstPageId = @"";
    [self reloadLeadBoardData];
    return YES;
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrReleated count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeaderBoardItem *leaderBoardItem = _arrReleated[indexPath.row];
    RelatedPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RelatedPeopleCell"];
    
    if (cell == nil) {
        cell = [[RelatedPeopleCell alloc]initWithReuseIdentifier:@"RelatedPeopleCell"];
    }
    
    cell.leaderBoardItem = leaderBoardItem;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RelatedPeopleCell heightOfCell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Current Row is %ld!", (long)indexPath.row);
    
    if ([_arrReleated count] > 0) {
        LeaderBoardItem *leaderBoardItem = _arrReleated[indexPath.row];
        AccountPreViewController *accountPreViewController = [[AccountPreViewController alloc]init];
        accountPreViewController.strUserId = leaderBoardItem.userid;
        [self.navigationController pushViewController:accountPreViewController animated:YES];
    }
}

-(void)reloadLeadBoardData
{
    [self loadServerData:_strFirstPageId LastPageId:@""];
}

-(void)loadServerData:(NSString*)strFirstrPageId LastPageId:(NSString*)strLastPageId
{
    m_lbResult.hidden = YES;
    [_searchBarWithDelegate.searchField setEnabled:YES];
    
    __weak __typeof(self) weakself = self;
    
    [[SportForumAPI sharedInstance]userSearchByPageId:strFirstrPageId LastPageId:strLastPageId PageItemNum:20 IsNearBy:NO NickName:_strSearchKey FinishedBlock:^void(int errorCode, LeaderBoardItemList *leaderBoardItemList){
        __typeof(self) strongself = weakself;
        
        if (strongself != nil) {
            [self stopRefresh];
            
            if (errorCode == 0) {
                if ([leaderBoardItemList.members_list.data count] > 0) {
                    if (strFirstrPageId.length == 0 && strLastPageId.length == 0) {
                        [_arrReleated removeAllObjects];
                        
                        _strFirstPageId = leaderBoardItemList.page_frist_id;
                        _strLastPageId = leaderBoardItemList.page_last_id;
                    }
                    else if (strFirstrPageId.length == 0 && strLastPageId.length > 0)
                    {
                        _strLastPageId = leaderBoardItemList.page_last_id;
                    }
                    else if(strFirstrPageId.length > 0 && strLastPageId.length == 0)
                    {
                        _strFirstPageId = leaderBoardItemList.page_frist_id;
                    }
                    
                    [_arrReleated addObjectsFromArray:leaderBoardItemList.members_list.data];
                }
                else if(strFirstrPageId.length == 0 && strLastPageId.length == 0)
                {
                    [_arrReleated removeAllObjects];
                }
                
                m_lbResult.hidden = (_arrReleated.count > 0 ? YES : NO);
                [m_tableReleated reloadData];
            }
        }
    }];
}

-(void)stopRefresh {
    if (_bUpHandleLoading) {
        _bUpHandleLoading = NO;
        [_egoRefreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:m_tableReleated];
    }
    
    if (_blDownHandleLoading) {
        _blDownHandleLoading = NO;
        [self tableBootomShow:NO];
    }
}

-(void)tableBootomShow:(BOOL)blShow {
    if (blShow) {
        [_tableFooterActivityIndicator startAnimating];
    }
    else {
        [_tableFooterActivityIndicator stopAnimating];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(_strSearchKey.length > 0)
    {
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        CGFloat y = offset.y + bounds.size.height - inset.bottom;
        CGFloat h = size.height;
        
        NSLog(@"%.2f %.2f %d", y, h, _blDownHandleLoading);
        
        //if((y > (h + 50) && h > bounds.size.height) && _blDownHandleLoading == NO) {
        if((y > (h + 50)) && _blDownHandleLoading == NO){
            [self tableBootomShow:YES];
            _blDownHandleLoading = YES;
            [self loadServerData:@"" LastPageId:_strLastPageId];
        }
        
        if (_bUpHandleLoading == NO) {
            [_egoRefreshTableHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[_egoRefreshTableHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	_bUpHandleLoading = YES;
    _strFirstPageId = @"";
    [self performSelector:@selector(reloadLeadBoardData) withObject:nil afterDelay:0.2];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _bUpHandleLoading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
}

@end
