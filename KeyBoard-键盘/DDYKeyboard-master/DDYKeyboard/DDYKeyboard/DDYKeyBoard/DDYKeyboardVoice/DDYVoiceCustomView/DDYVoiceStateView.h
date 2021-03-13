#import <UIKit/UIKit.h>
#import "DDYKeyboardConfig.h"

@interface DDYVoiceStateView : UIView
/** 各种状态 */
@property (nonatomic, assign) DDYVoiceState voiceState;
/** 播放进度 更改播放界面按钮圆形进度 */
@property (nonatomic, copy) void(^playProgress)(CGFloat progress);

/** 初始化 */
+ (instancetype)viewWithFrame:(CGRect)frame;

/** 开始录音 */
- (void)startRecord;
/** 结束录音 */
- (void)stopRecord;

@end
