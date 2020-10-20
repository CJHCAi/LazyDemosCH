//
//  DFBaseLineCellAdapter.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseLineItem.h"

@interface DFBaseLineCellAdapter : NSObject

-(CGFloat) getCellHeight:(DFBaseLineItem *) item;

-(UITableViewCell *) getCell:(UITableView *) tableView;

-(void) updateCell:(UITableViewCell *) cell message:(DFBaseLineItem *)item;

@end
