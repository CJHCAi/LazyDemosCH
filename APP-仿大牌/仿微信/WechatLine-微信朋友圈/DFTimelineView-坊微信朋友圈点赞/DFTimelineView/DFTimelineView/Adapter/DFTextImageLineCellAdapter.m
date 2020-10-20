//
//  DFTextImageLineCellAdapter.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFTextImageLineCellAdapter.h"
#import "DFTextImageLineCell.h"

#define TextImageCell @"timeline_cell_text_image"

@implementation DFTextImageLineCellAdapter

-(CGFloat) getCellHeightByCount:(DFBaseLineItem *)item
{
    return [DFTextImageLineCell getCellHeight:item];
}


-(UITableViewCell *)getCell:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TextImageCell];
    if (cell == nil ) {
        cell = [[DFTextImageLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextImageCell];
    }
    
    return cell;
}

-(void)updateCell:(DFBaseLineCell *)cell message:(DFBaseLineItem *)item
{
    [cell updateWithItem:item];
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com