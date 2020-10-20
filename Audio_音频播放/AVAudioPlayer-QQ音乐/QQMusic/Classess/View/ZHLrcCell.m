//
//  ZHLrcCell.m
//  QQMusic
//
//  Created by niugaohang on 15/9/11.
//  Copyright (c) 2015年 niu. All rights reserved.
//

#import "ZHLrcCell.h"
#import "ZHLrcLabel.h"
#import "Masonry.h"

@implementation ZHLrcCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        ZHLrcLabel *lrcLabel = [[ZHLrcLabel alloc] init];
        lrcLabel.textColor = [UIColor whiteColor];
        lrcLabel.font = [UIFont systemFontOfSize:16.0];
        lrcLabel.textAlignment = NSTextAlignmentCenter;
        lrcLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:lrcLabel];
        _lrcLabel = lrcLabel;
        lrcLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [lrcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
    }
    return self;
}

+ (instancetype)lrcCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"LrcCell";
    ZHLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ZHLrcCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

@end

