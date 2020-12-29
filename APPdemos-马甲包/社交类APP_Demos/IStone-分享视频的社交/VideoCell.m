//
//  VideoCell.m
//  IStone
//
//  Created by 胡传业 on 14-7-22.
//  Copyright (c) 2014年 NewThread. All rights reserved.
//

#import "VideoCell.h"

@interface VideoCell()

@end

@implementation VideoCell

// 覆写构造方法， 让自定义的 cell 上创建其他控件

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        self.backgroundColor = [UIColor clearColor];
//        self.backgroundColor = [UIColor clearColor];
        
        
        
        // 添加视频截图
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 120)];
        [self.contentView addSubview:image];
        self.videoImageView = image;
        
        UIImageView *image_2 = [[UIImageView alloc] initWithFrame:CGRectMake(283, 12, 25, 25)];
        [self.contentView addSubview:image_2];
        self.iconView = image_2;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, 12, 110, 22.5)];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel *praiseLabel = [[UILabel alloc] initWithFrame:CGRectMake(217, 75, 55, 33)];
        [self.contentView addSubview:praiseLabel];
        self.praiseLabel = praiseLabel;
        
        
        UIImageView *praiseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(175, 83, 20, 20)];
        praiseImageView.image = [UIImage imageNamed:@"redHeart"];
        [self.contentView addSubview:praiseImageView];
        
        // 圆形用户图像
        [image_2.layer setCornerRadius:CGRectGetHeight([image_2 bounds]) / 2];
        image_2.layer.masksToBounds = YES;
        
        // 字体为白色
        self.titleLabel.textColor = [UIColor whiteColor];
        self.praiseLabel.textColor = [UIColor whiteColor];
        
        // cell 被选中时为无色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}


// 自绘分割线
//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextFillRect(context, rect);
//    
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0xE2/255.0f green:0xE2/255.0f blue:0xE2/255.0f alpha:1].CGColor);
//    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 1, rect.size.width, 1));
//}


// 重写 set 方法
-(void) setVideoModel:(VideoModel *)videoModel
{
    _videoModel = videoModel;
    
    [self settingData];
}

// 对控件的数据进行设置
-(void) settingData
{
    self.videoImageView.image = [UIImage imageNamed:@""];
    
    self.iconView.image = [UIImage imageNamed:@""];
    
    self.titleLabel.text = @"";
    
    self.praiseLabel.text = @"37";
}


- (void)awakeFromNib
{
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
