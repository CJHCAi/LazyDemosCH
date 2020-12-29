//
//  ReminderFoot.m
//  StepUp
//
//  Created by syfll on 15/4/28.
//  Copyright (c) 2015年 JFT0M. All rights reserved.
//

#import "ReminderFoot.h"

@implementation ReminderFoot



+ (ReminderFoot*) CreateCell
{
    ReminderFoot * cell = [[[NSBundle mainBundle] loadNibNamed:@"ReminderFoot" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
    self->_reminderAppearance = [JFReminderAppearance new];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    
    //	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
    
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        
    }
    
    return self;
    
}

- (void)drawRect:(CGRect)rect
{
    CGRect imageRect = self.FootImageView.frame;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(ctx, kCGLineCapRound);  //边缘样式
    CGContextSetLineWidth(ctx, self.reminderAppearance.lineWidth); //线宽
    CGContextSetAllowsAntialiasing(ctx, YES);
    const CGFloat *components = CGColorGetComponents(self.reminderAppearance.lineColor.CGColor);
    CGContextSetRGBStrokeColor(ctx, components[0], components[1], components[2], components[3]);//颜色
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(ctx, imageRect.origin.x+imageRect.size.width/2,0);//起点坐标
    CGContextAddLineToPoint(ctx, imageRect.origin.x+imageRect.size.width/2, 10);//终点坐标
    CGContextDrawPath(ctx, kCGPathFillStroke);
    CGContextStrokePath(ctx);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
