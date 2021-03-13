#import "DDYVoiceStateView.h"

@interface DDYVoiceStateView ()
/** 准备中、按住说话等展示用的标签 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 准备中指示器 */
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

/** 振幅界面载体 */
@property (nonatomic, strong) UIView *contentView;
/** 录音时长标签 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 条状振幅波形 */
@property (nonatomic, strong) CAShapeLayer *levelLayer;
/** 对称复制图层 */
@property (nonatomic, strong) CAReplicatorLayer *replicatorLayer;
/** 当前振幅数组 */
@property (nonatomic, strong) NSMutableArray *levelArray;
/** 录音播放计时器 */
@property (nonatomic, strong) NSTimer *audioTimer;
/** 振幅计时器 */
@property (nonatomic, strong) CADisplayLink *levelTimer;
/** 录音时长 */
@property (nonatomic, assign) NSInteger duration;
/** 播放时振幅计时器 */
@property (nonatomic, strong) CADisplayLink *playTimer;

@end

@implementation DDYVoiceStateView

#pragma mark - lazy load
#pragma mark 准备中、按住说话等展示用的标签
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.ddy_W, 20)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = DDY_Mid_Black;
        _titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _titleLabel;
}

#pragma mark 准备中指示器
- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.hidesWhenStopped = YES;
    }
    return _activityView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.ddy_W, self.ddy_H)];
        _contentView.hidden = YES;
    }
    return _contentView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        //        _timeLabel = [];
    }
    return _timeLabel;
}

+ (instancetype)viewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

@end
