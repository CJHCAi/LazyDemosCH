//
//  AliyunVodSlider.m
//

#import "AliyunPlayerViewSlider.h"
@implementation AliyunPlayerViewSlider

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value{
//    //返回滑块大小
//    rect.origin.x = rect.origin.x - 10 ;
//    rect.size.width = rect.size.width +20;
//    return CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 10 , 10);
//}

- (void)dealloc {
    DLog(@"%s",__func__);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGRect t = [self trackRectForBounds: [self bounds]];
    float v = [self minimumValue] + ([[touches anyObject] locationInView: self].x - t.origin.x - 4.0) * (([self maximumValue]-[self minimumValue]) / (t.size.width - 8.0));

    if ([self.sliderDelegate respondsToSelector:@selector(aliyunPlayerViewSlider:clickedSlider:)] ) {
        [self.sliderDelegate aliyunPlayerViewSlider:self clickedSlider:v];
    }
    [super touchesBegan: touches withEvent: event];
}





@end
