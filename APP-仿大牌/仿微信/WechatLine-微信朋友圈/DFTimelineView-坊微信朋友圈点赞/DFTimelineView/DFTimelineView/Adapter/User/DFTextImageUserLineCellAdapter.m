//
//  DFTextImageUserLineCellAdapter.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/10/15.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFTextImageUserLineCellAdapter.h"
#import "DFTextImageUserLineCell.h"

#define TextImageUserCell @"timeline_user_cell_text_image"

@implementation DFTextImageUserLineCellAdapter


-(CGFloat) getCellHeight:(DFBaseUserLineItem *)item
{
    return [DFTextImageUserLineCell getCellHeight:item];
}


-(UITableViewCell *)getCell:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TextImageUserCell];
    if (cell == nil ) {
        cell = [[DFTextImageUserLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextImageUserCell];
    }
    
    return cell;
}

-(void)updateCell:(DFBaseUserLineCell *)cell message:(DFTextImageUserLineItem *)item
{
    [cell updateWithItem:item];
}



@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com