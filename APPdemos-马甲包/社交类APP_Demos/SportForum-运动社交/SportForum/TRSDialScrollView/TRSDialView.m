/***************************************************
 *  ____              ___   ____                   *
 * |  _ \ __ _ _ __  ( _ ) / ___|  ___ __ _ _ __   *
 * | |_) / _` | '_ \ / _ \/\___ \ / __/ _` | '_ \  *
 * |  __/ (_| | | | | (_>  <___) | (_| (_| | | | | *
 * |_|   \__,_|_| |_|\___/\/____/ \___\__,_|_| |_| *
 *                                                 *
 ***************************************************/

#import "TRSDialView.h"

NSString * const kTRSDialViewDefaultFont = @"HelveticaNeue";

const NSInteger kTRSDialViewDefautLabelFontSize = 30;

const CGFloat kTRSDialViewDefaultMinorTickDistance = 16.0f;
const CGFloat kTRSDialViewDefaultMinorTickLength   = 19.0f;
const CGFloat KTRSDialViewDefaultMinorTickWidth    =  1.0f;

const NSInteger kTRSDialViewDefaultMajorTickDivisions = 10;
const CGFloat kTRSDialViewDefaultMajorTickLength      = 31.0f;
const CGFloat kTRSDialViewDefaultMajorTickWidth       = 4.0f;


@interface TRSDialView ()

@end

@implementation TRSDialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _minimum = 0;
        _maximum = 0;

        _minorTicksPerMajorTick = kTRSDialViewDefaultMajorTickDivisions;
        _minorTickDistance = kTRSDialViewDefaultMinorTickDistance;

        _backgroundColor = [UIColor grayColor];

        _labelStrokeColor = [UIColor colorWithRed:0.482 green:0.008 blue:0.027 alpha:1.000];
        _labelFillColor = [UIColor whiteColor];
        _labelStrokeWidth = 1.0;

        _labelFont = [UIFont fontWithName:kTRSDialViewDefaultFont
                                     size:kTRSDialViewDefautLabelFontSize];

        _minorTickColor = [UIColor colorWithWhite:0.158 alpha:1.000];
        _minorTickLength = kTRSDialViewDefaultMinorTickLength;
        _minorTickWidth = KTRSDialViewDefaultMinorTickWidth;

        _majorTickColor = [UIColor colorWithRed:0.482 green:0.008 blue:0.027 alpha:1.000];
        _majorTickLength = kTRSDialViewDefaultMajorTickLength;
        _majorTickWidth = kTRSDialViewDefaultMajorTickWidth;

        _shadowColor = [UIColor colorWithWhite:1.000 alpha:1.000];
        _shadowOffset = CGSizeMake(1, 1);
        _shadowBlur = 0.9f;

    }

    return self;
}

- (void)setDirection:(BOOL)isHorizontal
{
    _isHorizontal = isHorizontal;
    
}

- (void)setDialRangeFrom:(NSInteger)from to:(NSInteger)to {

    _minimum = from;
    _maximum = to;
    
    // Resize the frame of the view
    CGRect frame = self.frame;
    
    if(_isHorizontal)
    {
        frame.size.width = (_maximum - _minimum) * _minorTickDistance + self.superview.frame.size.width;
    }
    else
    {
        frame.size.height = (_maximum - _minimum) * _minorTickDistance + self.superview.frame.size.height;
    }
    
    NSLog(@"frame = %@", NSStringFromCGRect(frame));
    
    self.frame = frame;
}

#pragma mark - Drawing

- (void)drawLabelWithContext:(CGContextRef)context
                     atPoint:(CGPoint)point
                        text:(NSString *)text
                   fillColor:(UIColor *)fillColor
                 strokeColor:(UIColor *)strokeColor {
    CGSize boundingBox = [text sizeWithAttributes:@{NSFontAttributeName:self.labelFont}];
    
    if(_isHorizontal)
    {
        CGFloat label_y_offset = self.majorTickLength + (boundingBox.height / 2);
        
        // We want the label to be centered on the specified x value
        NSInteger label_x = point.x - (boundingBox.width / 2);
        
        CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        
        CGContextSetLineWidth(context, self.labelStrokeWidth);
        
        // Set the drawing mode based on the presence of the file and stroke colors
        CGTextDrawingMode mode = kCGTextFillStroke;
        
        if ((fillColor == nil) && (strokeColor == nil))
            mode = kCGTextInvisible;
        
        else if (fillColor == nil)
            mode = kCGTextStroke;
        
        else if (strokeColor == nil)
            mode = kCGTextFill;
        
        CGContextSetTextDrawingMode(context, mode);
        
        [text drawInRect:CGRectMake(label_x, point.y + label_y_offset, boundingBox.width, boundingBox.height)
                withFont:self.labelFont
           lineBreakMode:NSLineBreakByTruncatingTail
               alignment:NSTextAlignmentCenter];
    }
    else
    {
        CGFloat label_x_offset = self.majorTickLength + (boundingBox.width / 2);
        
        // We want the label to be centered on the specified y value
        NSInteger label_y = point.y - (boundingBox.height / 2);
        
        CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        
        CGContextSetLineWidth(context, self.labelStrokeWidth);
        
        // Set the drawing mode based on the presence of the file and stroke colors
        CGTextDrawingMode mode = kCGTextFillStroke;
        
        if ((fillColor == nil) && (strokeColor == nil))
            mode = kCGTextInvisible;
        
        else if (fillColor == nil)
            mode = kCGTextStroke;
        
        else if (strokeColor == nil)
            mode = kCGTextFill;
        
        CGContextSetTextDrawingMode(context, mode);
        
        [text drawInRect:CGRectMake(point.x + label_x_offset, label_y, boundingBox.width, boundingBox.height)
                withFont:self.labelFont
           lineBreakMode:NSLineBreakByTruncatingTail
               alignment:NSTextAlignmentCenter];
    }
}

