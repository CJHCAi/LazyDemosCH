//
//  DFSectionIndexTabelViewController.h
//  coder
//
//  Created by Allen Zhong on 15/5/15.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseTableViewController.h"

@interface DFSectionIndexTabelViewController : DFBaseTableViewController

-(NSMutableArray *) getTitles;
-(NSMutableArray *) getUnIndexedTitles;


-(void) onClickIndex:(NSInteger)index;
-(void) onClickUnIndexTitlesIndex:(NSInteger)index;



-(UITableViewCell *) tableViewCellAtIndex:(NSUInteger)index tableView:(UITableView *)tableView;
-(UITableViewCell *) tableViewUnIndexedCellAtIndex:(NSUInteger)index tableView:(UITableView *)tableView;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com