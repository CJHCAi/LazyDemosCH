//
//  DetailListCell.m
//  SeeFood
//
//  Created by 陈伟捷 on 15/11/24.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "DetailListCell.h"
#import <UIImageView+WebCache.h>

#define KScreenWidth [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface DetailListCell ()
{
    CGFloat height;
}

@end
@implementation DetailListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 不可选中
        self.selected = NO;

        height = KScreenWidth / 2;
        
        _myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenWidth / 2)];
        _myImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, height)];
        view.layer.masksToBounds = YES;
        [self.contentView addSubview:view];
        
        _myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (height - KScreenWidth) / 2, KScreenWidth, KScreenWidth)];
        self.myImageView.backgroundColor = [UIColor grayColor];
        [view addSubview:_myImageView];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, KScreenWidth / 2 - 30, KScreenWidth, 30)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:_titleLabel];

        UIImageView *labelBackImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, height - 50, KScreenWidth, 50)];
        labelBackImage.image = [UIImage imageNamed:@"Black"];
        [view addSubview:labelBackImage];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, height - 40, KScreenWidth, 30)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:20];
        [view addSubview:_titleLabel];

    }
    return self;
}

- (void)setModel:(DetailListModel *)model
{
    // 请求照片
    NSString *string = [model.albums firstObject];
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:string]];
    
    self.titleLabel.text = [NSString stringWithFormat:@"#%@", model.title];
}

+ (CGFloat)rowHeight:(DetailListModel *)model
{
    return KScreenWidth / 2;
}
@end
