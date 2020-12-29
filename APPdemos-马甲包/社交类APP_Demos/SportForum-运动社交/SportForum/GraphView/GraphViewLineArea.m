#import "GraphViewLineArea.h"
#import "GraphLine.h"
#import "GraphPoint.h"
#import "NSDate+Graph.h"
#import "UIFont+Graph.h"
#import "UIColor+Graph.h"
#import <QuartzCore/QuartzCore.h>

@interface GraphViewLineArea()
@property (nonatomic, assign) CGFloat fOffsetX;
@property (nonatomic, assign) CGFloat fOffsetY;
@end

@implementation GraphViewLineArea

- (id)initWithFrame:(CGRect)frame StartDay:(NSDate*) startDate XOffset:(CGFloat) xOffSet YOffset:(CGFloat) yOffSet{
    self = [super initWithFrame:frame];
    if (self) {
        self.fOffsetX = xOffSet;
        self.fOffsetY = yOffSet;
        self.backgroundColor = [UIColor clearColor];
        self.labelMonth = [[UILabel alloc] initWithFrame:CGRectMake(self.fOffsetX, self.frame.size.height - self.fOffsetY / 2 - 7, 30, 20)];
        
        NSDate *localDateForDayNumber = [[startDate dateWithDaysAhead: 0] localDate];
        NSString *month = [localDateForDayNumber monthShortStringDescription];
        self.labelMonth.text = month;
        self.labelMonth.textColor = [UIColor colorWithRed:100.0/255.0 green:210.0/255.0 blue:1.0 alpha:1.0];
        self.labelMonth.backgroundColor = [UIColor clearColor];
        self.labelMonth.font = [UIFont fontWithName:@"VAGRounded-Light" size:10.0];
        //[self addSubview:self.labelMonth];
    }
    
    return self;
}

- (void)setLabelMonthText:(NSString*)strText Color:(UIColor*)color {
    self.labelMonth.text = strText;
    self.labelMonth.textColor = color;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIFont *font = [UIFont defaultGraphBoldFontWithSize: 11.];
	CGFloat step = (self.fMaxY - self.fMinY) / 5;
	NSInteger value = self.fMinY - step;
    
    for(int i = 0; i < 6; i++){
        float yOrigin = (i * step) * self.fSteps;
        value = value + step;
        
        //Horizontal dash
        [[UIColor lightGrayColor] set];
        UIBezierPath *bezier = [[UIBezierPath alloc] init];
        CGPoint startPoint = CGPointMake(self.fOffsetX, self.frame.size.height - yOrigin - self.fOffsetY);
        CGPoint endPoint = CGPointMake(self.frame.size.width - 0.25 * self.fOffsetX, self.frame.size.height - yOrigin - self.fOffsetY);
        
        [bezier moveToPoint:startPoint];
        [bezier addLineToPoint:endPoint];
        [bezier setLineWidth:.5f];
        [bezier setLineCapStyle:kCGLineCapSquare];
        
        //CGFloat dashPattern[2] = {6., 3.};
        //[bezier setLineDash:dashPattern count:2 phase:0];
        //[[UIColor graphHorizontalLineColor] set];
        [bezier stroke];
        
        NSString *valueString;
        //valueString = [valueToFormat stringValue];
        valueString = [NSString stringWithFormat:@"%d", value];
        [[UIColor darkGrayColor] set];
        CGRect valueStringRect = CGRectMake(5, self.frame.size.height - self.fOffsetY - yOrigin - 8.0f , self.fOffsetX, 20.0f);
        
        [valueString drawInRect:valueStringRect withFont:font
                  lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
        
        //Add unit-x.
        if (i == 5) {
            if (self.xUnit) {
                [self.xUnit drawInRect:CGRectMake(5, self.frame.size.height - yOrigin - self.fOffsetY - 25.0f, 100.0f, 20.0f) withFont:font
                         lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
            }
        }
    }
    
    //DrawAxisX
    /*UIBezierPath *bezier = [[UIBezierPath alloc] init];
    CGPoint startPoint = CGPointMake(self.fOffsetX, self.frame.size.height - self.fOffsetY);
    CGPoint endPoint = CGPointMake(self.fOffsetX, self.fOffsetY);
    [bezier moveToPoint:startPoint];
    [bezier addLineToPoint:endPoint];
    [bezier setLineWidth:1.f];
    [bezier setLineCapStyle:kCGLineCapSquare];
    
    [bezier stroke];
*/
}

@end
