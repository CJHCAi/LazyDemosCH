//
//  TaskCell.m
//  ReuseTableViewDemo
//
//  Created by 萧奇 on 2017/10/1.
//  Copyright © 2017年 萧奇. All rights reserved.
//

#import "TaskCell.h"

@interface TaskCell ()

@property (nonatomic, strong) UILabel *topicLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIView *numberView;

@end

@implementation TaskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 图标
        self.imageButton = [[UIButton alloc] initWithFrame:CGRectMake(24, 13, 42, 42)];
        [self.imageButton setBackgroundImage:[UIImage imageNamed:@"icon_list_relation"] forState:UIControlStateNormal];
        [self.imageButton setBackgroundImage:[UIImage imageNamed:@"icon_list_relation_hover"] forState:UIControlStateSelected];
        [self.imageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.imageButton];
        // 时间
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 12.5 - SCREEN_WIDTH/3, 18, SCREEN_WIDTH/3, 23)];
        self.timeLabel.text = @"6/21";
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.font = [UIFont systemFontOfSize:11];
        self.timeLabel.textColor = RGB(153, 153, 153, 1);
        [self addSubview:self.timeLabel];
        // 标题
        self.topicLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.imageButton.right + 10, 14.5, self.timeLabel.left - self.imageButton.right - 10, 16)];
        self.topicLabel.font = [UIFont systemFontOfSize:17];
        [self addSubview:self.topicLabel];
        // 内容
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.imageButton.right + 10, self.topicLabel.bottom + 11.5, SCREEN_WIDTH - self.imageButton.right - 10, 12.5)];
        self.contentLabel.font = [UIFont systemFontOfSize:13];
        self.contentLabel.textColor = RGB(153, 153, 153, 1);
        [self addSubview:self.contentLabel];
    }
    return self;
}

- (void)imageButtonClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.relateDelegate addTaskToRecord:_task];
    } else {
        [self.relateDelegate deleteTaskToRecord:_task];
    }
}

- (void)setTask:(Task *)task {
    
    _task = task;
    self.imageButton.selected = _task.isSelected;
    self.topicLabel.text = _task.TITLE;
    self.contentLabel.text = _task.CONTENT;
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
