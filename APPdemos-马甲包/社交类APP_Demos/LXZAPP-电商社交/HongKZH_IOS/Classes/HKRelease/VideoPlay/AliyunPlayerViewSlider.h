//
//  AliyunVodSlider.h
//

#import <UIKit/UIKit.h>

@class AliyunPlayerViewSlider;
@protocol AliyunPlayerViewSliderDelegate <NSObject>
- (void)aliyunPlayerViewSlider:(AliyunPlayerViewSlider *)slider clickedSlider:(float)sliderValue;
@end
@interface AliyunPlayerViewSlider : UISlider
@property (nonatomic, weak) id<AliyunPlayerViewSliderDelegate>sliderDelegate;


@end
