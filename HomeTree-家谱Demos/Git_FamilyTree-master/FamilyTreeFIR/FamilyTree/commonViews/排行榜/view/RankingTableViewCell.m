//
//  RankingTableViewCell.m
//  ListV
//
//  Created by imac on 16/7/20.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "RankingTableViewCell.h"

@interface RankingTableViewCell ()

@end

@implementation RankingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.3;
        _cellStyle = style;
        [self initView];
    }
    return self;
}

-(void)initView{
    
    [self removeAllSubviews];
    
    CGFloat w = __kWidth-30;
    NSInteger count = 5;
    
    if (_cellStyle ==UITableViewCellStyleValue1) {
        count=4;
    }
    
    _numberLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, w/count, 20)];
    [self addSubview:_numberLb];
    _numberLb.backgroundColor = [UIColor clearColor];
    _numberLb.font = MFont(14);
    _numberLb.textAlignment = NSTextAlignmentCenter;
    _numberLb.textColor = LH_RGBCOLOR(90, 90, 90);
    
   
        _nameLb = [[UILabel alloc]initWithFrame:CGRectMake((count-4)*w/count, 10, w/count, 20)];
     if (count==5) {
        [self addSubview:_nameLb];
     }
        _nameLb.backgroundColor = [UIColor clearColor];
        _nameLb.font = MFont(14);
        _nameLb.textAlignment = NSTextAlignmentCenter;
        _nameLb.textColor = LH_RGBCOLOR(90, 90, 90);
    

    _familyLb = [[UILabel alloc]initWithFrame:CGRectMake((count-3)*w/count, 10, w/count, 20)];
    [self addSubview:_familyLb];
    _familyLb.backgroundColor = [UIColor clearColor];
    _familyLb.font = MFont(14);
    _familyLb.textAlignment = NSTextAlignmentCenter;
    _familyLb.textColor = LH_RGBCOLOR(90, 90, 90);

    _activenessLb = [[UILabel alloc]initWithFrame:CGRectMake((count-2)*w/count, 10, w/count, 20)];
    [self addSubview:_activenessLb];
    _activenessLb.backgroundColor = [UIColor clearColor];
    _activenessLb.font = MFont(14);
    _activenessLb.textAlignment = NSTextAlignmentCenter;
    _activenessLb.textColor = LH_RGBCOLOR(90, 90, 90);

    _rewardLb = [[UILabel alloc]initWithFrame:CGRectMake((count-1)*w/count, 10, w/count, 20)];
    [self addSubview:_rewardLb];
    _rewardLb.backgroundColor = [UIColor clearColor];
    _rewardLb.font = MFont(14);
    _rewardLb.textAlignment = NSTextAlignmentCenter;
    _rewardLb.textColor = LH_RGBCOLOR(90, 90, 90);


}

-(void)drawRect:(CGRect)rect{
    CGContextRef line =UIGraphicsGetCurrentContext();
    CGContextSetLineCap(line, kCGLineCapSquare);
    CGContextBeginPath(line);
    CGContextSetLineWidth(line, 1);
    CGContextSetStrokeColorWithColor(line, LH_RGBCOLOR(220, 220, 220).CGColor);
    CGFloat lengths[] ={10,5};
    CGContextSetLineDash(line, 0, lengths, 1);
    CGContextMoveToPoint(line, 0, 33);
    CGContextAddLineToPoint(line, __kWidth-30, 33);
    CGContextStrokePath(line);
    CGContextClosePath(line);
}

@end
