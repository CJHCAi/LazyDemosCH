//
//  ReminderCell.m
//  StepUp
//
//  Created by syfll on 15/4/28.
//  Copyright (c) 2015年 JFT0M. All rights reserved.
//

#import "ReminderCell.h"

@implementation ReminderCell


+ (ReminderCell*) CreateCell
{
    ReminderCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"ReminderCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)awakeFromNib {
    // Initialization code
    self->_reminderAppearance = [JFReminderAppearance new];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    CGRect imageRect = self.circleImageView.frame;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(ctx, kCGLineCapRound);  //边缘样式
    CGContextSetLineWidth(ctx, self.reminderAppearance.lineWidth); //线宽
    CGContextSetAllowsAntialiasing(ctx, YES);
    const CGFloat *components = CGColorGetComponents(self.reminderAppearance.lineColor.CGColor);
    CGContextSetRGBStrokeColor(ctx, components[0], components[1], components[2], components[3]);//颜色
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    //画竖线
    CGContextMoveToPoint(ctx, imageRect.origin.x+imageRect.size.width/2,0);//起点坐标
    CGContextAddLineToPoint(ctx, imageRect.origin.x+imageRect.size.width/2, self.frame.size.height);//终点坐标
    
    //画横线
    CGContextMoveToPoint(ctx, imageRect.origin.x+imageRect.size.width/2,self.frame.size.height);//起点坐标
    CGContextAddLineToPoint(ctx, self.frame.size.width - imageRect.origin.x, self.frame.size.height);//终点坐标
    
    CGContextDrawPath(ctx, kCGPathFillStroke);
    CGContextStrokePath(ctx);
}

@end