- (void)drawMinorTickWithContext:(CGContextRef)context
                         atPoint:(CGPoint)point
                       withColor:(UIColor *)color
                           width:(CGFloat)width
                          length:(CGFloat)length {

    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, width);

    CGContextMoveToPoint(context, point.x, point.y);
    if(_isHorizontal)
    {
        CGContextAddLineToPoint(context, point.x, point.y + length);
    }
    else
    {
        CGContextAddLineToPoint(context, point.x + length, point.y);
    }

    CGContextStrokePath(context);
}

- (void)drawMajorTickWithContext:(CGContextRef)context
                         atPoint:(CGPoint)point
                       withColor:(UIColor *)color
                           width:(CGFloat)width
                          length:(CGFloat)length {

    // Draw the line
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, width);
    CGContextSetLineCap(context, kCGLineCapRound);

    CGContextMoveToPoint(context, point.x, point.y);
    if(_isHorizontal)
    {
        CGContextAddLineToPoint(context, point.x, point.y + length);
    }
    else
    {
        CGContextAddLineToPoint(context, point.x + length, point.y);
    }

    CGContextStrokePath(context);

}

- (void)drawTicksWithContext:(CGContextRef)context atX:(NSInteger)x
{

    CGPoint point = CGPointMake(x, 0);
    if(!_isHorizontal)
    {
        point = CGPointMake(0, x);
    }
    CGContextSetShadowWithColor(
        context,
        self.shadowOffset,
        self.shadowBlur,
        self.shadowColor.CGColor);

    NSInteger value = (x - self.leading) / self.minorTickDistance + _minimum - _offset;
    if(!_isHorizontal)
    {
        value = _maximum - ((x - self.leading) / self.minorTickDistance) - _offset;
    }
    
    if(value < _minimum || value > _maximum)
    {
        return;
    }
    
    if ([self isMajorTick:x]) {

        [self drawMajorTickWithContext:context
                               atPoint:point
                             withColor:self.majorTickColor
                                 width:self.majorTickWidth
                                length:self.majorTickLength];

        // Draw the text
        //
        // 1) Take the existing position and subtract off the lead spacing
        // 2) Divide by the minor ticks to get the major number
        // 3) Add the minimum to get the current value
        //

        NSString *text = @"";
        
        if (_dataFormat == DATA_FORMAT_DATE) {
            if (value % 20 == 0) {
                text = [NSString stringWithFormat:@"%02li:00", value / 20];
            }
            else
            {
                text = [NSString stringWithFormat:@"%02li:30", (value - 10) / 20];
            }
            
        }
        else
        {
            text = [NSString stringWithFormat:@"%li", value];
        }
        
        [self drawLabelWithContext:context
                           atPoint:point
                              text:text
                         fillColor:self.labelFillColor
                       strokeColor:self.labelStrokeColor];

    } else {

        // Save the current context so we revert some of the changes laster
        CGContextSaveGState(context);

        [self drawMinorTickWithContext:context
                               atPoint:point
                             withColor:self.minorTickColor
                                 width:self.minorTickWidth
                                length:self.minorTickLength];

        // Restore the context
        CGContextRestoreGState(context);
    }
}

/**
 * The number of pixels that need to be prepended to the begining and ending
 * of the dial to make sure that the center mark is able to reach all available
 * values on the range of the dial.
 */
- (NSInteger)leading
{
    if(_isHorizontal)
    {
        return self.superview.frame.size.width / 2;
    }
    else
    {
        return self.superview.frame.size.height / 2;
    }
}

/**
 * Perform Custom drawing
 */
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    NSLog(@"frame = %@\n", NSStringFromCGRect(rect));

    CGContextRef context = UIGraphicsGetCurrentContext();

    // Fill the background
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);

    CGContextFillRect(context, rect);
    
    // Add the tick Marks
    if(_isHorizontal)
    {
        for (NSInteger i = self.leading - (self.leading / self.minorTickDistance) * self.minorTickDistance; i < rect.size.width; i += self.minorTickDistance) {
            
            // After
            //if (i > (self.frame.size.width - self.leading))
            //    break;
            
            // Middle
            //else
                [self drawTicksWithContext:context atX:i];
        }
    }
    else
    {
        for (NSInteger i = self.leading - (self.leading / self.minorTickDistance) * self.minorTickDistance; i < rect.size.height; i += self.minorTickDistance) {
            
            // After
            //if (i > (self.frame.size.height - self.leading))
            //    break;
            
            // Middle
            //else
                [self drawTicksWithContext:context atX:i];
        }
    }
}

/**
 * Method to check if there is a major tick and the specified point offset
 * @param x [in] the pixel offset
 */
- (BOOL)isMajorTick:(NSInteger)x {

    NSInteger tick_number = (x - self.leading) / self.minorTickDistance - _offset * (_isHorizontal ? 1 : (-1));
    
    return (tick_number % self.minorTicksPerMajorTick) == 0;
}

@end

