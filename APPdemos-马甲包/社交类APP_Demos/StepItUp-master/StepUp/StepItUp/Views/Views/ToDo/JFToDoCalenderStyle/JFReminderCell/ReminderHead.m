//
//  ReminderHead.m
//  StepUp
//
//  Created by syfll on 15/4/28.
//  Copyright (c) 2015年 JFT0M. All rights reserved.
//

#import "ReminderHead.h"

@implementation ReminderHead



+ (ReminderHead*) CreateCell
{
    ReminderHead * cell = [[[NSBundle mainBundle] loadNibNamed:@"ReminderHead" owner:self options:nil] objectAtIndex:0];
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
    CGRect imageRect = self.headCircleImageView.frame;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(ctx, kCGLineCapRound);  //边缘样式
    CGContextSetLineWidth(ctx, self.reminderAppearance.lineWidth); //线宽
    CGContextSetAllowsAntialiasing(ctx, YES);
    const CGFloat *components = CGColorGetComponents(self.reminderAppearance.lineColor.CGColor);
    CGContextSetRGBStrokeColor(ctx, components[0], components[1], components[2], components[3]);//颜色
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(ctx, imageRect.origin.x+imageRect.size.width/2,imageRect.origin.y+imageRect.size.height/2);//起点坐标
    CGContextAddLineToPoint(ctx, imageRect.origin.x+imageRect.size.width/2, self.frame.size.height);//终点坐标
    CGContextDrawPath(ctx, kCGPathFillStroke);
    CGContextStrokePath(ctx);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
