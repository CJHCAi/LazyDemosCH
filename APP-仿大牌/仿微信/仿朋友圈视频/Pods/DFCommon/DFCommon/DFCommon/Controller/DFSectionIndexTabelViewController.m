//
//  DFSectionIndexTabelViewController.m
//  coder
//
//  Created by Allen Zhong on 15/5/15.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFSectionIndexTabelViewController.h"
#import "pinyin.h"

@interface DFSectionIndexTabelViewController()

@property (nonatomic, strong) NSArray *titles;


@property (nonatomic,strong) NSMutableDictionary *titleDic;

@property (nonatomic,strong) NSMutableDictionary *sectionMap;

@property (nonatomic,strong) NSArray *sortedFirstCharArray;

@end



@implementation DFSectionIndexTabelViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _titleDic = [NSMutableDictionary dictionary];
        _sectionMap = [NSMutableDictionary dictionary];
        self.style = UITableViewStyleGrouped;
    }
    return self;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = [UIColor darkGrayColor];
    
    [self initFirstChars];
}


-(void) initFirstChars
{
    
    NSArray *titles = [self getTitles];
    for (int index = 0; index < titles.count; index ++) {
        
        NSString *title = [titles objectAtIndex:index];
        
        NSString *firstChar = [self getFirstChar:title];
        
        
        NSMutableArray *sectionTitles = [_titleDic objectForKey:firstChar];
        if (sectionTitles == nil) {
            sectionTitles = [NSMutableArray array];
            [_titleDic setObject:sectionTitles forKey:firstChar];
        }
        [sectionTitles addObject:title];
        
        NSMutableDictionary *sectionTitleDic = [_sectionMap objectForKey:firstChar];
        if (sectionTitleDic == nil) {
            sectionTitleDic = [NSMutableDictionary dictionary];
            [_sectionMap setObject:sectionTitleDic forKey:firstChar];
        }
        
        [sectionTitleDic setObject:[NSNumber numberWithInteger:index] forKey:[NSNumber numberWithInteger:(sectionTitles.count -1)]];
        
        
    }
}


-(NSArray *) getFirstCharArray
{
    if (_sortedFirstCharArray == nil) {
        NSArray *array = [_titleDic allKeys];
        _sortedFirstCharArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
    }
    
    return _sortedFirstCharArray;
}

-(NSMutableArray *)getTitles
{
    return nil;
}

-(NSMutableArray *) getUnIndexedTitles
{
    return nil;
}


-(BOOL) isShowUnIndexedTitles
{
    NSMutableArray *array = [self getUnIndexedTitles];
    if (array && array.count > 0) {
        return YES;
    }else{
        return NO;
    }
}



- (NSString *) getFirstChar:(NSString *)str
{
    
    if ([str canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        return [[NSString stringWithFormat:@"%c", [str characterAtIndex:0]] uppercaseString];
    }
    else {
        return [[HTFirstLetter firstLetter:str] uppercaseString];
    }
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return [self getFirstCharArray];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if ([self isShowUnIndexedTitles]) {
        if (section == 0) {
            return @"";
        }else{
            return [[self getFirstCharArray] objectAtIndex:(section-1)];
        }
    }else{
        return [[self getFirstCharArray] objectAtIndex:section];
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    if ([self isShowUnIndexedTitles]) {
        return [self getFirstCharArray].count+1;
    }
    return [self getFirstCharArray].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([self isShowUnIndexedTitles]) {
        
        if (section == 0) {
            return [self getUnIndexedTitles].count;
        }else{
            NSString *firstChar = [[self getFirstCharArray] objectAtIndex:(section-1)];
            NSMutableArray *sectionTitles = [_titleDic objectForKey:firstChar];
            return sectionTitles.count;
        }
        
    }else{
        NSString *firstChar = [[self getFirstCharArray] objectAtIndex:section];
        NSMutableArray *sectionTitles = [_titleDic objectForKey:firstChar];
        return sectionTitles.count;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self isShowUnIndexedTitles] && indexPath.section == 0) {
        
        UITableViewCell *cell = [self tableViewUnIndexedCellAtIndex:indexPath.row tableView:tableView];
        return cell;
        
    }else{
        UITableViewCell *cell = [self tableViewCellAtIndex:[self getIndex:indexPath] tableView:tableView];
        return cell;
    }
}


-(UITableViewCell *) tableViewCellAtIndex:(NSUInteger)index tableView:(UITableView *)tableView
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    cell.textLabel.text = [[self getTitles] objectAtIndex:index];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

-(UITableViewCell *)tableViewUnIndexedCellAtIndex:(NSUInteger)index tableView:(UITableView *)tableView
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if ([self isShowUnIndexedTitles] && section == 0) {
        return 0.01;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}



-(NSInteger) getIndex:(NSIndexPath *) indexPath
{
    NSInteger section = indexPath.section;
    if ([self isShowUnIndexedTitles]) {
        section = section - 1;
    }
    NSInteger row = indexPath.row;
    NSArray *array = [self getFirstCharArray];
    NSString *firstChar = [array objectAtIndex:section];
    NSMutableDictionary *dic = [_sectionMap objectForKey:firstChar];
    NSInteger titleIndex = [[dic objectForKey:[NSNumber numberWithInteger:row]] integerValue];
    return titleIndex;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self isShowUnIndexedTitles] && indexPath.section == 0) {
        
        [self onClickUnIndexTitlesIndex:indexPath.row];
    }else{
        
        [self onClickIndex:[self getIndex:indexPath]];
    }
}

-(void)onClickIndex:(NSInteger)index
{
    NSLog(@"%@",[[self getTitles] objectAtIndex:index]);
}

-(void)onClickUnIndexTitlesIndex:(NSInteger)index{
    
}

@end
