//
//  ZHLrcCell.h
//  QQMusic
//
//  Created by niugaohang on 15/9/11.
//  Copyright (c) 2015年 niu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHLrcLabel;

@interface ZHLrcCell : UITableViewCell

/** 歌词的label */
@property (nonatomic, weak, readonly) ZHLrcLabel *lrcLabel;


+ (instancetype)lrcCellWithTableView:(UITableView *)tableView;

@end
