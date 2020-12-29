//
//  YXWTaskTableViewCell.m
//  StarAlarm
//
//  Created by dllo on 16/4/7.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import "YXWTaskTableViewCell.h"
#define cellHeight 250
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
@implementation YXWTaskTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //取消选中效果
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        //裁剪看不到的
        self.clipsToBounds = YES;
        
        self.image = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.image.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.image];
        
        self.coverview = [[UIView alloc] initWithFrame:CGRectZero];
       self.coverview.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.33];
//        [self.contentView addSubview:self.coverview];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:self.titleLabel];
        
        self.hardView = [[YXWHardView alloc] init];
        
        [self.contentView addSubview:self.hardView];
        
        self.taskButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.taskButton setImage:[[UIImage imageNamed:@"yulan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.taskButton addTarget:self action:@selector(taskButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.taskButton];
        
//        self.smallView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        
//        [self.image addSubview:self.smallView];
        
    }
    return self;
}

-(void)taskButtonAction:(UIButton *)sender{
    
    [self.delegate pushVC:self.alermModel];
    
}

-(void)layoutSubviews {
    [super layoutSubviews];

    self.image.frame = CGRectMake(20,  - cellHeight / 2, kWidth - 40, cellHeight *2 );
    self.titleLabel.frame = CGRectMake(20, cellHeight / 2 - 30, kWidth - 40, 30);
    
    self.hardView.frame = CGRectMake(0, cellHeight/ 2 + 30, kWidth, 30);
    self.coverview.frame = CGRectMake(20, 0, kWidth - 40, cellHeight);
//    self.smallView.frame = CGRectMake(kWidth / 2 - 16, kHeight / 2 + 30, 32, 32);
    
    self.taskButton.frame = CGRectMake(kWidth - 65, 20, 45, 45);

}
-(CGFloat)cellOffset {
    CGRect toWindow = [self convertRect:self.bounds toView:self.window];
    
    //获取父视图的中心
    CGPoint windowCenter = self.superview.center;
    
    //cell在y轴上的位移  CGRectGetMidY之前讲过,获取中心Y值
    CGFloat cellOffsetY = CGRectGetMidY(toWindow) - windowCenter.y;
    
    //位移比例
    CGFloat offsetDig = 2 * cellOffsetY / self.superview.frame.size.height ;
    
    //要补偿的位移
    CGFloat offset =  -offsetDig * cellHeight/2;
    
    //让pictureViewY轴方向位移offset
    CGAffineTransform transY = CGAffineTransformMakeTranslation(0,offset);
    self.image.transform = transY;
    
    return offset;

    
}


-(void)setAlermModel:(YXWAlarmModel *)alermModel {
    _alermModel = alermModel;
    self.image.image = [UIImage imageNamed:alermModel.image];
    self.titleLabel.text = alermModel.title;
    self.hardView.hard = alermModel.hard.integerValue;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
