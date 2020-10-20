//
//  DFUserTimeLineViewController.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/10/15.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFUserTimeLineViewController.h"
#import "DFBaseUserLineItem.h"

#import "DFBaseUserLineCellAdapter.h"
#import "DFUserLineCellAdapterManager.h"
#import "DFTextImageUserLineCellAdapter.h"

#import "DFBaseUserLineCell.h"

@interface DFUserTimeLineViewController()<DFBaseUserLineCellDelegate>

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, assign) NSUInteger currentDay;

@property (nonatomic, assign) NSUInteger currentMonth;

@property (nonatomic, assign) NSUInteger currentYear;

@end


@implementation DFUserTimeLineViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _items = [NSMutableArray array];
        
        DFUserLineCellAdapterManager *manager = [DFUserLineCellAdapterManager sharedInstance];
        
        DFTextImageUserLineCellAdapter *textImageCellAdapter = [[DFTextImageUserLineCellAdapter alloc] init];
        [manager registerAdapter:UserLineItemTypeTextImage adapter:textImageCellAdapter];
        
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}





#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DFBaseUserLineItem *item = [_items objectAtIndex:indexPath.row];
    DFBaseUserLineCellAdapter *adapter = [self getAdapter:item.itemType];
    return [adapter getCellHeight:item];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DFBaseUserLineItem *item = [_items objectAtIndex:indexPath.row];
    DFBaseUserLineCellAdapter *adapter = [self getAdapter:item.itemType];
    
    DFBaseUserLineCell *cell = (DFBaseUserLineCell *)[adapter getCell:tableView];
    cell.delegate = self;
    [adapter updateCell:cell message:item];
    
    return cell;
}

#pragma mark - Method

-(DFBaseUserLineCellAdapter *) getAdapter:(UserLineItemType)itemType
{
    DFUserLineCellAdapterManager *manager = [DFUserLineCellAdapterManager sharedInstance];
    return [manager getAdapter:itemType];
}


-(void)addItem:(DFBaseUserLineItem *)item
{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(item.ts/1000)];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger year = [components year];
    
    item.year = year;
    item.month = month;
    item.day = day;
    
    if (year == _currentYear && month == _currentMonth && day == _currentDay) {
        item.bShowTime = NO;
    }else{
        item.bShowTime = YES;
    }
    
    _currentDay = day;
    _currentMonth = month;
    _currentYear = year;

    NSLog(@"%ld %ld %ld %d", (long)year, (long)month, (long)day, item.bShowTime);
    
    [_items addObject:item];
    [self.tableView reloadData];
}



-(void)onClickItem:(DFBaseUserLineItem *)item
{
    
}



@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com