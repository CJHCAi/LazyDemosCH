//
//  DFTextVideoLineCellAdapter.m
//  DFTimelineView
//
//  Created by CaptainTong on 15/11/13.
//  Copyright © 2015年 Datafans, Inc. All rights reserved.
//

#import "DFTextVideoLineCellAdapter.h"
#import "DFTextVideoLineCell.h"


#define TextVideoCell @"timeline_cell_text_vedio"

@implementation DFTextVideoLineCellAdapter

-(CGFloat) getCellHeightByCount:(DFBaseLineItem *)item
{
    return [DFTextVideoLineCell getCellHeight:item];
}


-(UITableViewCell *)getCell:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TextVideoCell];
    if (cell == nil ) {
        cell = [[DFTextVideoLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextVideoCell];
    }
    
    return cell;
}

-(void)updateCell:(DFBaseLineCell *)cell message:(DFBaseLineItem *)item
{
    [cell updateWithItem:item];
}


@end
