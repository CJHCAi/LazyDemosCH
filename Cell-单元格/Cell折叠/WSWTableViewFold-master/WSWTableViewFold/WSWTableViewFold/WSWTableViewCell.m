//
//  WSWTableViewCell.m
//  WSWTableViewFoldOpen
//
//  Created by WSWshallwe on 2017/5/25.
//  Copyright © 2017年 shallwe. All rights reserved.
//

#import "WSWTableViewCell.h"

@implementation WSWTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = [UIColor lightTextColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
    label.text = @"你打开我啦 ---.--- //--.--  ✨🌟🌟 ✌️";
    [self addSubview:label];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
